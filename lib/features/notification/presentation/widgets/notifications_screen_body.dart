import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheftaya/core/theme/colors_manager.dart';
import 'package:sheftaya/core/theme/text_styles.dart';
import 'package:sheftaya/core/utils/snackbar.dart';
import 'package:sheftaya/core/widgets/custom_button.dart';
import 'package:sheftaya/features/notification/logic/get_all_notifications_cubit/get_all_notifications_cubit.dart';
import 'package:sheftaya/features/notification/logic/get_all_notifications_cubit/get_all_notifications_state.dart';
import 'package:sheftaya/features/notification/logic/notification_cubit/notification_cubit.dart';
import 'package:sheftaya/features/notification/logic/notification_cubit/notification_state.dart';
import 'package:sheftaya/features/notification/presentation/widgets/notification_card.dart';
import 'package:sheftaya/features/notification/presentation/widgets/notification_model.dart';

class NotificationsScreenBody extends StatefulWidget {
  const NotificationsScreenBody({super.key});

  @override
  State<NotificationsScreenBody> createState() =>
      _NotificationsScreenBodyState();
}

class _NotificationsScreenBodyState extends State<NotificationsScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAllNotificationsCubit>().fetchNotifications();
    });
  }

  Future<void> _refreshNotifications() async {
    context.read<GetAllNotificationsCubit>().fetchNotifications();
  }

  void _showDeleteAllDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'حذف جميع الاشعارات',
      desc: 'هل تريد حذف جميع الاشعارات؟',
      btnCancelText: 'إلغاء',
      btnOkText: 'حذف',
      btnCancelColor: ColorsManager.lightGrey,
      btnOkColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<NotificationsCubit>().deleteAllNotifications(context);
      },
    ).show();
  }

  void _showDeleteSingleDialog(NotificationModel notification) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'حذف ذلك الاشعار',
      desc: 'هل تريد حذف هذا الاشعار؟',
      btnCancelText: 'إلغاء',
      btnOkText: 'حذف',
      btnCancelColor: ColorsManager.lightGrey,
      btnOkColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<NotificationsCubit>().deleteNotification(
          notification.id,
          context,
        );
      },
    ).show();
  }

  List<NotificationModel> _mapToModels(dynamic notificationsData) {
    if (notificationsData == null) return [];
    final rawList = notificationsData as List<dynamic>;
    return rawList.map((item) => NotificationModel.fromData(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            state.maybeWhen(
              deleteSuccess: () {
                customSnackBar(
                  context,
                  'تم حذف الاشعار بنجاح',
                  ColorsManager.primary,
                );
              },
              error: (error) {
                customSnackBar(context, error, Colors.red);
              },
              orElse: () {},
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text('الاشعارات', style: TextStyles.font18BlackBold),
          actions: [
            BlocBuilder<GetAllNotificationsCubit, GetAllNotificationsState>(
              builder: (context, state) {
                final hasNotifications = state.maybeWhen(
                  success: (data) {
                    final list = _mapToModels(data);
                    return list.isNotEmpty;
                  },
                  orElse: () => false,
                );

                return IconButton(
                  onPressed: hasNotifications ? _showDeleteAllDialog : null,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: hasNotifications
                        ? ColorsManager.primary
                        : ColorsManager.lightGrey,
                  ),
                  tooltip: 'حذف جميع الاشعارات',
                );
              },
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<GetAllNotificationsCubit, GetAllNotificationsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (notificationsData) {
                final notifications = _mapToModels(notificationsData);

                if (notifications.isEmpty) {
                  return _buildEmptyState(context);
                }

                final newNotifications = notifications
                    .where((n) => n.isNew)
                    .toList();
                final oldNotifications = notifications
                    .where((n) => !n.isNew)
                    .toList();

                return RefreshIndicator(
                  onRefresh: _refreshNotifications,
                  color: ColorsManager.primary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    children: [
                      if (newNotifications.isNotEmpty) ...[
                        Text('جديده', style: TextStyles.font18BlackBold),
                        SizedBox(height: 12.h),
                        ...newNotifications.map(
                          (notification) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: NotificationCard(
                              notification: notification,
                              onTap: () =>
                                  _showDeleteSingleDialog(notification),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                      if (oldNotifications.isNotEmpty) ...[
                        Text('قديمه', style: TextStyles.font18BlackBold),
                        SizedBox(height: 12.h),
                        ...oldNotifications.map(
                          (notification) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: NotificationCard(
                              notification: notification,
                              onTap: () =>
                                  _showDeleteSingleDialog(notification),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              error: (error) => _buildErrorState(context, error),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      color: ColorsManager.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 140.h),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 72.w,
                  color: ColorsManager.lightGrey,
                ),
                SizedBox(height: 12.h),
                Text(
                  'لا يوجد اشعارات',
                  style: TextStyles.font16BlackRegular.copyWith(
                    color: ColorsManager.grey,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 180.w,
                  child: AppTextButton(
                    onPressed: _refreshNotifications,
                    buttonHeight: 44.h,
                    buttonText: 'إعادة التحميل',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      color: ColorsManager.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 140.h),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 72.w,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 12.h),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyles.font16BlackRegular.copyWith(
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 180.w,
                  child: AppTextButton(
                    onPressed: _refreshNotifications,
                    buttonHeight: 44.h,
                    buttonText: 'إعادة التحميل',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
