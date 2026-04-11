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

  final problemOptions = [
    'support.problem_booking',
    'support.problem_payment',
    'support.problem_partner_no_show',
    'support.problem_technical',
    'support.problem_suggestion',
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
      title: '',
      desc: '',
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
      title: 'support.success_title',
      desc: 'support.success_desc',
      btnOkText: 'ok',
      btnOkColor: ColorsManager.primary,
      titleTextStyle: TextStyles.font18BlackBold,
      descTextStyle: TextStyles.font14BlackRegular,
      buttonsTextStyle: TextStyles.font14WhiteBold,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupportCubit, SupportState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (_) => _showSuccessDialog(),
          error: (err) => customSnackBar(context, err, ColorsManager.error),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('', style: TextStyles.font18BlackBold),
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
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'support.headline_1',
                      style: TextStyles.font24PrimaryBold,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    'support.problem_type',
                    style: TextStyles.font14BlackBold,
                  ),
                  SizedBox(height: 8.h),
                  AppDropdown(
                    items: problemOptions.map((k) => k).toList(),
                    value: selectedProblem,
                    hint: 'support.problem_type_hint',
                    hasError: showDropdownError && selectedProblem == null,
                    errorMessage: 'required_field',
                    onChanged: (val) {
                      setState(() {
                        selectedProblem = val;
                        showDropdownError = false;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'support.describe_problem',
                    style: TextStyles.font14BlackBold,
                  ),
                  SizedBox(height: 8.h),
                  AppTextFormField(
                    hintText: 'support.description_hint',
                    controller: _descriptionController,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'required_field';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'support.attach_file',
                    style: TextStyles.font14BlackBold,
                  ),
                  SizedBox(height: 8.h),
                  UploadTile(
                    acceptPdf: true,
                    label: attachmentFile == null
                        ? 'support.upload_here'
                        : 'support.attachment_uploaded',
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
                        buttonText: 'support.send_request',
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
    );
  }
}
