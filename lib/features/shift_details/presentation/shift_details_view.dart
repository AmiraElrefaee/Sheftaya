import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheftaya/features/shift_details/presentation/widget/shift_details_view_body.dart';

class ShiftDetailsView extends StatelessWidget {
  const ShiftDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShiftDetailsViewBody(),
    );
  }
}
