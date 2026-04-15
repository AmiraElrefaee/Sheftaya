import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/change_password/data/models/change_password_request_body.dart';
import 'package:sheftaya/features/setting/change_password/data/repo/change_password_repo.dart';

import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo _repo;

  ChangePasswordCubit(this._repo) : super(const ChangePasswordState.initial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final body = ChangePasswordRequestBody(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    final response = await _repo.changePassword(
      body,
      'Bearer $token',
    );

    response.when(
      success: (data) {
        emit(ChangePasswordState.success(data));
      },
      failure: (errorHandler) {
        log('ChangePassword Error: ${errorHandler.serverFailure.errmessage}');
        emit(
          ChangePasswordState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}
