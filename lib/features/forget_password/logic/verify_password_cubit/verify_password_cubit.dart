import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../../data/models/verify_password_model/verify_password_request_body.dart';
import '../../data/repos/verify_password_repo.dart';
import 'verify_password_state.dart';

class VerifyPasswordCubit extends Cubit<VerifyPasswordState> {
  VerifyPasswordCubit(this._verifyPasswordRepo)
    : super(const VerifyPasswordState.initial());

  final VerifyPasswordRepo _verifyPasswordRepo;

  final TextEditingController otpField = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> emitVerifyPasswordStates() async {
    emit(const VerifyPasswordState.loading());

    final email = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userEmail,
    );
    log('Verifying password for email: $email');
    log('OTP code: ${otpField.text}');
    if (email.isEmpty) {
      emit(
        const VerifyPasswordState.error(
          error: 'Email is required. Please go back and enter your email.',
        ),
      );
      return;
    }

    final response = await _verifyPasswordRepo.verifyForgotPasswordCode(
      VerifyPasswordRequestBody(email: email, code: otpField.text),
    );

    response.when(
      success: (data) {
        emit(VerifyPasswordState.success(data));
      },
      failure: (errorHandler) {
        emit(
          VerifyPasswordState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}
