// lib/features/publish_job/presentation/widgets/publish_job_view_body.dart

import 'dart:convert';

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
import '../../data/api_service/company_service.dart';
import '../../data/model/job_details_response.dart';
import '../../data/model/publish_job.dart';
import '../../data/model/company_model.dart';
import '../mangers/job_publish_cubit/job_publish_cubit.dart';
import 'custom_app_bar.dart';
import 'custom_label_text.dart';

class PublishJobViewBody extends StatefulWidget {
  final JobDetails? existingJob;
  const PublishJobViewBody({super.key, this.existingJob});

  @override
  State<PublishJobViewBody> createState() => _PublishJobViewBodyState();
}

class _PublishJobViewBodyState extends State<PublishJobViewBody> {
  String? selectedInstitution;
  int currentStep = 1;

  int days = 1, hours = 1, workers = 1;
  String experience = 'junior';

  final _formKey = GlobalKey<FormState>();

  final jobTitleController = TextEditingController();
  final jobLocationController = TextEditingController();
  final salaryController = TextEditingController();
  final detailsController = TextEditingController();
  final requirementsController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final institutionNameController = TextEditingController();
  final institutionAddressController = TextEditingController();
  final institutionTypeController = TextEditingController();
  final taxNumberController = TextEditingController();

  double? pickedLat;
  double? pickedLng;

  // ✅ قائمة المؤسسات
  List<CompanyModel> _companies = [];
  bool _isLoading = true;

  // ✅ حالة الـ Checkbox
  bool _isTermsAccepted = false;

  // ✅ صور المؤسسة
  List<String> _companyImages = [];

  @override
  void initState() {
    super.initState();
    _loadCompanies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationHelper.checkAndRequestLocation();
    });

    if (widget.existingJob != null) {
      _loadExistingJobData();
    }
  }

  // ✅ تحميل المؤسسات
  Future<void> _loadCompanies() async {
    setState(() => _isLoading = true);
    final companies = await CompanyService.getCompanies();

    setState(() {
      _companies = companies;
      _isLoading = false;

      // ✅ إذا فيه مؤسسات، اختار آخر واحدة كـ default
      if (_companies.isNotEmpty) {
        selectedInstitution = _companies.last.name;
      }
    });
  }

  void _loadExistingJobData() {
    final job = widget.existingJob!;
    jobTitleController.text = job.title;
    jobLocationController.text = job.address ?? '';
    salaryController.text = job.price.toString();
    detailsController.text = job.details ?? '';
    requirementsController.text = job.details ?? '';

    if (job.startDateTime != null) {
      DateTime parsedDate = DateTime.parse(job.startDateTime);
      dateController.text = DateFormat('yyyy-MM-dd').format(parsedDate.toLocal());
      timeController.text = DateFormat('HH:mm').format(parsedDate.toLocal());
    }

    hours = job.dailyWorkHours;
    workers = job.requiredWorkers;
    experience = job.experienceLevel;
  }

  // ✅ دالة لتحديث حالة الـ Checkbox
  void _onTermsChanged(bool value) {
    setState(() {
      _isTermsAccepted = value;
    });
  }

  // ✅ دالة لتحديث الصور
  void _onCompanyImagesChanged(List<String> images) {
    setState(() {
      _companyImages = images;
    });
  }

  void _onPublish() async {
    // ✅ التحقق من الموافقة على الشروط
    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على سياسة الدفع وشروط نشر الوظائف'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      final dateParts = dateController.text.split('-');
      final timeParts = timeController.text.split(':');

      final DateTime localStart = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      final DateTime utcStart = localStart.toUtc();
      final DateTime utcEnd = utcStart
          .add(Duration(days: days - 1))
          .add(Duration(hours: hours));

      double dailySalary = double.tryParse(salaryController.text) ?? 0;

      // ✅ إذا كان المستخدم أضاف مؤسسة جديدة
      if (selectedInstitution == 'إضافة مؤسسة أخرى') {
        // ✅ حفظ المؤسسة الجديدة مع الصور
        final newCompany = CompanyModel(
          id: CompanyService.generateId(),
          name: institutionNameController.text,
          type: institutionTypeController.text,
          address: institutionAddressController.text,
          taxNumber: taxNumberController.text,
          city: 'بورسعيد',
          images: _companyImages, // ✅ إضافة الصور
        );

        await CompanyService.addCompany(newCompany);
        await _loadCompanies();

        // ✅ اختيار المؤسسة الجديدة
        selectedInstitution = newCompany.name;
      }

      // في publish_job_view_body.dart - _onPublish()

      // في publish_job_view_body.dart - _onPublish()

      // في publish_job_view_body.dart - _onPublish()

      if (widget.existingJob != null) {
        final locationMap = {
          "type": "Point",
          "coordinates": [pickedLng ?? 31.2357, pickedLat ?? 30.0444],
          "mainPlace": jobLocationController.text,
          "address": jobLocationController.text,
        };

        final updateData = {
          "title": jobTitleController.text,
          "place": selectedInstitution ?? "المؤسسة المسجلة",
          // ✅ ✅ ✅ الحل السحري: jsonDecode + jsonEncode
          "location": jsonDecode(jsonEncode(locationMap)),
          "dailyWorkHours": hours,
          "requiredWorkers": workers,
          "pricePerHour": {
            "amount": (hours > 0) ? (dailySalary / hours).toInt() : 0,
            "currency": "EGP",
          },
          "experienceLevel": experience,
          "details": detailsController.text,
          "paymentMethod": "card",
        };

        print('📦 Update Data: $updateData');

        context.read<JobPublishCubit>().updateJob(
          widget.existingJob!.id,
          updateData,
        );
      }else {
        final jobData = JobModel(
          title: jobTitleController.text,
          place: selectedInstitution ?? "المؤسسة المسجلة",
          longitude: pickedLng ?? 31.2357,
          latitude: pickedLat ?? 30.0444,
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

        print('📦 Sending JSON: ${jobData.toJson()}');

        context.read<JobPublishCubit>().createJob(jobData);
      }
    } catch (e, stacktrace) {
      print("❌ ERROR: $e");
      print(stacktrace);
    }
  }

  // ✅ بناء قائمة الـ Dropdown من المؤسسات المحفوظة
  List<String> get _companyDropdownItems {
    final List<String> items = [];
    for (final company in _companies) {
      items.add(company.name);
    }
    items.add('إضافة مؤسسة أخرى');
    return items;
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(title: 'نشر وظيفة'),
                      const CustomLabelText(text: 'مكان العمل'),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        AppDropdown(
                          items: _companyDropdownItems,
                          value: selectedInstitution,
                          onChanged: (val) {
                            setState(() {
                              selectedInstitution = val;
                              if (val != 'إضافة مؤسسة أخرى') {
                                currentStep = 1;
                              }
                            });
                          },
                          hint: _companies.isNotEmpty
                              ? _companies.last.name
                              : 'اختر مؤسستك',
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
        typeController: institutionTypeController,
        onImagesChanged: _onCompanyImagesChanged, // ✅ تمرير
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
      onDaysChanged: (val) => setState(() => days = val),
      onHoursChanged: (val) => setState(() => hours = val),
      onWorkersChanged: (val) => setState(() => workers = val),
      onExperienceChanged: (val) => setState(() => experience = _mapExperience(val)),
      onLocationSelected: (latValue, lngValue) {
        setState(() {
          pickedLat = latValue;
          pickedLng = lngValue;
        });
      },
      onTermsChanged: _onTermsChanged, // ✅ تمرير الـ Callback
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
    if (val == 'بدون خبره' || val == 'أقل من سنة') return 'junior';
    if (val == '1-3 سنوات') return 'mid';
    if (val == 'أكثر من 3 سنوات') return 'senior';
    return 'junior';
  }
}