import 'package:bloc/bloc.dart';
import 'package:exservice/models/response/notifications_response.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'notification_list_event.dart';

part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  List<NotificationModel> notes;
  NotificationListBloc() : super(NotificationListAwaitState()) {
    on((event, emit) async {
      if (event is FetchNotificationListEvent) {
        try {
          emit(NotificationListAwaitState());
          var response = await GetIt.I.get<UserRepository>().notifications();
          notes = response.data;
          emit(NotificationListReceivedState());
        } catch (e) {
          emit(NotificationListErrorState("$e"));
        }
      }
    });
  }

}
