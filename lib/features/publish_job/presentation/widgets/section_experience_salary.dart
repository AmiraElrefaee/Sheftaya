import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'custom_label_text.dart';

class sectionExpericeAndSalay extends StatefulWidget {
  const sectionExpericeAndSalay({
    super.key,
    required this.salaryController, required this.onExperienceChanged,
  });

  final TextEditingController salaryController;
  final Function(String?) onExperienceChanged;

  @override
  State<sectionExpericeAndSalay> createState() => _sectionExpericeAndSalayState();
}

class _sectionExpericeAndSalayState extends State<sectionExpericeAndSalay> {
  String ?item;
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabelText(text: 'الخبره'),
              AppDropdown(

                items: const ['بدون خبره', 'أقل من سنة', '1-3 سنوات', 'أكثر من 3 سنوات'],
                value: item,
                onChanged: (val) {
                  widget.onExperienceChanged(val);
                  setState(() {
                    item=val ??"بدون خبره";
                  });
                },
                hint: "بدون خبر",
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        // AppTextButton(
        //   buttonText: "نشر الوظيفة",
        //   onPressed: (){},
        // ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabelText(text: 'الراتب اليومي'),
              AppTextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
                controller: widget.salaryController,
                hintText: '0.00',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }
}