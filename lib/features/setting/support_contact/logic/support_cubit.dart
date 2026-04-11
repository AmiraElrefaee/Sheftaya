import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/support_contact/data/models/support_request_body.dart';
import 'package:sheftaya/features/setting/support_contact/data/repo/support_repo.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final SupportRepo _repo;

  SupportCubit(this._repo) : super(const SupportState.initial());

  Future<void> createSupportRequest({
    required String problemType,
    required String message,
    String? imagePath,
  }) async {
    emit(const SupportState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final body = SupportRequestBody(
      problemType: problemType,
      message: message,
      imagePath: imagePath,
    );

    final response = await _repo.createSupportRequest(
      body,
      'Bearer $token',
    );

    response.when(
      success: (data) {
        emit(SupportState.success(data));
      },
      failure: (errorHandler) {
        log("Support Error: ${errorHandler.serverFailure.errmessage}");
        emit(
          SupportState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}