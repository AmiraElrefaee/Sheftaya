import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../../data/models/create_new_password_model/create_new_password_request_body.dart';
import '../../data/repos/create_new_password.dart';
import 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreatePasswordState> {
  final CreateNewPasswordRepo _createNewPasswordRepo;
  final String resetToken;

  CreateNewPasswordCubit(this._createNewPasswordRepo, this.resetToken)
    : super(const CreatePasswordState.initial());

  final TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> emitCreateNewPasswordStates() async {
    if (!formKey.currentState!.validate()) return;

    emit(const CreatePasswordState.createNewPasswordloading());

   final response = await _createNewPasswordRepo.createNewPassword(
  resetToken,
  CreateNewPasswordRequestBody(
    newPassword: newPasswordController.text.trim(),
  ),
);


    response.when(
      success: (_) {
        emit(
          const CreatePasswordState.createNewPasswordsuccess(
            message: 'Password created successfully!',
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          CreatePasswordState.createNewPassworderrorerror(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    newPasswordController.dispose();
    return super.close();
  }
}
