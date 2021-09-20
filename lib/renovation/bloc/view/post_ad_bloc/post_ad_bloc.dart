// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// part 'post_ad_event.dart';
//
// part 'post_ad_state.dart';
//
// class PostAdBloc extends Bloc<PostAdEvent, PostAdState> {
//   PostAdBloc() : super(PostAdAwaitState());
//
//   @override
//   Stream<PostAdState> mapEventToState(
//     PostAdEvent event,
//   ) async* {
//     if (event is PostAdFetchEvent) {
//       try {
//         yield PostAdAwaitState();
//
//         yield PostAdReceiveState();
//       } catch (e) {
//         yield PostAdErrorState("$e");
//       }
//     }
//   }
// }
