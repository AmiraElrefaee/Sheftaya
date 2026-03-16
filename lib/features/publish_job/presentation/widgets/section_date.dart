import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import 'custom_label_text.dart';

class SectionDate extends StatefulWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;

  const SectionDate({
    super.key,
    required this.dateController,
    required this.timeController,
  });

  @override
  State<SectionDate> createState() => _SectionDateState();
}

class _SectionDateState extends State<SectionDate> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomLabelText(text: 'ساعة بدء العمل'),
              AppTextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
                controller: widget.timeController,
                hintText: '--:--',
                readOnly: true,
                suffixIcon: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomLabelText(text: 'تاريخ العمل'),
              AppTextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
                controller: widget.dateController,
                hintText: 'يوم/شهر/سنة',
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_month_outlined),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('en'), // التاريخ بالأرقام الإنجليزية
    );
    if (picked != null) {
      setState(() {
        // صيغة YYYY-MM-DD لتكون مناسبة للـ backend
        widget.dateController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // تحويل الوقت ل24h format HH:mm لتجنب مشاكل DateFormat مع الأرقام العربية
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        widget.timeController.text =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      });
    }
  }
}