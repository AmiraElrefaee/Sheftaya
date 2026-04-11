import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_image_profile_request_body.dart';
import 'package:sheftaya/features/setting/my_profile/data/repos/update_image_profile_repo.dart';
import 'update_image_profile_state.dart';

class UpdateImageProfileCubit extends Cubit<UpdateImageProfileState> {
  final UpdateImageProfileRepo _repo;

  UpdateImageProfileCubit(this._repo)
      : super(const UpdateImageProfileState.initial());

  Future<void> updateImageProfile(String imagePath) async {
    emit(const UpdateImageProfileState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final response = await _repo.updateImageProfile(
      UpdateImageProfileRequestBody(imagePath: imagePath),
      'Bearer $token',
    );

    response.when(
      success: (data) {
        emit(UpdateImageProfileState.success(data));
      },
      failure: (errorHandler) {
        log("UpdateImageProfile Error: ${errorHandler.serverFailure.errmessage}");
        emit(
          UpdateImageProfileState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}