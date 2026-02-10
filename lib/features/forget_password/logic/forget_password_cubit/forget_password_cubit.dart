import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../../data/models/forget_password_model/forget_pass_request_body.dart';
import '../../data/repos/forget_pass_repo.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._forgetPassRepo)
    : super(const ForgetPasswordState.initial());

  final ForgetPassRepo _forgetPassRepo;
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> emitForgetPasswordStates() async {
    emit(const ForgetPasswordState.loading());

    final response = await _forgetPassRepo.forgetPassword(
      ForgetPassRequestBody(email: emailController.text),
    );

    response.when(
      success: (forgetPassResponse) {
        emit(ForgetPasswordState.success(forgetPassResponse));
      },
      failure: (errorHandler) {
        emit(
          ForgetPasswordState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}
