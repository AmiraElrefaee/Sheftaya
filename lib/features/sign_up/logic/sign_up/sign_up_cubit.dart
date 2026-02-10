import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_request_body.dart';
import 'package:sheftaya/features/sign_up/data/repo/sign_up_repo.dart';
import 'sign_up_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo _signupRepo;

  SignupCubit(this._signupRepo) : super(const SignupState.initial());

  // ================= Controllers =================
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final birthDateController = TextEditingController();

  // ================= Common =================
  String selectedRole = 'worker'; // worker | employer
  String preferredLang = 'ar';

  final formKey = GlobalKey<FormState>();

  void setRole(String role) {
    selectedRole = role;
  }

  // ================= Employer =================
  final companyNameController = TextEditingController();
  final companyTypeController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyCityController = TextEditingController();

  // ================= Worker =================
  final educationController = TextEditingController();
  final professionalStatusController = TextEditingController();
  final experienceYearsController = TextEditingController();
  final hourlyRateController = TextEditingController();

  List<String> pastExperience = [];
  List<String> jobsLookedFor = [];

  List<Availability> availabilityList = [];

  // ================= Dispose =================
  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    phoneController.dispose();
    cityController.dispose();
    birthDateController.dispose();

    companyNameController.dispose();
    companyTypeController.dispose();
    companyAddressController.dispose();
    companyCityController.dispose();

    educationController.dispose();
    professionalStatusController.dispose();
    experienceYearsController.dispose();
    hourlyRateController.dispose();

    return super.close();
  }

  // ================= SIGNUP =================
  Future<void> emitSignupStates() async {
    if (!formKey.currentState!.validate()) return;

    emit(const SignupState.loading());

    // قراءة التوكن من SharedPreferences
    final signupToken = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    final signupBody = SignupRequestBody(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: passwordConfirmController.text,
      role: selectedRole,
      phone: phoneController.text.isEmpty ? null : phoneController.text,
      preferredLang: preferredLang,
      city: cityController.text,
      birthDate: birthDateController.text.isEmpty
          ? null
          : birthDateController.text,

      employerProfile: selectedRole == 'employer'
          ? EmployerProfile(
              companyName: companyNameController.text.trim(),
              companyType: companyTypeController.text.trim(),
              companyAddress: companyAddressController.text.trim(),
              city: companyCityController.text.trim(),
            )
          : null,

      workerProfile: selectedRole == 'worker'
          ? WorkerProfile(
              education: educationController.text.trim(),
              professionalStatus: professionalStatusController.text.trim(),
              pastExperience: pastExperience,
              jobsLookedFor: jobsLookedFor,
              experienceYears:
                  int.tryParse(experienceYearsController.text) ?? 0,
              availability: availabilityList,
              expectedHourlyRate: ExpectedHourlyRate(
                amount: num.tryParse(hourlyRateController.text) ?? 0,
                currency: "EGP",
              ),
            )
          : null,
    );

    final response = await _signupRepo.signup(signupToken, signupBody);

    response.when(
      success: (signupResponse) {
        emit(SignupState.success(signupResponse));
      },
      failure: (errorHandler) {
        log("Signup Error: ${errorHandler.serverFailure.errmessage}");
        emit(SignupState.error(error: errorHandler.serverFailure.errmessage));
      },
    );
  }
}
