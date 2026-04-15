import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/features/setting/support_contact/logic/support_cubit.dart';
import 'package:sheftaya/features/setting/support_contact/logic/support_state.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/upload_tile.dart';

class SupportContactScreenBody extends StatelessWidget {
  const SupportContactScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SupportCubit>(),
      child: const _SupportScreenBody(),
    );
  }
}

class _SupportScreenBody extends StatefulWidget {
  const _SupportScreenBody();

  @override
  State<_SupportScreenBody> createState() => _SupportScreenBodyState();
}

class _SupportScreenBodyState extends State<_SupportScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedProblem;
  File? attachmentFile;
  bool showDropdownError = false;
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> problemOptions = [
    'لم أستلم تفاصيل الشيفت',
    'تم إلغاء الشيفت بشكل مفاجئ',
    'مكان العمل غير صحيح',
    'تفاصيل العمل غير واضحة',
    'لم يتم التواصل بين الطرفين',
    'مشكلة في الأجر أو الدفع',
    'لم يتم تأكيد الحضور أو الانصراف',
    'عدم حضور أحد الأطراف',
    'تأخير عن موعد الشيفت',
    'عدم الالتزام بالتعليمات',
    'عدد العمالة غير كافٍ',
    'مشكلة في إدارة أو نشر الشيفت',
    'مشكلة في السداد',
    'مشكلة فنية في التطبيق',
    'اقتراح أو ملاحظة',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => attachmentFile = File(picked.path));
    }
  }

  void _onSubmitPressed() {
    final isValid = _formKey.currentState!.validate();

    setState(() {
      showDropdownError = selectedProblem == null;
    });

    if (!isValid || selectedProblem == null) {
      return;
    }

    final problem = selectedProblem!;
    final desc = _descriptionController.text.trim();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      dismissOnTouchOutside: true,
      title: 'تأكيد إرسال الطلب',
      desc: 'هل تريد إرسال طلب الدعم الآن؟',
      btnCancelText: 'إلغاء',
      btnOkText: 'تأكيد',
      btnCancelColor: ColorsManager.lightGrey,
      btnOkColor: ColorsManager.primary,
      titleTextStyle: TextStyles.font18BlackBold,
      descTextStyle: TextStyles.font14BlackRegular,
      buttonsTextStyle: TextStyles.font14WhiteBold,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<SupportCubit>().createSupportRequest(
          problemType: problem,
          message: desc,
          imagePath: attachmentFile?.path,
        );
      },
    ).show();
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      title: 'تم إرسال الطلب بنجاح',
      desc: 'تم استلام طلبك، وسيتم التواصل معك في أقرب وقت.',
      btnOkText: 'حسنًا',
      btnOkColor: ColorsManager.primary,
      titleTextStyle: TextStyles.font18BlackBold,
      descTextStyle: TextStyles.font14BlackRegular,
      buttonsTextStyle: TextStyles.font14WhiteBold,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<SupportCubit, SupportState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (_) => _showSuccessDialog(),
            error: (err) => customSnackBar(context, err, ColorsManager.error),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('الدعم الفني', style: TextStyles.font18BlackBold),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      'يسعدنا مساعدتك في أي مشكلة تواجهك',
                      style: TextStyles.font24PrimaryBold,
                    ),
                    SizedBox(height: 24.h),
                    Text('نوع المشكلة', style: TextStyles.font14BlackBold),
                    SizedBox(height: 8.h),
                    AppDropdown(
                      items: problemOptions,
                      value: selectedProblem,
                      hint: 'اختر نوع المشكلة',
                      hasError: showDropdownError && selectedProblem == null,
                      errorMessage: 'هذا الحقل مطلوب',
                      onChanged: (val) {
                        setState(() {
                          selectedProblem = val;
                          showDropdownError = false;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text('وصف المشكلة', style: TextStyles.font14BlackBold),
                    SizedBox(height: 8.h),
                    AppTextFormField(
                      hintText: 'اكتب تفاصيل المشكلة هنا',
                      controller: _descriptionController,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'إرفاق صوره (إختياري)',
                      style: TextStyles.font14BlackBold,
                    ),
                    SizedBox(height: 8.h),
                    UploadTile(
                      acceptPdf: true,
                      label: attachmentFile == null
                          ? 'اضغط لرفع صورة'
                          : 'تم رفع الصوره بنجاح',
                      onPick: _pickAttachment,
                      file: attachmentFile,
                    ),
                    SizedBox(height: 28.h),
                    BlocBuilder<SupportCubit, SupportState>(
                      builder: (context, state) {
                        final isLoading = state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );

                        return AppTextButton(
                          buttonText: 'إرسال الطلب',
                          isLoading: isLoading,
                          onPressed: _onSubmitPressed,
                        );
                      },
                    ),
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
