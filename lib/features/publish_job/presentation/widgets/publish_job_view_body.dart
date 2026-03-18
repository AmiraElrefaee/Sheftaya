import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_institute_step_form.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/section_job_info_form.dart';
import 'package:sheftaya/features/publish_job/presentation/widgets/set_progress_indicator.dart';
import '../../../../core/constants/shared_pref_helper.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helper/location_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/model/job_details_response.dart';
import '../../data/model/publish_job.dart';
import '../mangers/job_publish_cubit/job_publish_cubit.dart';
import 'custom_app_bar.dart';
import 'custom_label_text.dart';
// استبدلي الـ import القديم بتاع الـ home/job_model بهذا السطر:
import '../../data/model/publish_job.dart'; // ده الـ JobModel الأساسي بتاع الصفحة

class PublishJobViewBody extends StatefulWidget {
  final JobDetails? existingJob;
  const PublishJobViewBody({super.key,  this.existingJob});

  @override
  State<PublishJobViewBody> createState() => _PublishJobViewBodyState();
}

class _PublishJobViewBodyState extends State<PublishJobViewBody> {
  String? selectedInstitution;
  int currentStep = 1;

  int days = 1, hours = 1, workers = 1;
  String experience = 'junior';

  final _formKey = GlobalKey<FormState>(); // ✅ Form key for validation

  final jobTitleController = TextEditingController();
  final jobLocationController = TextEditingController();
  final salaryController = TextEditingController();
  final detailsController = TextEditingController();
  final requirementsController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final institutionNameController = TextEditingController();
  final institutionAddressController = TextEditingController();
  final taxNumberController = TextEditingController();
  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationHelper.checkAndRequestLocation();
    });
    if (widget.existingJob != null) {
      final job = widget.existingJob!;
      jobTitleController.text = job.title;
      jobLocationController.text = job.address ?? '';
      salaryController.text = job.price.toString();
      detailsController.text = job.details ?? '';
      requirementsController.text = job.details ?? '';

      // تحويل التاريخ والوقت للعرض
      if (job.startDateTime != null) {
        DateTime parsedDate = DateTime.parse(job.startDateTime);
        dateController.text = DateFormat('yyyy-MM-dd').format(parsedDate!.toLocal());
        timeController.text = DateFormat('HH:mm').format(parsedDate!.toLocal());
      }

      // تحديث قيم الـ Counters
      // days = job. ?? 1;
      hours = job.dailyWorkHours;
      workers = job.requiredWorkers;
      experience = job.experienceLevel;
    }
    // _getUserCurrentLocation(); // جلب الموقع فور فتح الصفحة
  }

  // Future<void> _getUserCurrentLocation() async {
  //   try {
  //     Position position = await LocationHelper.determinePosition();
  //     setState(() {
  //       lat = position.latitude;
  //       long = position.longitude;
  //       // اختيارياً: يمكنك استخدام مكتبة geocoding لتحويل الإحداثيات لاسم منطقة وتضعيه في الـ controller
  //       jobLocationController.text = "موقعي الحالي";
  //     });
  //   } catch (e) {
  //     print("Location Error: $e");
  //   }
  // }
  void _onPublish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final dateParts = dateController.text.split('-');
      final timeParts = timeController.text.split(':');

      // إنشاء DateTime بالتوقيت المحلي
      final DateTime localDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      // التحويل لـ UTC قبل الإرسال
      final DateTime utcStart = localDateTime.toUtc();
      final DateTime utcEnd = utcStart.add(Duration(days: days));
      double dailySalary = double.tryParse(salaryController.text) ?? 0;

      double savedLat = await SharedPrefHelper.getDouble(SharedPrefKeys.lastLatitude);
      double savedLong = await SharedPrefHelper.getDouble(SharedPrefKeys.lastLongitude);

      // ✅ قمنا بتسمية المتغير jobData ليتوافق مع الاستخدام تحت
      final jobData = JobModel(
        title: jobTitleController.text,
        place: selectedInstitution ?? "المؤسسة المسجلة",
        longitude: savedLong != 0.0 ? savedLong : 31.2357, // تأكدي من ترتيب الإحداثيات
        latitude: savedLat != 0.0 ? savedLat : 30.0444,
        mainPlace: jobLocationController.text,
        address: jobLocationController.text,
        startDateTime: utcStart,
        endDateTime: utcEnd,
        dailyWorkHours: hours,
        requiredWorkers: workers,
        pricePerHour: (hours > 0) ? (dailySalary / hours).toInt() : 0,
        experienceLevel: experience,
        details: detailsController.text,
        paymentMethod: "card",
      );

      print("📦 Job JSON to be sent: ${jobData.toJson()}");

      if (widget.existingJob != null) {
        // ✅ الآن jobData معرف والـ id سيتم سحبه من existingJob
        context.read<JobPublishCubit>().updateJob(widget.existingJob!.id, jobData);
      } else {
        // ✅ تم تصحيح الاسم هنا أيضاً
        context.read<JobPublishCubit>().createJob(jobData);
      }

    } catch (e, stacktrace) {
      print("❌ [ERROR] in _onPublish Logic: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ في معالجة البيانات: $e")),
      );
    }
  }
  // void _onPublish()async {
  //   if (!_formKey.currentState!.validate()) {
  //     // Form is invalid, show errors
  //     return;
  //   }
  //
  //   try {
  //
  //     final dateParts = dateController.text.split('-');
  //     final timeParts = timeController.text.split(':');
  //
  //     // إنشاء DateTime بالتوقيت المحلي (Local - توقيت مصر)
  //     final DateTime localDateTime = DateTime(
  //       int.parse(dateParts[0]),
  //       int.parse(dateParts[1]),
  //       int.parse(dateParts[2]),
  //       int.parse(timeParts[0]),
  //       int.parse(timeParts[1]),
  //     );
  //
  //     // التحويل لـ UTC قبل الإرسال
  //     final DateTime utcStart = localDateTime.toUtc();
  //     final DateTime utcEnd = utcStart.add(Duration(days: days));
  //     double dailySalary = double.tryParse(salaryController.text) ?? 0;
  //
  //
  //     double savedLat = await SharedPrefHelper.getDouble(SharedPrefKeys.lastLatitude);
  //     double savedLong = await SharedPrefHelper.getDouble(SharedPrefKeys.lastLongitude);
  //
  //     print("heeer location      ${savedLat}");
  //     final job = JobModel(
  //       title: jobTitleController.text,
  //       place: selectedInstitution ?? "المؤسسة المسجلة",
  //       longitude: savedLat ?? 31.2357,
  //       latitude: savedLong ?? 30.0444,
  //       mainPlace: jobLocationController.text,
  //       address: jobLocationController.text,
  //       // startDateTime: startDateTime.toUtc(), // ✅ DateTime object
  //       // endDateTime: endDateTime.toUtc(),
  //       // ✅ DateTime object
  //       startDateTime: utcStart, // سيرسل كـ 2026-03-16T02:26...Z
  //       endDateTime: utcEnd,
  //       dailyWorkHours: hours,
  //       requiredWorkers: workers,
  //         // pricePerHour: dailySalary.toInt(),
  //         pricePerHour: (hours > 0) ? (dailySalary / hours).toInt() : 0,
  //       experienceLevel: experience,
  //       details: detailsController.text,
  //       paymentMethod: "card",
  //     );
  //
  //     print("📦 Job JSON to be sent: ${job.toJson()}");
  //     // context.read<JobPublishCubit>().createJob(job);
  //     if (widget.existingJob != null) {
  //       // بنادي الـ Update وبنبعت الـ id بتاع الـ JobDetails اللي جاي من صفحة النجاح
  //       context.read<JobPublishCubit>().updateJob(widget.existingJob!.id, jobData);
  //     } else {
  //       context.read<JobPublishCubit>().createJob(jobData);
  //     }
  //
  //   } catch (e, stacktrace) {
  //     print("❌ [ERROR] in _onPublish Logic: $e");
  //     print("🔎 Stacktrace: $stacktrace");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("حدث خطأ في معالجة البيانات: $e")),
  //     );
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    bool isNewLocationMode = selectedInstitution == 'إضافة مؤسسة أخرى';

    return BlocListener<JobPublishCubit, JobPublishState>(
      listener: (context, state) {
        if (state is PublishJobSuccess) {
          context.push(
            AppRouter.kJobPublishSuccessScreen,
            extra: state.jobId,
          );
        } else if (state is PublishJobError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMes), backgroundColor: Colors.red),
          );
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Form( // ✅ Wrap everything in Form
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(title: 'نشر وظيفة'),
                      const CustomLabelText(text: 'مكان العمل'),
                      AppDropdown(
                        items: const ['المؤسسة المسجلة (كافيه 88 cups)', "كافيه", 'إضافة مؤسسة أخرى'],
                        value: selectedInstitution,
                        onChanged: (val) {
                          setState(() {
                            selectedInstitution = val;
                            currentStep = 1;
                          });
                        },
                        hint: 'المؤسسة المسجلة (كافيه 88 cups)',
                        // ✅ Required field validator
                      ),
                      if (isNewLocationMode) ...[
                        SizedBox(height: 20.h),
                        StepProgressIndicator(
                          currentStep: currentStep,
                          onStepOneTap: () {
                            if (currentStep == 2) {
                              setState(() {
                                currentStep = 1;
                              });
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                  _buildDynamicContent(isNewLocationMode),
                  _buildBottomButton(isNewLocationMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicContent(bool isNewLocationMode) {
    if (isNewLocationMode && currentStep == 1) {
      return InstitutionStepForm(
        nameController: institutionNameController,
        addressController: institutionAddressController,
        taxController: taxNumberController,
      );
    }

    return JobInfoStepForm(
      titleController: jobTitleController,
      locationController: jobLocationController,
      salaryController: salaryController,
      detailsController: detailsController,
      reqController: requirementsController,
      dateController: dateController,
      timeController: timeController,
      onDaysChanged: (val) => days = val,
      onHoursChanged: (val) => hours = val,
      onWorkersChanged: (val) => workers = val,
      onExperienceChanged: (val) => setState(() => experience = _mapExperience(val)),

      // ✅ Add validators for required fields inside JobInfoStepForm
    );
  }

  Widget _buildBottomButton(bool isNewLocationMode) {
    String buttonText = (isNewLocationMode && currentStep == 1) ? "التالي" : "نشر الوظيفة";

    return Padding(
      padding: EdgeInsets.all(15.w),
      child: AppTextButton(
        buttonText: buttonText,
        onPressed: () {
          if (isNewLocationMode && currentStep == 1) {
            setState(() => currentStep = 2);
          } else {
            _onPublish();
          }
        },
      ),
    );
  }

  String _mapExperience(String? val) {
    if (val == '1-3 سنوات') return 'mid-level';
    if (val == 'أكثر من 3 سنوات') return 'senior';
    return 'junior';
  }
}