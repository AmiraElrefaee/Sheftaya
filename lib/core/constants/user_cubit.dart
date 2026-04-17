import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/auth_me_response.dart';
import 'package:sheftaya/features/setting/my_profile/data/repos/auth_me_repo.dart';
import 'user_model.dart';

class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? role;

  UserState({this.user, this.isLoading = false, this.role});

  UserState copyWith({UserModel? user, bool? isLoading, String? role}) =>
      UserState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        role: role ?? user?.role ?? this.role,
      );
}

class UserCubit extends Cubit<UserState> {
  final AuthMeRepo _authMeRepo;

  UserCubit(this._authMeRepo) : super(UserState(isLoading: true)) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    await _loadFromStorage();
    emit(state.copyWith(isLoading: false));
    if (state.user != null) {
      await refreshProfile();
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final saved = await getSavedUserData();
      if (saved != null) emit(state.copyWith(user: saved, role: saved.role));
    } catch (e) {
      log('Error loading user data: $e');
    }
  }

  Future<void> refreshProfile() async {
    try {
      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );
      if (token.isEmpty) return;
      final response = await _authMeRepo.getMe('Bearer $token');
      response.whenOrNull(success: updateFromAuthMe);
    } catch (e) {
      log('Error refreshing profile: $e');
    }
  }

  void setUser(UserModel user) {
    emit(state.copyWith(user: user, role: user.role));
    saveUserDataLocally(user);
    log('User set: ${user.firstname} ${user.lastname} (${user.role})');
  }

  void updateFromAuthMe(AuthMeResponse response) {
    final authUser = response.data?.user;
    final wp = response.data?.workerProfile;
    final ep = response.data?.profile;
    final current = state.user;

    if (authUser == null && current == null) return;

    final updated = UserModel(
      id: authUser?.id ?? current?.id ?? '',
      firstname: authUser?.firstName ?? current?.firstname ?? '',
      lastname: authUser?.lastName ?? current?.lastname ?? '',
      email: authUser?.email ?? current?.email ?? '',
      role: authUser?.role ?? current?.role,
      phone: current?.phone,
      token: current?.token,
      // imageProfile from auth/me user object
      profileImg: authUser?.imageProfile ?? current?.profileImg,
      city: authUser?.city ?? current?.city,
      birthday: authUser?.birthday ?? current?.birthday,
      // Worker profile
      education: wp?.education ?? current?.education,
      professionalStatus: wp?.professionalStatus ?? current?.professionalStatus,
      pastExperience: wp?.pastExperience ?? current?.pastExperience,
      jobsLookedFor: wp?.jobsLookedFor ?? current?.jobsLookedFor,
      experienceYears: wp?.experienceYears ?? current?.experienceYears,
      expectedHourlyRate:
          wp?.expectedHourlyRate?.amount?.toDouble() ??
          current?.expectedHourlyRate,
      healthCertificate: wp?.healthCertificate ?? current?.healthCertificate,
      // Employer profile
      companyName: ep?.companyName ?? current?.companyName,
      companyType: ep?.companyType ?? current?.companyType,
      companyAddress: ep?.companyAddress ?? current?.companyAddress,
      companyCity: ep?.city ?? current?.companyCity,
      companyImages: ep?.companyImages ?? current?.companyImages,
    );

    emit(state.copyWith(user: updated, role: updated.role));
    saveUserDataLocally(updated);
    log('UserCubit updated from AuthMe: ${updated.firstname}');
  }

  void clearUser() async {
    emit(UserState());
    for (final key in [
      SharedPrefKeys.userId,
      SharedPrefKeys.userEmail,
      SharedPrefKeys.userPhone,
      SharedPrefKeys.userToken,
      SharedPrefKeys.userRole,
      SharedPrefKeys.userFirstName,
      SharedPrefKeys.userLastName,
      SharedPrefKeys.userProfileImage,
    ]) {
      await SharedPrefHelper.removeSecuredData(key);
    }
  }
}

// ─── helpers ─────────────────────────────────────────────────────────────────

Future<void> saveUserDataLocally(UserModel user) async {
  try {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userId, user.id);
    await SharedPrefHelper.setSecuredString(
      SharedPrefKeys.userEmail,
      user.email,
    );
    if (user.firstname.isNotEmpty) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userFirstName,
        user.firstname,
      );
    }
    if (user.lastname.isNotEmpty) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userLastName,
        user.lastname,
      );
    }
    if (user.phone?.isNotEmpty == true) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userPhone,
        user.phone!,
      );
    }
    if (user.token?.isNotEmpty == true) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userToken,
        user.token!,
      );
    }
    if (user.role?.isNotEmpty == true) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userRole,
        user.role!,
      );
    }
    if (user.profileImg?.isNotEmpty == true) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userProfileImage,
        user.profileImg!,
      );
    }
  } catch (e) {
    log('Error saving user data: $e');
  }
}

Future<UserModel?> getSavedUserData() async {
  try {
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    if (token.isEmpty) return null;

    final id = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    final email = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userEmail,
    );
    final phone = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userPhone,
    );
    final role = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userRole,
    );
    final profile = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userProfileImage,
    );
    final firstName = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userFirstName,
    );
    final lastName = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userLastName,
    );

    return UserModel(
      id: id,
      firstname: firstName,
      lastname: lastName,
      email: email,
      phone: phone.isEmpty ? null : phone,
      role: role.isEmpty ? null : role,
      token: token,
      profileImg: profile.isEmpty ? null : profile,
    );
  } catch (e) {
    log('Error restoring user: $e');
    return null;
  }
}
