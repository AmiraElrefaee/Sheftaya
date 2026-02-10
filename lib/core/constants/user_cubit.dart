import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'user_model.dart';

class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? role;

  UserState({this.user, this.isLoading = false, this.role});

  UserState copyWith({UserModel? user, bool? isLoading, String? role}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      role: role ?? user?.role ?? this.role,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState(isLoading: true)) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    await _loadUserData();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _loadUserData() async {
    try {
      final savedUser = await getSavedUserData();
      if (savedUser != null) {
        emit(state.copyWith(user: savedUser, role: savedUser.role));
      }
    } catch (e) {
      log('Error loading user data: $e');
    }
  }

  void setUser(UserModel user) {
    emit(state.copyWith(user: user, role: user.role));
    log('User set: ${user.firstname} ${user.lastname}');
    saveUserDataLocally(user);
  }

  void clearUser() async {
    emit(UserState());
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.userId);
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.userEmail);
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.userPhone);
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.userToken);
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.userRole);
  }
}

Future<void> saveUserDataLocally(UserModel user) async {
  try {
    final Map<String, dynamic> userMap = user.toJson();

    if (user.token != null) userMap['token'] = user.token;
    if (user.birthday != null) userMap['data']['birthday'] = user.birthday;

    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userId, user.id);
    await SharedPrefHelper.setSecuredString(
      SharedPrefKeys.userEmail,
      user.email,
    );

    if (user.phone != null) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userPhone,
        user.phone!,
      );
    }
    if (user.token != null) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userToken,
        user.token!,
      );
    }

    if (user.role != null) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userRole,
        user.role!,
      );
    }

    log('User data saved locally: ${user.firstname}');
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
      phone: phone,
      role: role,
      token: token,
      profileImg: profile,
    );
  } catch (e) {
    log('❌ Error restoring user: $e');
    return null;
  }
}
