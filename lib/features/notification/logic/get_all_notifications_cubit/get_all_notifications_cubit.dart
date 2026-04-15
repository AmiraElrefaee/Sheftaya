
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/notification/data/repos/get_all_notifications_repo.dart';
import 'package:sheftaya/features/notification/logic/get_all_notifications_cubit/get_all_notifications_state.dart';

class GetAllNotificationsCubit extends Cubit<GetAllNotificationsState> {
  final GetAllNotificationsRepo _notificationsRepo;

  GetAllNotificationsCubit(this._notificationsRepo)
      : super(const GetAllNotificationsState.initial());

  void fetchNotifications() async {
    emit(const GetAllNotificationsState.loading());

    String token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    final response = await _notificationsRepo.getAllNotifications(token);

    response.when(
      success: (notificationsResponse) {
        emit(
          GetAllNotificationsState.success(
              notificationsResponse.notificationsData),
        );
      },
      failure: (error) {
        emit(GetAllNotificationsState.error(
            error: error.serverFailure.errmessage
        ));
      },
    );
  }
}
