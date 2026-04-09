import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/features/worker/home/data/models/review_model.dart';

class JobReviews extends StatelessWidget {
  final List<ReviewModel> reviews;

  const JobReviews({super.key, this.reviews = const []});

  double get _averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  Map<int, int> get _ratingCounts {
    final counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final key = r.rating.round().clamp(1, 5);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('التقييمات', style: TextStyles.font18BlackBold),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'لا توجد تقييمات بعد',
            style: TextStyles.font16BlackMedium,
          ),
        ),
      );
    }

    final counts = _ratingCounts;
    final avg = _averageRating;

    return Scaffold(
      appBar: AppBar(
        title: Text('التقييمات', style: TextStyles.font18BlackBold),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ─── Rating Summary Card ────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                // Left: overall score
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: avg.toStringAsFixed(1),
                            style: TextStyles.font24BlackBold.copyWith(
                              fontSize: 36.sp,
                            ),
                          ),
                          TextSpan(
                            text: '/5',
                            style: TextStyles.font16BlackMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 18.sp,
                          color: i < avg.round()
                              ? ColorsManager.warning
                              : ColorsManager.lightGrey,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '(${reviews.length} من التقييمات)',
                      style: TextStyles.font12BlackMedium.copyWith(
                        color: ColorsManager.darkGrey,
                      ),
                    ),
                  ],
                ),

                // Vertical divider
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 1,
                  height: 90.h,
                  color: ColorsManager.lightGrey,
                ),

                // Right: star breakdown bars
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final starNum = 5 - i;
                      final count = counts[starNum] ?? 0;
                      final fraction = reviews.isEmpty
                          ? 0.0
                          : count / reviews.length;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Row(
                              textDirection: TextDirection.rtl,
                              children: List.generate(
                                starNum,
                                (_) => Icon(
                                  Icons.star_rounded,
                                  size: 10.sp,
                                  color: ColorsManager.warning,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: fraction,
                                  minHeight: 8.h,
                                  backgroundColor: ColorsManager.lightGrey
                                      .withValues(alpha: 0.5),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        ColorsManager.warning,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // ─── Review Cards ───────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            itemCount: reviews.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (context, index) => _reviewCard(reviews[index]),
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(ReviewModel review) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundImage: review.avatarUrl != null
                ? NetworkImage(review.avatarUrl!)
                : null,
            backgroundColor: ColorsManager.primary.withValues(alpha: 0.15),
            child: review.avatarUrl == null
                ? Text(
                    review.userName.isNotEmpty ? review.userName[0] : '؟',
                    style: TextStyles.font18PrimaryBold,
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + date row
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyles.font14BlackSemiBold,
                    ),
                    Text(
                      review.date ?? '',
                      style: TextStyles.font12BlackMedium.copyWith(
                        color: ColorsManager.darkGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Rating
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      '${review.rating}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.star_rounded,
                      size: 15.sp,
                      color: ColorsManager.warning,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Comment
                Text(
                  review.comment,
                  textAlign: TextAlign.right,
                  style: TextStyles.font14BlackMedium.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
