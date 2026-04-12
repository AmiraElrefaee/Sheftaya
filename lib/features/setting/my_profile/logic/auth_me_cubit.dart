import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/repos/auth_me_repo.dart';

import 'auth_me_state.dart';

class AuthMeCubit extends Cubit<AuthMeState> {
  final AuthMeRepo _repo;

  AuthMeCubit(this._repo) : super(const AuthMeState.initial());

  Future<void> fetchMe() async {
    emit(const AuthMeState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final response = await _repo.getMe('Bearer $token');

    response.when(
      success: (data) {
        emit(AuthMeState.success(data));
      },
      failure: (errorHandler) {
        log('AuthMe Error: ${errorHandler.serverFailure.errmessage}');
        emit(
          AuthMeState.error(
            message: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}