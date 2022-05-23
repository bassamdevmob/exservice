import 'package:bloc/bloc.dart';
import 'package:exservice/models/NotificationsModel.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'notification_list_event.dart';

part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc() : super(NotificationListAwaitState()) {
    on((event, emit) async {
      if (event is FetchNotificationListEvent) {
        try {
          emit(NotificationListAwaitState());
          notes = await GetIt.I.get<ApiProviderDelegate>().fetchNotifications();
          emit(NotificationListReceivedState());
        } catch (e) {
          emit(NotificationListErrorState("$e"));
        }
      }
    });
  }

  List<NotificationModel> notes;
}
