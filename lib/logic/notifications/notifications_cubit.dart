import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/overview/overview_repository.dart';

import '../../data/models/notification.dart';

class NotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded({
    required this.notifications,
  });
  @override
  List<Object?> get props => [notifications];
}

class NotificationsFailure extends NotificationsState {
  final String error;
  NotificationsFailure({
    required this.error,
  });
  @override
  List<Object?> get props => [
        error,
      ];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial()) {
    init();
  }

  init() async {
    emit(NotificationsLoading());
    try {
      List<NotificationModel> allNotifications =
          await NotificationRepository().loadNotifications();

      emit(
        NotificationsLoaded(
          notifications: allNotifications,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(
        NotificationsFailure(
          error: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
