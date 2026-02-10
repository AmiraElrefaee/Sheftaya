import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sheftaya/app/router.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_toggle_button.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_state.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/employer_sign_up.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/worker_sign_up.dart';
import 'personal_info_step.dart';
import 'proof_of_identity_step.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum SignUpRole { worker, employer }

class SignUpScreenBody extends StatefulWidget {
  const SignUpScreenBody({super.key});

  @override
  State<SignUpScreenBody> createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  String? selectedGovernorate;
  DateTime? selectedDate;

  String? workerStatus;
  List<String> previousJobs = [];
  List<String> dailyJobs = [];
  List<String> searchingJobs = [];

  String? institutionType;
  List<String> availableJobs = [];
  String? institutiSelectedGovernorate;

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

  bool _showGovernorateError = false;
  bool _showWorkerStatusError = false;
  bool _showSearchingJobsError = false;
  bool _showPreviousJobsError = false;
  bool _showEducationError = false;

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
    }
  }

  Future<void> _submit(SignupCubit? cubit) async {
    if (cubit == null) return;

    if (selectedDate != null) {
      cubit.birthDateController.text =
          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
    } else {
      cubit.birthDateController.text = '';
    }

    cubit.cityController.text = selectedGovernorate ?? '';

    if (cubit.selectedRole == 'worker') {
      cubit.professionalStatusController.text = workerStatus ?? '';
      cubit.pastExperience = previousJobs;
      cubit.jobsLookedFor = searchingJobs;
    } else {
      cubit.companyTypeController.text = institutionType ?? '';
      cubit.companyCityController.text = institutiSelectedGovernorate ?? '';
    }

    final isValid = cubit.formKey.currentState?.validate() ?? false;
    final isGovernorateSelected = selectedGovernorate != null;

    if (!isValid || !isGovernorateSelected) {
      if (!isValid) {
        customSnackBar(
          context,
          'يرجى إكمال الحقول المطلوبة بشكل صحيح',
          ColorsManager.error,
        );
      }
      setState(() {
        _showGovernorateError = !isGovernorateSelected;
      });
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return;
    }

    final proofOk = cubit.frontIdImage != null && cubit.backIdImage != null;
    if (!proofOk) {
      customSnackBar(
        context,
        'يرجى إرفاق صورتي وجه وخلف البطاقة',
        ColorsManager.error,
      );
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return;
    }

    if (cubit.selectedRole == 'worker') {
      final isWorkerStatusSelected =
          workerStatus != null && workerStatus!.isNotEmpty;
      final isPreviousJobsSelected = previousJobs.isNotEmpty;
      final isSearchingJobsSelected = searchingJobs.isNotEmpty;
      final isEducationFilled = cubit.educationController.text
          .trim()
          .isNotEmpty;

      if (!isWorkerStatusSelected ||
          !isPreviousJobsSelected ||
          !isSearchingJobsSelected ||
          !isEducationFilled) {
        setState(() {
          _showWorkerStatusError = !isWorkerStatusSelected;
          _showPreviousJobsError = !isPreviousJobsSelected;
          _showSearchingJobsError = !isSearchingJobsSelected;
          _showEducationError = !isEducationFilled;
        });

        customSnackBar(
          context,
          'يرجى إكمال جميع الحقول المطلوبة في المعلومات المهنية',
          ColorsManager.error,
        );

        _pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        return;
      }
    }

    await SharedPrefHelper.setSecuredString(
      SharedPrefKeys.userEmail,
      cubit.emailController.text.trim(),
    );
    await cubit.emitSignupStates();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (data) async {
            final messenger = ScaffoldMessenger.of(context);
            final router = GoRouter.of(context);
            final cubit = context.read<SignupCubit>();

            if (!mounted) return;

            messenger.showSnackBar(
              SnackBar(
                content: const Text(
                  'تم إنشاء الحساب بنجاح! يرجى تأكيد بريدك الإلكتروني',
                ),
                backgroundColor: ColorsManager.success,
              ),
            );

            router.push(
              AppRouter.kVerifyAccountScreen,
              extra: cubit.selectedRole,
            );
          },
          error: (error) {
            customSnackBar(context, error, ColorsManager.error);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<SignupCubit>();
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(),
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
                    initialIndex: cubit.selectedRole == 'employer' ? 1 : 0,
                    onToggle: (index) {
                      setState(() {
                        cubit.setRole(index == 1 ? 'employer' : 'worker');
                      });
                    },
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: 12.r,
                        dotWidth: 12.r,
                        spacing: 8.w,
                        activeDotColor: ColorsManager.primary,
                        dotColor: ColorsManager.lightGrey,
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (idx) => setState(() => _pageIndex = idx),
                      children: [
                        SingleChildScrollView(
                          child: PersonalInfoStep(
                            formKey: cubit.formKey,
                            firstNameController: cubit.firstNameController,
                            lastNameController: cubit.lastNameController,
                            emailController: cubit.emailController,
                            phoneController: cubit.phoneController,
                            passwordController: cubit.passwordController,
                            passwordConfirmController:
                                cubit.passwordConfirmController,
                            governorates: governorates,
                            selectedGovernorate: selectedGovernorate,
                            onGovernorateChanged: (v) {
                              setState(() {
                                selectedGovernorate = v;
                                _showGovernorateError = false;
                              });
                            },
                            selectedDate: selectedDate,
                            onPickDate: (d) => setState(() => selectedDate = d),
                            dateController: cubit.birthDateController,
                            showGovernorateError: _showGovernorateError,
                          ),
                        ),
                        SingleChildScrollView(
                          child: ProofOfIdentityStep(
                            idFront: cubit.frontIdImage,
                            idBack: cubit.backIdImage,
                            personalPhoto: cubit.selfieImage,
                            onPickIdFront: () async {
                              final f = await _pickImage();
                              if (f != null) {
                                setState(() => cubit.setFrontIdImage(f));
                              }
                            },
                            onPickIdBack: () async {
                              final f = await _pickImage();
                              if (f != null) {
                                setState(() => cubit.setBackIdImage(f));
                              }
                            },
                            onPickPersonalPhoto: () async {
                              final f = await _pickImage();
                              if (f != null) {
                                setState(() => cubit.setSelfieImage(f));
                              }
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 24.h),
                            child: cubit.selectedRole == 'worker'
                                ? WorkerSignUp(
                                    educationController:
                                        cubit.educationController,
                                    workerStatus: workerStatus,
                                    onStatusChanged: (v) {
                                      setState(() => workerStatus = v);
                                    },
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
                                    healthCertificate: cubit.healthCertificate,
                                    onPickHealthCert: () async {
                                      final f = await _pickImage(
                                        pickImageOnly: false,
                                      );
                                      if (f != null) {
                                        cubit.setHealthCertificate(f);
                                      }
                                    },
                                    showWorkerStatusError:
                                        _showWorkerStatusError,
                                    showPreviousJobsError:
                                        _showPreviousJobsError,
                                    showSearchingJobsError:
                                        _showSearchingJobsError,
                                    showEducationError: _showEducationError,
                                    onEducationChanged: (value) {
                                      if (_showEducationError) {
                                        setState(
                                          () => _showEducationError = false,
                                        );
                                      }
                                    },
                                  )
                                : EmployerSignUp(
                                    institutionNameController:
                                        cubit.companyNameController,
                                    institutionType: institutionType,
                                    onTypeChanged: (v) =>
                                        setState(() => institutionType = v),
                                    availableJobs: availableJobs,
                                    onAvailableJobsChanged: (list) =>
                                        setState(() => availableJobs = list),
                                    sampleJobs: sampleJobs,
                                    institutionAddressController:
                                        cubit.companyAddressController,
                                    taxNumberController:
                                        TextEditingController(),
                                    institutionGovernorates: [...governorates],
                                    institutiSelectedGovernorate:
                                        institutiSelectedGovernorate,
                                    institutionOnGovernorateChanged: (v) =>
                                        setState(
                                          () =>
                                              institutiSelectedGovernorate = v,
                                        ),
                                    institutionImages: cubit.companyImages,
                                    onPickInstitutionImages: () async {
                                      final f = await _pickImage(
                                        pickImageOnly: false,
                                      );
                                      if (f != null) cubit.addCompanyImage(f);
                                    },
                                    onRemoveInstitutionImage: (index) {
                                      setState(
                                        () =>
                                            cubit.companyImages.removeAt(index),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppTextButton(
                    buttonText: _pageIndex < 2 ? 'التالي' : 'سجل الآن',
                    isLoading: isLoading,
                    onPressed: () {
                      if (_pageIndex < 2) {
                        _nextPage();
                      } else {
                        _submit(cubit);
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
                        onTap: () => GoRouter.of(context).pop(),
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
      },
    );
  }
}
