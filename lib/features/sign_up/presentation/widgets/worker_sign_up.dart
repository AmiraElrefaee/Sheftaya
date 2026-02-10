import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/core/widgets/app_dropdown.dart';
import 'package:sheftaya/core/widgets/app_multi_select_dropdown.dart';
import 'package:sheftaya/features/sign_up/presentation/widgets/upload_tile.dart';

class WorkerSignUp extends StatelessWidget {
  final TextEditingController educationController;
  final String? workerStatus;
  final ValueChanged<String?> onStatusChanged;
  final List<String> previousJobs;
  final List<String> dailyJobs;
  final List<String> searchingJobs;
  final ValueChanged<List<String>> onPreviousJobsChanged;
  final ValueChanged<List<String>> onDailyJobsChanged;
  final ValueChanged<List<String>> onSearchingJobsChanged;
  final List<String> sampleJobs;
  final File? healthCertificate;
  final VoidCallback onPickHealthCert;
  final bool showWorkerStatusError;
  final bool showPreviousJobsError;
  final bool showSearchingJobsError;
  final bool showEducationError;
    final ValueChanged<String>? onEducationChanged; 


  const WorkerSignUp({
    super.key,
    required this.educationController,
    required this.workerStatus,
    required this.onStatusChanged,
    required this.previousJobs,
    required this.dailyJobs,
    required this.searchingJobs,
    required this.onPreviousJobsChanged,
    required this.onDailyJobsChanged,
    required this.onSearchingJobsChanged,
    required this.sampleJobs,
    required this.healthCertificate,
    required this.onPickHealthCert,
    this.showPreviousJobsError = false,
    this.showSearchingJobsError = false,
    this.showWorkerStatusError = false,
    this.showEducationError = false,
        this.onEducationChanged, 

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'معلومات مهنية',
            style: TextStyles.font16BlackBold.copyWith(fontSize: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text('التعليم / التخصص', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
                    AppTextFormField(
            controller: educationController,
            hintText: 'ادخل مجال دراستك أو تخصصك',
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'التعليم / التخصص مطلوب';
              }
              return null;
            },
            hasError: showEducationError,
            onChanged: onEducationChanged,
          ),
          SizedBox(height: 12.h),

          SizedBox(height: 12.h),
          Text('الحالة المهنية', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppDropdown(
            items: ['طالب', 'موظف دوام كامل', 'موظف جزئي', 'لا أعمل'],
            value: workerStatus,
            hint: 'اختر حالتك المهنية',
            onChanged: onStatusChanged,
            hasError: showWorkerStatusError,
            errorMessage: 'الحالة المهنية مطلوبة',
          ),
          SizedBox(height: 12.h),
          Text('الوظائف السابقة', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppMultiSelectDropdown(
            items: sampleJobs,
            selectedValues: previousJobs,
            hint: 'اختر وظائفك السابقة',
            onChanged: onPreviousJobsChanged,
            hasError: showPreviousJobsError,
            errorMessage: 'يجب اختيار وظيفة واحدة على الأقل',
          ),
          SizedBox(height: 12.h),
          Text('الوظائف التي تبحث عنها', style: TextStyles.font14BlackRegular),
          SizedBox(height: 8.h),
          AppMultiSelectDropdown(
            items: sampleJobs,
            selectedValues: searchingJobs,
            hint: 'اختر الوظائف التي تبحث عنها',
            onChanged: onSearchingJobsChanged,
            hasError: showSearchingJobsError,
            errorMessage: 'يجب اختيار وظيفة واحدة على الأقل',
          ),
          SizedBox(height: 12.h),
          Text(
            'الشهادة الصحية (إختياري)',
            style: TextStyles.font14BlackRegular,
          ),
          SizedBox(height: 8.h),
          UploadTile(
            label: healthCertificate == null
                ? 'ارفع الملف هنا'
                : healthCertificate!.path.split('/').last,
            onPick: onPickHealthCert,
            file: healthCertificate,
            acceptPdf: true,
          ),
        ],
      ),
    );
  }
}
