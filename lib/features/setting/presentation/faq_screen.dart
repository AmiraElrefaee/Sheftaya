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
          'شيفتاية هو تطبيق يربط بين أصحاب الأعمال والعمال بنظام الشيفتات اليومية، لتوفير فرص عمل مرنة وآمنة وسريعة للطرفين.',
    },
    {
      'question': 'من يمكنه استخدام تطبيق شيفتاية؟',
      'answer':
          'التطبيق مخصص لكل من الباحثين عن عمل يومي مرن (مثل الطلاب والخريجين) وأصحاب الأعمال الذين يحتاجون عمالة مؤقتة أو إضافية.',
    },
    {
      'question': 'كيف أجد شيفت مناسب لي؟',
      'answer':
          'يمكنك تصفح الشيفتات المتاحة داخل التطبيق، مع إمكانية التصفية حسب الموقع، الوقت، ونوع العمل لاختيار الأنسب لك.',
    },
    {
      'question': 'كيف يمكنني التقديم على شيفت؟',
      'answer':
          'بعد اختيار الشيفت المناسب، يمكنك الضغط على زر التقديم، ثم يتم مراجعة الطلب من صاحب العمل وقبوله أو رفضه.',
    },
    {
      'question': 'هل يمكنني إلغاء الشيفت بعد التقديم؟',
      'answer':
          'نعم، يمكن إلغاء الطلب قبل تأكيده، أو وفق سياسة الإلغاء الخاصة بصاحب العمل بعد القبول.',
    },
    {
      'question': 'كيف يتم ضمان حقوق العامل وصاحب العمل؟',
      'answer':
          'يتم حجز المبلغ داخل التطبيق حتى يتم تأكيد إتمام الشيفت من الطرفين، مما يضمن حقوق العامل وصاحب العمل بشكل آمن.',
    },
    {
      'question': 'ماذا يحدث في حالة وجود مشكلة أثناء الشيفت؟',
      'answer':
          'يمكنك تقديم بلاغ من داخل التطبيق، ويتم مراجعة المشكلة من فريق الدعم واتخاذ الإجراء المناسب مثل التحذير أو الحظر عند التكرار.',
    },
    {
      'question': 'هل يمكن تقييم الطرف الآخر بعد الشيفت؟',
      'answer':
          'نعم، يمكن لكل من العامل وصاحب العمل تقييم بعضهما بعد انتهاء الشيفت لضمان جودة التجربة.',
    },
    {
      'question': 'كيف يتم الدفع داخل التطبيق؟',
      'answer':
          'يتم الدفع بشكل آمن من خلال التطبيق، حيث يتم حجز المبلغ حتى انتهاء الشيفت ثم تحويله مباشرة للعامل بعد التأكيد.',
    },
    {
      'question': 'كيف أتواصل مع الدعم الفني؟',
      'answer':
          'يمكنك التواصل مع الدعم الفني من داخل التطبيق عبر قسم المساعدة أو البلاغات، وسيتم الرد في أقرب وقت.',
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
