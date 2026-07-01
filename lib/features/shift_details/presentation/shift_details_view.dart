import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_details_view_body.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/enums.dart';

import '../../../core/di/service_locator.dart';
import 'managers/shift_cubit.dart'; // تأكدي من مسار الـ enum

class ShiftDetailsView extends StatelessWidget {
  // بنضيف الـ role هنا عشان لما ننتقل للصفحة دي نحدد هي لمين
  final UserRole role;
  // final String shiftId;

  const ShiftDetailsView(
      {super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // اختياري لتوحيد الخلفية
      body: SafeArea(
        child: ShiftDetailsViewBody(role: role), // ✅ تمرير الـ role للـ Body
      ),
    );
  }
}