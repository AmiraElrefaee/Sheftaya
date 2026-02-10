import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sheftaya/core/networking/server_result.dart';
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

  // ================= صور الهوية =================
  File? frontIdImage;
  File? backIdImage;
  File? selfieImage;

  void setFrontIdImage(File file) {
    frontIdImage = file;
  }

  void setBackIdImage(File file) {
    backIdImage = file;
  }

  void setSelfieImage(File file) {
    selfieImage = file;
  }

  // ================= Employer =================
  final companyNameController = TextEditingController();
  final companyTypeController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyCityController = TextEditingController();

  List<File> companyImages = [];

  void addCompanyImage(File file) {
    companyImages.add(file);
  }

  // ================= Worker =================
  final educationController = TextEditingController();
  final professionalStatusController = TextEditingController();
  final experienceYearsController = TextEditingController();
  final hourlyRateController = TextEditingController();

  List<String> pastExperience = [];
  List<String> jobsLookedFor = [];
  List<Availability> availabilityList = [];

  File? healthCertificate;

  void setHealthCertificate(File file) {
    healthCertificate = file;
  }

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
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    emit(const SignupState.loading());

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

      // إضافة مسارات الصور
      frontIdImage: frontIdImage?.path,
      backIdImage: backIdImage?.path,
      selfieImage: selfieImage?.path,

      employerProfile: selectedRole == 'employer'
          ? EmployerProfile(
              companyName: companyNameController.text.trim(),
              companyType: companyTypeController.text.trim(),
              companyAddress: companyAddressController.text.trim(),
              city: companyCityController.text.trim(),
              companyImages: companyImages.map((f) => f.path).toList(),
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
              healthCertificate: healthCertificate?.path,
            )
          : null,
    );

    final response = await _signupRepo.signup(signupBody);

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
