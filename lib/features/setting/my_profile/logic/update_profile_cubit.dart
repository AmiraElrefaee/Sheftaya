import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_profile_request_body.dart';
import 'package:sheftaya/features/setting/my_profile/data/repos/update_profile_repo.dart';
import 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo _repo;

  UpdateProfileCubit(this._repo) : super(const UpdateProfileState.initial());

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    // Worker
    String? education,
    String? professionalStatus,
    List<String>? pastExperience,
    List<String>? jobsLookedFor,
    int? experienceYears,
    double? expectedHourlyRate,
    // Employer
    String? companyName,
    String? companyType,
    String? companyAddress,
    String? companyCity,
  }) async {
    emit(const UpdateProfileState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    final role =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userRole);

    final body = UpdateProfileRequestBody(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      workerProfile: role == 'worker'
          ? UpdateWorkerProfileBody(
              education: education,
              professionalStatus: professionalStatus,
              pastExperience: pastExperience,
              jobsLookedFor: jobsLookedFor,
              experienceYears: experienceYears,
              expectedHourlyRate: expectedHourlyRate,
            )
          : null,
      employerProfile: role == 'employer'
          ? UpdateEmployerProfileBody(
              companyName: companyName,
              companyType: companyType,
              companyAddress: companyAddress,
              city: companyCity,
            )
          : null,
    );

    final response = await _repo.updateProfile(body, 'Bearer $token');

    response.when(
      success: (data) => emit(UpdateProfileState.success(data)),
      failure: (errorHandler) {
        log('UpdateProfile Error: ${errorHandler.serverFailure.errmessage}');
        emit(UpdateProfileState.error(
            error: errorHandler.serverFailure.errmessage));
      },
    );
  }
}