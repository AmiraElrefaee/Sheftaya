import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/constants/user_model.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/widgets/app_multi_select_dropdown.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_image_profile_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_image_profile_state.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_profile_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_profile_state.dart';
import 'profile_image.dart';

// ── خيارات ثابتة ───────────────────────────────────────────────────────────

const _professionalStatuses = [
  'طالب',
  'موظف دوام كامل',
  'موظف جزئي',
  'لا أعمل',
];

const _jobOptions = [
  'طباخ',
  'مساعد طباخ',
  'عامل مطبخ',
  'غسال أطباق',
  'عامل نظافة',
  'عامل مخزن',
  'عامل تحميل وتنزيل',
  'سائق',
  'عامل سوبر ماركت',
  'كاشير',
  'خدمة عملاء',
  'استقبال',
  'حارس',
  'بواب',
  'أمن',
  'سباك',
  'كهربائي',
  'نجار',
  'عامل دهانات',
  'بائع',
  'مندوب مبيعات',
  'مساعد إداري',
  'آخر',
];

const _companyTypes = [
  'شركة',
  'مزرعة',
  'ورشة',
  'محل تجاري',
  'مطعم',
  'كافيه',
  'فندق',
  'مصنع',
  'مخزن',
  'آخر',
];

const _governorates = [
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
];

// ──────────────────────────────────────────────────────────────────────────

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  final _formKey = GlobalKey<FormState>();

  // حقول مشتركة
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;

  // حقول الـ worker
  late TextEditingController _educationCtrl;
  late TextEditingController _experienceYearsCtrl;
  late TextEditingController _hourlyRateCtrl;
  String? _professionalStatus;
  List<String> _pastExperience = [];
  List<String> _jobsLookedFor = [];

  // حقول الـ employer
  late TextEditingController _companyNameCtrl;
  late TextEditingController _companyAddressCtrl;
  String? _companyType;
  String? _companyCity;

  String? _localImagePath;
  bool _initialized = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _educationCtrl.dispose();
    _experienceYearsCtrl.dispose();
    _hourlyRateCtrl.dispose();
    _companyNameCtrl.dispose();
    _companyAddressCtrl.dispose();
    super.dispose();
  }

  void _initControllers(UserModel user) {
    _firstNameCtrl = TextEditingController(text: user.firstname);
    _lastNameCtrl = TextEditingController(text: user.lastname);
    _phoneCtrl = TextEditingController(text: user.phone ?? '');

    // Worker
    _educationCtrl = TextEditingController(text: user.education ?? '');
    _experienceYearsCtrl = TextEditingController(
      text: user.experienceYears?.toString() ?? '',
    );
    _hourlyRateCtrl = TextEditingController(
      text: user.expectedHourlyRate?.toString() ?? '',
    );
    _professionalStatus = user.professionalStatus;
    _pastExperience = List<String>.from(user.pastExperience ?? []);
    _jobsLookedFor = List<String>.from(user.jobsLookedFor ?? []);

    // Employer
    _companyNameCtrl = TextEditingController(text: user.companyName ?? '');
    _companyAddressCtrl = TextEditingController(
      text: user.companyAddress ?? '',
    );
    _companyType = user.companyType;
    _companyCity = user.companyCity;

    _localImagePath = user.profileImg;
    _initialized = true;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _localImagePath = picked.path);
      context.read<UpdateImageProfileCubit>().updateImageProfile(picked.path);
    }
  }

  void _save(String role, UserModel user) {
    if (!_formKey.currentState!.validate()) return;

    context.read<UpdateProfileCubit>().updateProfile(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      // Worker
      education: role == 'worker'
          ? _educationCtrl.text.trim().isEmpty
                ? null
                : _educationCtrl.text.trim()
          : null,
      professionalStatus: role == 'worker' ? _professionalStatus : null,
      pastExperience: role == 'worker' && _pastExperience.isNotEmpty
          ? _pastExperience
          : null,
      jobsLookedFor: role == 'worker' && _jobsLookedFor.isNotEmpty
          ? _jobsLookedFor
          : null,
      experienceYears: role == 'worker'
          ? int.tryParse(_experienceYearsCtrl.text.trim())
          : null,
      expectedHourlyRate: role == 'worker'
          ? double.tryParse(_hourlyRateCtrl.text.trim())
          : null,
      // Employer
      companyName: role == 'employer'
          ? _companyNameCtrl.text.trim().isEmpty
                ? null
                : _companyNameCtrl.text.trim()
          : null,
      companyType: role == 'employer' ? _companyType : null,
      companyAddress: role == 'employer'
          ? _companyAddressCtrl.text.trim().isEmpty
                ? null
                : _companyAddressCtrl.text.trim()
          : null,
      companyCity: role == 'employer' ? _companyCity : null,
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(text, style: TextStyles.font14BlackRegular),
  );

  Widget _gap([double h = 16]) => SizedBox(height: h.h);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_initialized) _initControllers(user);

    final role = (user.role ?? '').toLowerCase();
    final isWorker = role == 'worker';
    final isEmployer = role == 'employer';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('الملف الشخصي', style: TextStyles.font18BlackBold),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          // تحديث الصورة
          BlocListener<UpdateImageProfileCubit, UpdateImageProfileState>(
            listener: (ctx, state) {
              state.whenOrNull(
                success: (data) {
                  final newUrl = data.data?.imageProfile;
                  if (newUrl != null) {
                    final updated = ctx.read<UserCubit>().state.user!.copyWith(
                      profileImg: newUrl,
                    );
                    ctx.read<UserCubit>().setUser(updated);
                    setState(() => _localImagePath = newUrl);
                  }
                  customSnackBar(
                    ctx,
                    'تم تحديث صورة الملف بنجاح',
                    ColorsManager.success,
                  );
                },
                error: (e) => customSnackBar(ctx, e, ColorsManager.error),
              );
            },
          ),
          // تحديث بيانات البروفايل
          BlocListener<UpdateProfileCubit, UpdateProfileState>(
            listener: (ctx, state) {
              state.whenOrNull(
                success: (_) {
                  // نحدّث UserCubit بالبيانات الجديدة
                  final cubit = ctx.read<UserCubit>();
                  final old = cubit.state.user!;
                  final updated = old.copyWith(
                    firstname: _firstNameCtrl.text.trim(),
                    lastname: _lastNameCtrl.text.trim(),
                    phone: _phoneCtrl.text.trim().isEmpty
                        ? null
                        : _phoneCtrl.text.trim(),
                    education: isWorker
                        ? _educationCtrl.text.trim()
                        : old.education,
                    professionalStatus: isWorker
                        ? _professionalStatus
                        : old.professionalStatus,
                    pastExperience: isWorker
                        ? _pastExperience
                        : old.pastExperience,
                    jobsLookedFor: isWorker
                        ? _jobsLookedFor
                        : old.jobsLookedFor,
                    experienceYears: isWorker
                        ? int.tryParse(_experienceYearsCtrl.text.trim())
                        : old.experienceYears,
                    expectedHourlyRate: isWorker
                        ? double.tryParse(_hourlyRateCtrl.text.trim())
                        : old.expectedHourlyRate,
                    companyName: isEmployer
                        ? _companyNameCtrl.text.trim()
                        : old.companyName,
                    companyType: isEmployer ? _companyType : old.companyType,
                    companyAddress: isEmployer
                        ? _companyAddressCtrl.text.trim()
                        : old.companyAddress,
                    companyCity: isEmployer ? _companyCity : old.companyCity,
                  );
                  cubit.setUser(updated);
                  customSnackBar(
                    ctx,
                    'تم حفظ التغييرات بنجاح',
                    ColorsManager.success,
                  );
                },
                error: (e) => customSnackBar(ctx, e, ColorsManager.error),
              );
            },
          ),
        ],
        child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
          builder: (ctx, profileState) {
            final isSaving = profileState.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _gap(12),

                    // ── صورة البروفايل ──────────────────────────────────
                    BlocBuilder<
                      UpdateImageProfileCubit,
                      UpdateImageProfileState
                    >(
                      builder: (_, imgState) {
                        final uploading = imgState.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                        return Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ProfileImage(
                                imageUrl: _localImagePath,
                                onTap: uploading ? null : _pickImage,
                              ),
                              if (uploading) const CircularProgressIndicator(),
                            ],
                          ),
                        );
                      },
                    ),

                    _gap(24),

                    // ── الاسم ────────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _label('الاسم الأول'),
                              AppTextFormField(
                                controller: _firstNameCtrl,
                                hintText: 'الاسم الأول',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'مطلوب'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _label('الاسم الأخير'),
                              AppTextFormField(
                                controller: _lastNameCtrl,
                                hintText: 'الاسم الأخير',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'مطلوب'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _gap(),

                    // ── البريد (للقراءة فقط) ─────────────────────────────
                    _label('البريد الإلكتروني'),
                    AppTextFormField(
                      controller: TextEditingController(text: user.email),
                      hintText: user.email,
                      enabled: false,
                    ),

                    _gap(),

                    // ── رقم الهاتف ───────────────────────────────────────
                    _label('رقم الهاتف (اختياري)'),
                    AppTextFormField(
                      controller: _phoneCtrl,
                      hintText: '01xxxxxxxxx',
                      keyboardType: TextInputType.phone,
                    ),

                    _gap(),

                    // ══════════════ Worker ══════════════════════════════
                    if (isWorker) ...[
                      _label('التعليم / التخصص'),
                      AppTextFormField(
                        controller: _educationCtrl,
                        hintText: 'مثال: تجارة، حاسبات، ثانوية عامة ...',
                      ),

                      _gap(),

                      _label('الحالة المهنية'),
                      AppDropdown(
                        items: _professionalStatuses,
                        value: _professionalStatus,
                        hint: 'اختر حالتك',
                        onChanged: (v) =>
                            setState(() => _professionalStatus = v),
                      ),

                      _gap(),

                      _label('الوظائف السابقة'),
                      AppMultiSelectDropdown(
                        items: _jobOptions,
                        selectedValues: _pastExperience,
                        hint: 'اختر وظائفك السابقة',
                        onChanged: (v) => setState(() => _pastExperience = v),
                      ),

                      _gap(),

                      _label('الوظائف التي تبحث عنها'),
                      AppMultiSelectDropdown(
                        items: _jobOptions,
                        selectedValues: _jobsLookedFor,
                        hint: 'اختر الوظائف المطلوبة',
                        onChanged: (v) => setState(() => _jobsLookedFor = v),
                      ),

                      _gap(),

                      _label('سنوات الخبرة'),
                      AppTextFormField(
                        controller: _experienceYearsCtrl,
                        hintText: 'مثال: 2',
                        keyboardType: TextInputType.number,
                      ),

                      _gap(),

                      _label('الأجر المتوقع في الساعة (جنيه)'),
                      AppTextFormField(
                        controller: _hourlyRateCtrl,
                        hintText: 'مثال: 50',
                        keyboardType: TextInputType.number,
                      ),

                      _gap(),
                    ],

                    // ══════════════ Employer ════════════════════════════
                    if (isEmployer) ...[
                      _label('اسم المؤسسة'),
                      AppTextFormField(
                        controller: _companyNameCtrl,
                        hintText: 'اسم المؤسسة أو الشركة',
                      ),

                      _gap(),

                      _label('نوع المؤسسة'),
                      AppDropdown(
                        items: _companyTypes,
                        value: _companyType,
                        hint: 'اختر نوع المؤسسة',
                        onChanged: (v) => setState(() => _companyType = v),
                      ),

                      _gap(),

                      _label('المحافظة'),
                      AppDropdown(
                        items: _governorates,
                        value: _companyCity,
                        hint: 'اختر المحافظة',
                        onChanged: (v) => setState(() => _companyCity = v),
                      ),

                      _gap(),

                      _label('عنوان المؤسسة التفصيلي'),
                      AppTextFormField(
                        controller: _companyAddressCtrl,
                        hintText: 'الشارع والحي ...',
                        maxLines: 2,
                      ),

                      _gap(28),
                    ],

                    // ── زر الحفظ ────────────────────────────────────────
                    AppTextButton(
                      buttonText: 'حفظ التغييرات',
                      isLoading: isSaving,
                      onPressed: () => _save(role, user),
                    ),
                    _gap(28),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
