import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheftaya/features/term_condition/presentation/widgets/term_condtion_view_body.dart';

class TermCondtionView extends StatelessWidget {
  const TermCondtionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: TermCondtionViewBody()),
    );
  }
}
