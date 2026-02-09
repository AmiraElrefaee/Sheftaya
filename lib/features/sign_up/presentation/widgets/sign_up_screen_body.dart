import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_toggle_button.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/employer_sign_up.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/worker_sign_up.dart';
import 'personal_info_step.dart';
import 'proof_of_identity_step.dart';

enum SignUpRole { worker, employer }

class SignUpScreenBody extends StatefulWidget {
  const SignUpScreenBody({super.key});

  @override
  State<SignUpScreenBody> createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  SignUpRole _role = SignUpRole.worker;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  String? selectedGovernorate;
  DateTime? selectedDate;

  File? idFront;
  File? idBack;
  File? personalPhoto;

  final TextEditingController educationController = TextEditingController();
  String? workerStatus;
  List<String> previousJobs = [];
  List<String> dailyJobs = [];
  List<String> searchingJobs = [];
  File? healthCertificate;

  final TextEditingController institutionNameController =
      TextEditingController();
  String? institutionType;
  List<String> availableJobs = [];
  final TextEditingController institutionAddressController =
      TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  File? institutionImages;

  final ImagePicker _picker = ImagePicker();

  final List<String> governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'القليوبية',
    'البحيرة',
    'الدقهلية',
    'الشرقية',
    'الغربية',
    'المنوفية',
    'كفر الشيخ',
    'دمياط',
    'بورسعيد',
    'الإسماعيلية',
    'السويس',
    'شمال سيناء',
    'جنوب سيناء',
    'بني سويف',
    'الفيوم',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'البحر الأحمر',
    'الوادي الجديد',
    'مطروح',
  ];

  final List<String> sampleJobs = [
    'طباخ',
    'مساعد طباخ',
    'شيف حلويات',
    'عامل مطبخ',
    'غسال أطباق',
    'عامل نظافة',
    'خادمة منزلية',
    'جليسة أطفال',
    'جليسة كبار سن',
    'عامل مغسلة',
    'عامل كيّ ملابس',
    'عامل تعبئة وتغليف',
    'عامل مخزن',
    'عامل تحميل وتنزيل',
    'عامل توصيل',
    'سائق',
    'عامل سوبر ماركت',
    'عامل مطعم',
    'كاشير',
    'خدمة عملاء',
    'استقبال',
    'عامل صيانة',
    'سباك',
    'كهربائي',
    'نجار',
    'عامل تركيب',
    'عامل دهانات',
    'حارس',
    'بواب',
    'أمن',
    'مزارع',
    'عامل زراعي',
    'عامل مزرعة دواجن',
    'عامل أسماك',
    'عامل غسيل سيارات',
    'عامل محطة وقود',
    'عامل مغسلة سيارات',
    'بائع',
    'مندوب مبيعات',
    'مساعد إداري',
    'سكرتير',
    'آخر',
  ];

  // generic pick image
  Future<File?> _pickImage({bool pickImageOnly = true}) async {
    try {
      if (pickImageOnly) {
        final XFile? picked = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
        );
        if (picked != null) return File(picked.path);
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        );
        if (result != null && result.files.single.path != null) {
          return File(result.files.single.path!);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void _nextPage() {
    if (_pageIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _submit();
    }
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    final proofOk = idFront != null && idBack != null;

    bool roleOk = true;
    if (_role == SignUpRole.worker) {
      if (workerStatus == null || workerStatus!.isEmpty) roleOk = false;
      if (searchingJobs.isEmpty) roleOk = false;
    } else {
      if (institutionNameController.text.trim().isEmpty) roleOk = false;
      if (institutionType == null || institutionType!.isEmpty) roleOk = false;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إكمال الحقول المطلوبة')),
      );
      return;
    }

    if (!proofOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى رفع صورة وجه وخلفية البطاقة')),
      );
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return;
    }

    if (!roleOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إكمال بيانات المرحلة الأخيرة')),
      );
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return;
    }

    // // Build payload
    // final Map<String, dynamic> payload = {
    //   'first_name': firstNameController.text.trim(),
    //   'last_name': lastNameController.text.trim(),
    //   'email': emailController.text.trim(),
    //   'phone': phoneController.text.trim(),
    //   'password': passwordController.text,
    //   'governorate': selectedGovernorate,
    //   'date_of_birth': selectedDate?.toIso8601String(),
    //   'role': _role == SignUpRole.worker ? 'worker' : 'employer',
    //   // proofs/files: send multipart files
    //   // worker fields
    //   'education': educationController.text.trim(),
    //   'worker_status': workerStatus,
    //   'previous_jobs': previousJobs,
    //   'daily_jobs': dailyJobs,
    //   'searching_jobs': searchingJobs,
    //   // employer fields
    //   'institution_name': institutionNameController.text.trim(),
    //   'institution_type': institutionType,
    //   'available_jobs': availableJobs,
    //   'institution_address': institutionAddressController.text.trim(),
    //   'tax_number': taxNumberController.text.trim(),
    // };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorsManager.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إنشاء حساب',
                style: TextStyles.font24BlackBold.copyWith(fontSize: 40.sp),
              ),
              SizedBox(height: 12.h),
              CustomToggleButton(
                labels: ['باحث عن عمل', 'صاحب العمل'],
                initialIndex: _role == SignUpRole.employer ? 1 : 0,
                onToggle: (index) {
                  setState(() {
                    _role = index == 1
                        ? SignUpRole.employer
                        : SignUpRole.worker;
                  });
                },
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final active = _pageIndex == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    width: active ? 28.w : 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: active
                          ? ColorsManager.primary
                          : ColorsManager.lightGrey,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  );
                }),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (idx) {
                    setState(() => _pageIndex = idx);
                  },
                  children: [
                    SingleChildScrollView(
                      child: PersonalInfoStep(
                        formKey: _formKey,
                        firstNameController: firstNameController,
                        lastNameController: lastNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        passwordController: passwordController,
                        passwordConfirmController: passwordConfirmController,
                        governorates: governorates,
                        selectedGovernorate: selectedGovernorate,
                        onGovernorateChanged: (v) =>
                            setState(() => selectedGovernorate = v),
                        selectedDate: selectedDate,
                        onPickDate: (d) => setState(() => selectedDate = d),
                      ),
                    ),
                    SingleChildScrollView(
                      child: ProofOfIdentityStep(
                        idFront: idFront,
                        idBack: idBack,
                        personalPhoto: personalPhoto,
                        onPickIdFront: () async {
                          final f = await _pickImage();
                          if (f != null) setState(() => idFront = f);
                        },
                        onPickIdBack: () async {
                          final f = await _pickImage();
                          if (f != null) setState(() => idBack = f);
                        },
                        onPickPersonalPhoto: () async {
                          final f = await _pickImage();
                          if (f != null) setState(() => personalPhoto = f);
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: _role == SignUpRole.worker
                            ? WorkerSignUp(
                                educationController: educationController,
                                workerStatus: workerStatus,
                                onStatusChanged: (v) =>
                                    setState(() => workerStatus = v),
                                previousJobs: previousJobs,
                                dailyJobs: dailyJobs,
                                searchingJobs: searchingJobs,
                                onPreviousJobsChanged: (list) =>
                                    setState(() => previousJobs = list),
                                onDailyJobsChanged: (list) =>
                                    setState(() => dailyJobs = list),
                                onSearchingJobsChanged: (list) =>
                                    setState(() => searchingJobs = list),
                                sampleJobs: sampleJobs,
                                healthCertificate: healthCertificate,
                                onPickHealthCert: () async {
                                  final f = await _pickImage(
                                    pickImageOnly: false,
                                  );
                                  if (f != null) {
                                    setState(() => healthCertificate = f);
                                  }
                                },
                              )
                            : EmployerSignUp(
                                institutionNameController:
                                    institutionNameController,
                                institutionType: institutionType,
                                onTypeChanged: (v) =>
                                    setState(() => institutionType = v),
                                availableJobs: availableJobs,
                                onAvailableJobsChanged: (list) =>
                                    setState(() => availableJobs = list),
                                sampleJobs: sampleJobs,
                                institutionAddressController:
                                    institutionAddressController,
                                taxNumberController: taxNumberController,
                                onPickInstitutionImages: () async {
                                  final f = await _pickImage(
                                    pickImageOnly: false,
                                  );
                                  if (f != null) {
                                    setState(() => institutionImages = f);
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              AppTextButton(
                buttonText: _pageIndex < 2 ? 'التالي' : 'سجل الآن',
                onPressed: () {
                  if (_pageIndex < 2) {
                    _nextPage();
                  } else {
                    _submit();
                  }
                },
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لديك حساب بالفعل؟ ',
                    style: TextStyles.font14BlackRegular.copyWith(
                      color: ColorsManager.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text(
                      'سجل الدخول',
                      style: TextStyles.font14PrimaryBold.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: ColorsManager.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
