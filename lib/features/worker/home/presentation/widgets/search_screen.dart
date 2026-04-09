import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/widgets/custom_text_form_field.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/home_job_card.dart';

class SearchJobsScreen extends StatefulWidget {
  final List<dynamic> jobs;

  const SearchJobsScreen({super.key, required this.jobs});

  @override
  State<SearchJobsScreen> createState() => _SearchJobsScreenState();
}

class _SearchJobsScreenState extends State<SearchJobsScreen> {
  String query = '';
  String selectedFilter = 'الأعلى أجراً';
  final List<String> filters = ['الأعلى أجراً', 'الأقل أجراً'];
  bool showFilterDropdown = false;

  final GlobalKey _filterKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      showFilterDropdown = true;
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      showFilterDropdown = false;
    }
    setState(() {});
  }

  OverlayEntry _createOverlay() {
    final renderBox =
        _filterKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + renderBox.size.height + 5,
        left: position.dx,
        width: 140.w,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: filters.map((f) {
              final selected = f == selectedFilter;
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedFilter = f;
                  });
                  _toggleDropdown();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 12.w,
                  ),
                  alignment: Alignment.centerLeft,
                  color: selected
                      ? ColorsManager.primary.withValues(alpha: 0.1)
                      : Colors.white,
                  child: Text(
                    f,
                    style: TextStyles.font14BlackMedium.copyWith(
                      color: selected ? ColorsManager.primary : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _titleOf(dynamic job) {
    try {
      return (job.title ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  double _salaryOf(dynamic job) {
    try {
      // 1. check if it's a model with pricePerHour.amount
      if (job.pricePerHour != null && job.pricePerHour.amount != null) {
        return (job.pricePerHour.amount as num).toDouble();
      }
      // 2. check if it's a map
      if (job is Map) {
        if (job['pricePerHour']?['amount'] != null) {
          return (job['pricePerHour']['amount'] as num).toDouble();
        }
        if (job['salary'] != null) {
          return (job['salary'] as num).toDouble();
        }
      }
      // 3. check direct salary property
      if (job.salary != null) {
        return (job.salary as num).toDouble();
      }
    } catch (_) {}
    return 0;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم List<dynamic> لتجنب مشاكل الـ casting
    final List<dynamic> filtered = widget.jobs
        .where((j) => _titleOf(j).toLowerCase().contains(query.toLowerCase()))
        .toList();

    filtered.sort((a, b) {
      if (selectedFilter == 'الأعلى أجراً') {
        return _salaryOf(b).compareTo(_salaryOf(a));
      }
      return _salaryOf(a).compareTo(_salaryOf(b));
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('بحث عن وظيفة', style: TextStyles.font18BlackBold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    hintText: 'ابحث عن وظيفة',
                    onChanged: (v) => setState(() => query = v),
                    prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  key: _filterKey,
                  onTap: _toggleDropdown,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorsManager.primary),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: ColorsManager.primary,
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد وظائف مطابقة',
                      style: TextStyles.font20BlackBold,
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (_, i) => HomeJobCard(job: filtered[i]),
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemCount: filtered.length,
                  ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
