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
import 'package:sheftaya/features/setting/my_profile/data/models/update_profile_request_body.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_image_profile_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_image_profile_state.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_profile_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_profile_state.dart';
import 'package:sheftaya/features/setting/my_profile/presentation/widgets/profile_image.dart';

// ─────────────────────────── static options ───────────────────────────────
const List<String> _educationSystems = [
  'النظام الحكومى (National System)',
  'نظام اللغات / التجريبي (Languages / Experimental System)',
  'الدبلومة الأمريكية (American Diploma SAT/EST)',
];

const List<String> _grades = [
  'الصف الأول الإعدادي (Grade 7)',
  'الصف الثاني الإعدادي (Grade 8)',
  'الصف الثالث الإعدادي (Grade 9)',
  'الصف الأول الثانوي (Grade 10)',
  'الصف الثاني الثانوي (Grade 11)',
  'الصف الثالث الثانوي (Grade 12)',
];

const List<String> _subjects = [
  'اللغة العربية',
  'اللغة الإنجليزية',
  'الرياضيات',
  'العلوم (فيزياء – كيمياء – أحياء)',
  'الدراسات الاجتماعية (تاريخ – جغرافيا)',
  'التربية الدينية',
  'التربية الرياضية',
  'اللغة الفرنسية',
  'التربية الوطنية',
  'اللغة الأجنبية الثانية',
  'البرمجة وعلوم الحاسب',
  'الأحياء',
  'الكيمياء',
  'الفيزياء',
  'رياضيات متقدمة',
  'إحصاء',
  'الفلسفة والمنطق',
  'علم النفس والاجتماع',
  'التاريخ',
  'الجغرافيا',
  'Arabic Language',
  'English Language',
  'Mathematics',
  'Physics',
  'Chemistry',
  'Biology',
  'Integrated Science (Physics – Chemistry – Biology)',
  'Social Studies (History – Geography)',
  'Religious Education',
  'Physical Education',
  'French Language',
  'Computer Science',
  'English Language Arts',
  'Mathematics (Algebra / Geometry / Calculus)',
  'Science (Biology / Chemistry / Physics)',
  'Social Studies',
  'Foreign Languages',
  'Computer / ICT',
  'Physical Education',
  'Art',
];

// ──────────────────────────────────────────────────────────────────────────

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  final _formKey = GlobalKey<FormState>();

  // common controllers
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;

  // gender dropdown
  String? _selectedGender;

  // ─── student fields ───
  String? _studentEducationSystem;
  String? _studentGrade;
  late TextEditingController _studentSchoolCtrl;

  // ─── teacher fields ───
  List<String> _teacherEducationSystems = [];
  List<String> _teacherAcademicStages = [];
  List<String> _teacherSubjects = [];
  late TextEditingController _teacherSchoolCtrl;
  late TextEditingController _teacherExperienceCtrl;
  late TextEditingController _teacherBioCtrl;
  late TextEditingController _teacherPriceCtrl;

  // image
  String? _localImagePath;

  bool _initialized = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _studentSchoolCtrl.dispose();
    _teacherSchoolCtrl.dispose();
    _teacherExperienceCtrl.dispose();
    _teacherBioCtrl.dispose();
    _teacherPriceCtrl.dispose();
    super.dispose();
  }

  void _initControllers() {
    final user = context.read<UserCubit>().state.user!;

    _firstNameCtrl = TextEditingController(text: user.firstname);
    _lastNameCtrl = TextEditingController(text: user.lastname);
    _phoneCtrl = TextEditingController(text: user.phone ?? '');
    // _selectedGender = user.gender;

    // // student
    // _studentEducationSystem = user.studentEducationSystem;
    // _studentGrade = user.studentGrade;
    // _studentSchoolCtrl = TextEditingController(text: user.studentSchool ?? '');

    // // teacher
    // _teacherEducationSystems = List<String>.from(user.educationSystem ?? []);
    // _teacherAcademicStages = List<String>.from(user.academicStages ?? []);
    // _teacherSubjects = List<String>.from(user.subjects ?? []);
    // _teacherSchoolCtrl = TextEditingController(text: user.school ?? '');
    // _teacherExperienceCtrl = TextEditingController(
    //   text: user.experienceYears?.toString() ?? '',
    // );
    // _teacherBioCtrl = TextEditingController(text: user.bio ?? '');
    // _teacherPriceCtrl = TextEditingController(
    //   text: user.pricePerHour?.toString() ?? '',
    // );

    _localImagePath = user.profileImg;
    _initialized = true;
  }

  // ── pick image ──────────────────────────────────────────────────────────
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _localImagePath = picked.path);
      if (mounted) {
        context.read<UpdateImageProfileCubit>().updateImageProfile(picked.path);
      }
    }
  }

  // ── save profile ────────────────────────────────────────────────────────
  void _save(String role) {
    if (!_formKey.currentState!.validate()) return;

    final isTeacher = role == 'teacher';
    final isStudent = role == 'student';

    context.read<UpdateProfileCubit>().updateProfile(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      teacherProfile: isTeacher
          ? UpdateTeacherProfileBody(
              school: _teacherSchoolCtrl.text.trim().isEmpty
                  ? null
                  : _teacherSchoolCtrl.text.trim(),
              pricePerHour: _teacherPriceCtrl.text.trim().isEmpty
                  ? null
                  : num.tryParse(_teacherPriceCtrl.text.trim()),
              bio: _teacherBioCtrl.text.trim().isEmpty
                  ? null
                  : _teacherBioCtrl.text.trim(),
              experienceYears: _teacherExperienceCtrl.text.trim().isEmpty
                  ? null
                  : int.tryParse(_teacherExperienceCtrl.text.trim()),
              educationSystem: _teacherEducationSystems.isEmpty
                  ? null
                  : _teacherEducationSystems,
              academicStages: _teacherAcademicStages.isEmpty
                  ? null
                  : _teacherAcademicStages,
              subjects: _teacherSubjects.isEmpty ? null : _teacherSubjects,
            )
          : null,
      studentProfile: isStudent
          ? UpdateStudentProfileBody(
              grade: _studentGrade,
              educationSystem: _studentEducationSystem,
              school: _studentSchoolCtrl.text.trim().isEmpty
                  ? null
                  : _studentSchoolCtrl.text.trim(),
            )
          : null,
    );
  }

  // ── helpers ─────────────────────────────────────────────────────────────
  Widget _label(String key) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(key, style: TextStyles.font14BlackRegular),
  );

  Widget _gap() => SizedBox(height: 16.h);

  // ────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();
    final user = userCubit.state.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_initialized) _initControllers();

    final role = (user.role ?? '').toLowerCase();
    final isTeacher = role == 'teacher';
    final isStudent = role == 'student';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('الملف الشخصي', style: TextStyles.font18BlackBold),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          // image upload result
          BlocListener<UpdateImageProfileCubit, UpdateImageProfileState>(
            listener: (ctx, state) {
              state.whenOrNull(
                success: (data) {
                  final newUrl = data.data?.imageProfile;
                  if (newUrl != null) {
                    final updatedUser = UserModel(
                      id: user.id,
                      firstname: user.firstname,
                      lastname: user.lastname,
                      email: user.email,
                      role: user.role,
                      phone: user.phone,
                      token: user.token,
                      // status: user.status,
                      // profileImg: newUrl,
                      // preferredLang: user.preferredLang,
                      // createdAt: user.createdAt,
                      // updatedAt: user.updatedAt,
                      // gender: user.gender,
                      // fcmToken: user.fcmToken,
                      // points: user.points,
                      // level: user.level,
                      // educationSystem: user.educationSystem,
                      // academicStages: user.academicStages,
                      // school: user.school,
                      // subjects: user.subjects,
                      // experienceYears: user.experienceYears,
                      // bio: user.bio,
                      // pricePerHour: user.pricePerHour,
                      // verificationStatus: user.verificationStatus,
                      // avgRating: user.avgRating,
                      // totalReviews: user.totalReviews,
                      // studentEducationSystem: user.studentEducationSystem,
                      // studentGrade: user.studentGrade,
                      // studentSchool: user.studentSchool,
                      // createFeedback: user.createFeedback,
                    );
                    ctx.read<UserCubit>().setUser(updatedUser);
                    setState(() => _localImagePath = newUrl);
                  }
                  customSnackBar(
                    ctx,
                    'تم تحديث صورة الملف الشخصي بنجاح',
                    ColorsManager.success,
                  );
                },
                error: (e) => customSnackBar(ctx, e, ColorsManager.error),
              );
            },
          ),
          // profile update result
          BlocListener<UpdateProfileCubit, UpdateProfileState>(
            listener: (ctx, state) {
              state.whenOrNull(
                success: (_) {
                  final u = ctx.read<UserCubit>().state.user!;
                  final updated = UserModel(
                    id: u.id,
                    firstname: _firstNameCtrl.text.trim(),
                    lastname: _lastNameCtrl.text.trim(),
                    email: u.email,
                    role: u.role,
                    phone: _phoneCtrl.text.trim().isEmpty
                        ? null
                        : _phoneCtrl.text.trim(),
                    token: u.token,
                    // status: u.status,
                    // profileImg: u.profileImg,
                    // preferredLang: u.preferredLang,
                    // createdAt: u.createdAt,
                    // updatedAt: u.updatedAt,
                    // gender: _selectedGender,
                    // fcmToken: u.fcmToken,
                    // points: u.points,
                    // level: u.level,
                    // educationSystem: isTeacher
                    //     ? _teacherEducationSystems
                    //     : u.educationSystem,
                    // academicStages: isTeacher
                    //     ? _teacherAcademicStages
                    //     : u.academicStages,
                    // school: isTeacher
                    //     ? _teacherSchoolCtrl.text.trim()
                    //     : u.school,
                    // subjects: isTeacher ? _teacherSubjects : u.subjects,
                    // experienceYears: isTeacher
                    //     ? int.tryParse(_teacherExperienceCtrl.text.trim())
                    //     : u.experienceYears,
                    // bio: isTeacher ? _teacherBioCtrl.text.trim() : u.bio,
                    // pricePerHour: isTeacher
                    //     ? num.tryParse(_teacherPriceCtrl.text.trim())
                    //     : u.pricePerHour,
                    // verificationStatus: u.verificationStatus,
                    // avgRating: u.avgRating,
                    // totalReviews: u.totalReviews,
                    // studentEducationSystem: isStudent
                    //     ? _studentEducationSystem
                    //     : u.studentEducationSystem,
                    // studentGrade: isStudent ? _studentGrade : u.studentGrade,
                    // studentSchool: isStudent
                    //     ? (_studentSchoolCtrl.text.trim().isEmpty
                    //           ? null
                    //           : _studentSchoolCtrl.text.trim())
                    //     : u.studentSchool,
                    // createFeedback: u.createFeedback,
                  );
                  ctx.read<UserCubit>().setUser(updated);
                  customSnackBar(
                    ctx,
                    'profile.saved',
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
                    SizedBox(height: 12.h),

                    // ── Profile Image ──
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

                    SizedBox(height: 24.h),

                    // ── First & Last Name ──
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _label('الاسم الأول'),
                              AppTextFormField(
                                controller: _firstNameCtrl,
                                hintText: 'ادخل الاسم الأول',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'الاسم الأول مطلوب'
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
                                hintText: 'ادخل الاسم الأخير',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'الاسم الأخير مطلوب'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _gap(),

                    // ── Email (readonly) ──
                    _label('profile.email'),
                    AppTextFormField(
                      controller: TextEditingController(text: user.email),
                      hintText: user.email,
                      enabled: false,
                    ),

                    _gap(),

                    // ── Phone ──
                    _label('profile.phone'),
                    AppTextFormField(
                      controller: _phoneCtrl,
                      hintText: 'phone_hint',
                      keyboardType: TextInputType.phone,
                    ),

                    _gap(),

                    // ══════════════ STUDENT ══════════════
                    if (isStudent) ...[
                      _label('profile.education_system'),
                      AppDropdown(
                        items: _educationSystems,
                        value: _studentEducationSystem,
                        hint: 'select_education_system',
                        onChanged: (v) =>
                            setState(() => _studentEducationSystem = v),
                      ),

                      _gap(),

                      _label('profile.grade'),
                      AppDropdown(
                        items: _grades,
                        value: _studentGrade,
                        hint: 'select_grade',
                        onChanged: (v) => setState(() => _studentGrade = v),
                      ),

                      _gap(),

                      _label('profile.school'),
                      AppTextFormField(
                        controller: _studentSchoolCtrl,
                        hintText: 'enter_school_name',
                      ),

                      _gap(),
                    ],

                    // ══════════════ TEACHER ══════════════
                    if (isTeacher) ...[
                      _label('profile.education_system'),
                      AppMultiSelectDropdown(
                        items: _educationSystems,
                        selectedValues: _teacherEducationSystems,
                        hint: 'select_education_systems',
                        onChanged: (v) =>
                            setState(() => _teacherEducationSystems = v),
                      ),

                      _gap(),

                      _label('profile.academic_stages'),
                      AppMultiSelectDropdown(
                        items: _grades,
                        selectedValues: _teacherAcademicStages,
                        hint: 'select_academic_stages',
                        onChanged: (v) =>
                            setState(() => _teacherAcademicStages = v),
                      ),

                      _gap(),

                      _label('profile.subjects'),
                      AppMultiSelectDropdown(
                        items: _subjects,
                        selectedValues: _teacherSubjects,
                        hint: 'select_subjects',
                        onChanged: (v) => setState(() => _teacherSubjects = v),
                      ),

                      _gap(),

                      _label('profile.school'),
                      AppTextFormField(
                        controller: _teacherSchoolCtrl,
                        hintText: 'enter_working_school',
                      ),

                      _gap(),

                      _label('profile.experience_years'),
                      AppTextFormField(
                        controller: _teacherExperienceCtrl,
                        hintText: 'enter_experience_years',
                        keyboardType: TextInputType.number,
                      ),

                      _gap(),

                      _label('profile.price_per_hour'),
                      AppTextFormField(
                        controller: _teacherPriceCtrl,
                        hintText: 'enter_hourly_rate',
                        keyboardType: TextInputType.number,
                      ),

                      _gap(),

                      _label('profile.bio'),
                      AppTextFormField(
                        controller: _teacherBioCtrl,
                        hintText: 'enter_bio',
                        maxLines: 4,
                      ),

                      _gap(),
                    ],

                    // ── Save Button ──
                    AppTextButton(
                      buttonText: 'حفظ التغييرات',
                      isLoading: isSaving,
                      onPressed: () => _save(role),
                    ),

                    SizedBox(height: 100.h),
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
