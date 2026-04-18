import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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

// ── Constants ─────────────────────────────────────────────────────────────

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
  'عامل توصيل',
  'عامل سوبر ماركت',
  'عامل مطعم',
  'كاشير',
  'خدمة عملاء',
  'استقبال',
  'سباك',
  'كهربائي',
  'نجار',
  'عامل دهانات',
  'بائع',
  'مندوب مبيعات',
  'مساعد إداري',
  'حارس',
  'بواب',
  'أمن',
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

  // Personal
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _birthdayCtrl;
  String? _selectedCity;
  DateTime? _selectedDate;

  // Worker professional
  late TextEditingController _educationCtrl;
  late TextEditingController _experienceYearsCtrl;
  late TextEditingController _hourlyRateCtrl;
  String? _professionalStatus;
  List<String> _pastExperience = [];
  List<String> _jobsLookedFor = [];
  File? _healthCertFile;
  String? _existingHealthCert;

  // Employer company
  late TextEditingController _companyNameCtrl;
  late TextEditingController _companyAddressCtrl;
  late TextEditingController _taxNumberCtrl;
  String? _companyType;
  String? _companyCity;
  List<String> _existingCompanyImages = [];

  String? _localImagePath;
  bool _initialized = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _birthdayCtrl.dispose();
    _educationCtrl.dispose();
    _experienceYearsCtrl.dispose();
    _hourlyRateCtrl.dispose();
    _companyNameCtrl.dispose();
    _companyAddressCtrl.dispose();
    _taxNumberCtrl.dispose();
    super.dispose();
  }

  void _initControllers(UserModel user) {
    _firstNameCtrl = TextEditingController(text: user.firstname);
    _lastNameCtrl = TextEditingController(text: user.lastname);
    _phoneCtrl = TextEditingController(text: user.phone ?? '');
    _selectedCity = user.city?.isNotEmpty == true ? user.city : null;

    // Birthday
    if (user.birthday?.isNotEmpty == true) {
      _birthdayCtrl = TextEditingController(text: user.birthday);
      try {
        _selectedDate = DateTime.parse(user.birthday!);
      } catch (_) {}
    } else {
      _birthdayCtrl = TextEditingController();
    }

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
    _existingHealthCert = user.healthCertificate;

    // Employer
    _companyNameCtrl = TextEditingController(text: user.companyName ?? '');
    _companyAddressCtrl = TextEditingController(
      text: user.companyAddress ?? '',
    );
    _taxNumberCtrl = TextEditingController();
    _companyType = user.companyType?.isNotEmpty == true
        ? user.companyType
        : null;
    _companyCity = user.companyCity?.isNotEmpty == true
        ? user.companyCity
        : null;
    _existingCompanyImages = List<String>.from(user.companyImages ?? []);

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

  Future<void> _pickHealthCert() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.single.path != null && mounted) {
        setState(() => _healthCertFile = File(result.files.single.path!));
      }
    } catch (_) {}
  }

  Future<void> _showDatePicker() async {
    final initial =
        _selectedDate ??
        DateTime.now().subtract(const Duration(days: 365 * 25));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: ColorsManager.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _birthdayCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _save(String role, UserModel user) {
    if (!_formKey.currentState!.validate()) return;

    context.read<UpdateProfileCubit>().updateProfile(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      city: _selectedCity,
      birthday: _birthdayCtrl.text.trim().isEmpty
          ? null
          : _birthdayCtrl.text.trim(),
      // Worker
      education: role == 'worker'
          ? (_educationCtrl.text.trim().isEmpty
                ? null
                : _educationCtrl.text.trim())
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
          ? (_companyNameCtrl.text.trim().isEmpty
                ? null
                : _companyNameCtrl.text.trim())
          : null,
      companyType: role == 'employer' ? _companyType : null,
      companyAddress: role == 'employer'
          ? (_companyAddressCtrl.text.trim().isEmpty
                ? null
                : _companyAddressCtrl.text.trim())
          : null,
      companyCity: role == 'employer' ? _companyCity : null,
      taxNumber: role == 'employer'
          ? (_taxNumberCtrl.text.trim().isEmpty
                ? null
                : _taxNumberCtrl.text.trim())
          : null,
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(text, style: TextStyles.font14BlackRegular),
  );

  Widget _gap([double h = 16]) => SizedBox(height: h.h);

  Widget _sectionHeader(String title) => Padding(
    padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
    child: Text(
      title,
      style: TextStyles.font16BlackBold.copyWith(fontSize: 18.sp),
    ),
  );

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
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
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
          BlocListener<UpdateProfileCubit, UpdateProfileState>(
            listener: (ctx, state) {
              state.whenOrNull(
                success: (_) {
                  final cubit = ctx.read<UserCubit>();
                  final old = cubit.state.user!;
                  final updated = old.copyWith(
                    firstname: _firstNameCtrl.text.trim(),
                    lastname: _lastNameCtrl.text.trim(),
                    phone: _phoneCtrl.text.trim().isEmpty
                        ? null
                        : _phoneCtrl.text.trim(),
                    city: _selectedCity,
                    birthday: _birthdayCtrl.text.trim().isEmpty
                        ? null
                        : _birthdayCtrl.text.trim(),
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
                  cubit.setUser(updated); // optimistic UI update
                  cubit.refreshProfile(); // ← sync fresh data from server
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

                    // ── Profile Image ──────────────────────────────────────
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

                    // ══════════ Personal Info ══════════════════════════════
                    _sectionHeader('المعلومات الشخصية'),

                    // Name row
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

                    // Email (readonly)
                    _label('البريد الإلكتروني'),
                    AppTextFormField(
                      controller: TextEditingController(text: user.email),
                      hintText: user.email,
                      enabled: false,
                    ),

                    _gap(),

                    // Governorate
                    _label('المحافظة'),
                    AppDropdown(
                      items: _governorates,
                      value: _selectedCity,
                      hint: 'اختر محافظتك',
                      onChanged: (v) => setState(() => _selectedCity = v),
                    ),

                    _gap(),

                    // Birthday
                    _label('تاريخ الميلاد (اختياري)'),
                    AppTextFormField(
                      controller: _birthdayCtrl,
                      hintText: 'YYYY-MM-DD',
                      readOnly: true,
                      onTap: _showDatePicker,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: 20.w,
                        color: ColorsManager.grey,
                      ),
                    ),

                    _gap(),

                    // Phone
                    _label('رقم الهاتف (اختياري)'),
                    AppTextFormField(
                      controller: _phoneCtrl,
                      hintText: '01xxxxxxxxx',
                      keyboardType: TextInputType.phone,
                    ),

                    _gap(24),

                    // ══════════ Worker Professional Info ══════════════════
                    if (isWorker) ...[
                      _sectionHeader('المعلومات المهنية'),

                      _label('التعليم / التخصص'),
                      AppTextFormField(
                        controller: _educationCtrl,
                        hintText: 'مثال: تجارة، حاسبات، ثانوية عامة...',
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

                      // Health Certificate
                      _label('الشهادة الصحية'),
                      _HealthCertField(
                        existingUrl: _existingHealthCert,
                        selectedFile: _healthCertFile,
                        onPick: _pickHealthCert,
                      ),

                      _gap(24),
                    ],

                    // ══════════ Employer Company Info ═════════════════════
                    if (isEmployer) ...[
                      _sectionHeader('معلومات المؤسسة'),

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

                      _label('المحافظة (المؤسسة)'),
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
                        hintText: 'الشارع والحي...',
                        maxLines: 2,
                      ),

                      _gap(),

                      _label('الرقم الضريبي (اختياري)'),
                      AppTextFormField(
                        controller: _taxNumberCtrl,
                        hintText: '000-000-000',
                      ),

                      // Company Images Display
                      if (_existingCompanyImages.isNotEmpty) ...[
                        _gap(),
                        _label('صور المؤسسة'),
                        _CompanyImagesDisplay(images: _existingCompanyImages),
                      ],

                      _gap(24),
                    ],

                    // ── Save Button ────────────────────────────────────────
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

// ── Health Certificate Field ─────────────────────────────────────────────

class _HealthCertField extends StatelessWidget {
  final String? existingUrl;
  final File? selectedFile;
  final VoidCallback onPick;

  const _HealthCertField({
    this.existingUrl,
    this.selectedFile,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    if (selectedFile != null) {
      label = selectedFile!.path.split('/').last;
    } else if (existingUrl != null && existingUrl!.isNotEmpty) {
      label = 'تم رفع الشهادة ✓';
    } else {
      label = 'اضغط لرفع الشهادة الصحية';
    }

    return InkWell(
      onTap: onPick,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selectedFile != null || (existingUrl?.isNotEmpty == true)
                ? ColorsManager.primary
                : ColorsManager.grey,
            width: selectedFile != null || (existingUrl?.isNotEmpty == true)
                ? 2.w
                : 1.w,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyles.font14BlackRegular.copyWith(
                  color:
                      selectedFile != null || (existingUrl?.isNotEmpty == true)
                      ? ColorsManager.primary
                      : ColorsManager.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.upload_file, color: ColorsManager.primary),
          ],
        ),
      ),
    );
  }
}

// ── Company Images Display ────────────────────────────────────────────────

class _CompanyImagesDisplay extends StatelessWidget {
  final List<String> images;

  const _CompanyImagesDisplay({required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            images[i],
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 80.w,
              height: 80.h,
              color: ColorsManager.lightGrey,
              child: const Icon(Icons.broken_image, color: ColorsManager.grey),
            ),
          ),
        ),
      ),
    );
  }
}
