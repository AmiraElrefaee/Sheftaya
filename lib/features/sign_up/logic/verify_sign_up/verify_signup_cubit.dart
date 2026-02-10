import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/constants/user_model.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_response.dart';
import 'package:sheftaya/features/sign_up/data/repo/verify_sign_up_repo.dart';

import 'verify_signup_state.dart';

class VerifySignupCubit extends Cubit<VerifySignupState> {
  final VerifySignupRepo _verifySignupRepo;
  final UserCubit userCubit;

  VerifySignupCubit(this._verifySignupRepo, this.userCubit)
      : super(const VerifySignupState.initial());

  final formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  // ================= VERIFY =================
  Future<void> emitVerifySignupStates() async {
    if (!formKey.currentState!.validate()) return;

    emit(const VerifySignupState.loading());

    try {
      final email =
          await SharedPrefHelper.getSecuredString(SharedPrefKeys.userEmail);

      final response = await _verifySignupRepo.verify(
        VerifySignupRequestBody(
          email: email,
          code: otpController.text.trim(),
        ),
      );

      response.when(
        success: (verifyResponse) async {
          await _saveUserData(verifyResponse);

          if (verifyResponse.user != null) {
            final userModel = _createUserModelFromResponse(verifyResponse);
            userCubit.setUser(userModel);

            log('✅ Signup Verified - ${userModel.role}: ${userModel.firstname}');
          }

          emit(VerifySignupState.success(verifyResponse));
        },
        failure: (errorHandler) {
          log('❌ Verification Failed: ${errorHandler.serverFailure.errmessage}');
          emit(VerifySignupState.error(
              error: errorHandler.serverFailure.errmessage));
        },
      );
    } catch (e, stack) {
      log('❌ Exception in VerifySignupCubit: $e');
      log(stack.toString());
      emit(const VerifySignupState.error(
        error: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  // ================= Create UserModel =================
  UserModel _createUserModelFromResponse(VerifySignupResponse response) {
    final user = response.user!;

    return UserModel(
      id: user.id ?? '',
      firstname: user.firstName ?? '',
      lastname: user.lastName ?? '',
      email: user.email ?? '',
      role: user.role,
      phone: user.phone,
      token: response.token,
      profileImg: user.imageProfile,
    );
  }

  // ================= Save to Local =================
  Future<void> _saveUserData(VerifySignupResponse response) async {
    try {
      final user = response.user;

      if ((response.token?.isNotEmpty ?? false)) {
        await SharedPrefHelper.setSecuredString(
          SharedPrefKeys.userToken,
          response.token!,
        );
      }

      if (user != null) {
        if ((user.firstName?.isNotEmpty ?? false)) {
          await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userFirstName,
            user.firstName!,
          );
        }
        if ((user.lastName?.isNotEmpty ?? false)) {
          await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userLastName,
            user.lastName!,
          );
        }
        if ((user.email?.isNotEmpty ?? false)) {
          await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userEmail,
            user.email!,
          );
        }
        if ((user.role?.isNotEmpty ?? false)) {
          await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userRole,
            user.role!,
          );
        }
        if ((user.phone?.isNotEmpty ?? false)) {
          await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userPhone,
            user.phone!,
          );
        }
        if ((user.imageProfile?.isNotEmpty ?? false)) {
          await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userProfileImage,
            user.imageProfile!,
          );
        }
      }

      log('✅ Verified user data saved locally');
    } catch (e) {
      log('❌ Error saving verified user data: $e');
    }
  }

  @override
  Future<void> close() {
    otpController.dispose();
    return super.close();
  }
}
