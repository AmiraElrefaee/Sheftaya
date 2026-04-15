import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final List<Map<String, String>> faqData = [
    {
      'question': 'ما هو تطبيق شيفتاية؟',
      'answer':
          'شيفتاية هو تطبيق يربط بين أصحاب الشغل والموظفين لإدارة الشيفتات اليومية بسهولة وسرعة.',
    },
    {
      'question': 'كيف أبحث عن شيفت مناسب؟',
      'answer':
          'يمكنك تصفح الشيفتات المتاحة من خلال الصفحة الرئيسية، ثم اختيار الشيفت المناسب لك حسب الموقع، الوقت، ونوع العمل.',
    },
    {
      'question': 'كيف أقوم بالتقديم على شيفت؟',
      'answer':
          'بعد فتح تفاصيل الشيفت، اضغط على زر التقديم أو الحجز، ثم انتظر تأكيد الطلب من الطرف الآخر أو من الإدارة.',
    },
    {
      'question': 'هل يمكنني إلغاء التقديم على شيفت؟',
      'answer':
          'نعم، يمكنك إلغاء التقديم قبل تأكيد الشيفت حسب سياسة التطبيق أو سياسة صاحب العمل.',
    },
    {
      'question': 'ماذا أفعل إذا لم أجد تفاصيل الشيفت؟',
      'answer':
          'يمكنك التواصل مع الدعم الفني أو إرسال مشكلة من داخل التطبيق حتى يتم مراجعة الشيفت وإرسال التفاصيل الصحيحة.',
    },
    {
      'question': 'كيف أبلغ عن مشكلة في الشيفت؟',
      'answer':
          'اذهب إلى صفحة الدعم أو الشكاوى، ثم اختر نوع المشكلة واكتب التفاصيل، ويمكنك إرفاق صورة أو ملف إذا لزم الأمر.',
    },
    {
      'question': 'هل التطبيق مناسب للموظفين وأصحاب الشغل؟',
      'answer':
          'نعم، التطبيق مصمم ليخدم الطرفين: الموظف لعرض الشيفتات والتقديم عليها، وصاحب الشغل لإدارة الشيفتات والعمالة اليومية.',
    },
    {
      'question': 'كيف يتم تأكيد الحضور؟',
      'answer':
          'يتم تأكيد الحضور حسب آلية الشيفت داخل التطبيق، سواء من خلال صاحب الشغل أو من خلال النظام الداخلي للتطبيق.',
    },
    {
      'question': 'ماذا أفعل إذا حدثت مشكلة في الدفع؟',
      'answer':
          'في حالة وجود مشكلة في الأجر أو السداد، يمكنك إرسال بلاغ من صفحة الدعم مع توضيح المشكلة بشكل كامل.',
    },
    {
      'question': 'كيف أتواصل مع الدعم الفني؟',
      'answer':
          'يمكنك الدخول إلى صفحة الدعم داخل التطبيق واختيار نوع المشكلة ثم إرسالها، وسيتم مراجعتها في أقرب وقت.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الأسئلة الشائعة', style: TextStyles.font18BlackBold),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                right: 12.0,
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
      ),
    );
  }
}
