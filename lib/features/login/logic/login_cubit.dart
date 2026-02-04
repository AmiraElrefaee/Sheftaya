import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/constants/user_model.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../data/models/login_request_body.dart';
import '../data/models/login_response.dart';
import '../data/repos/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final UserCubit userCubit;

  LoginCubit(this._loginRepo, this.userCubit)
      : super(const LoginState.initial());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> emitLoginStates() async {
    if (!formKey.currentState!.validate()) return;

    emit(const LoginState.loading());

    final response = await _loginRepo.login(
      LoginRequestBody(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    response.when(
      success: (loginResponse) async {
        await _saveUserData(loginResponse);
                if (loginResponse.user != null) {
          final userModel = _createUserModelFromResponse(loginResponse);
          userCubit.setUser(userModel);
        }

        emit(LoginState.success(loginResponse));
      },
      failure: (errorHandler) {
        emit(LoginState.error(error: errorHandler.serverFailure.errmessage));
      },
    );
  }

  UserModel _createUserModelFromResponse(LoginResponse response) {
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

  Future<void> _saveUserData(LoginResponse response) async {
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

      log('✅ Login Success - Data saved locally');
    } catch (e) {
      log('❌ Error saving user data locally: $e');
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}