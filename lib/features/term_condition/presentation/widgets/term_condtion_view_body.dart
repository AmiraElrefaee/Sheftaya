import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/features/term_condition/presentation/widgets/term_section.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../publish_job/presentation/widgets/custom_app_bar.dart';
import '../../data/model/term_content.dart';

class TermCondtionViewBody extends StatelessWidget {
  const TermCondtionViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17),
      child: Column(
        children: [
          // استخدام الكاستم أب بار الذي وفرته
          CustomAppBar(
            title: "سياسة الدفع وشروط نشر الوظائف",
            onTap: () => context.pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 17.w ),
              child: Column(
                children: [

                  ...termsData.map((data) => TermsSection(content: data)),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),


          Padding(
            padding: EdgeInsets.all(20.w),
            child: AppTextButton(
              buttonText: "تأكيد",
              onPressed: () {
                // الأكشن عند الضغط
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
