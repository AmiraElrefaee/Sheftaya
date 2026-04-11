import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final List<Map<String, String>> faqData = [
    {'question': 'faq.q1', 'answer': 'faq.a1'},
    {'question': 'faq.q2', 'answer': 'faq.a2'},
    {'question': 'faq.q3', 'answer': 'faq.a3'},
    {'question': 'faq.q4', 'answer': 'faq.a4'},
    {'question': 'faq.q5', 'answer': 'faq.a5'},
    {'question': 'faq.q6', 'answer': 'faq.a6'},
    {'question': 'faq.q7', 'answer': 'faq.a7'},
    {'question': 'faq.q8', 'answer': 'faq.a8'},
    {'question': 'faq.q9', 'answer': 'faq.a9'},
    {'question': 'faq.q10', 'answer': 'faq.a10'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('faq.title', style: TextStyles.font18BlackBold),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              itemCount: faqData.length,
              itemBuilder: (context, index) {
                final item = faqData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        title: Text(
                          item['question']!,
                          style: TextStyles.font14BlackSemiBold,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              bottom: 12,
                            ),
                            child: Text(
                              item['answer']!,
                              style: TextStyles.font14BlackMedium.copyWith(
                                color: ColorsManager.darkGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: ColorsManager.lightGrey,
                    ),
                    const SizedBox(height: 4),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
