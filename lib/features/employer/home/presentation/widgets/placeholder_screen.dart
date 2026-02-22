import 'package:flutter/material.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class PlaceholderScreen extends StatelessWidget {
  final String label;
  const PlaceholderScreen({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(label,
            style: TextStyles.font24BlackBold),
      ),
    );
  }
}