import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/notifications/notification_alert_cubit.dart';
import '../../../../logic/notifications/notifications_cubit.dart';

import '../../../../utils/colors.dart';

import '../widgets/notification_item.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationAlertCubit(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoaded) {
            if (state.notifications.isNotEmpty) {
              BlocProvider.of<NotificationAlertCubit>(context)
                  .markAsRead(state.notifications);

              return ListView.builder(
                itemCount: state.notifications.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return NotificationItem(
                      notificationModel: state.notifications[index]);
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'No Notifications Yet',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              );
            }
          } else if (state is NotificationsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
        },
      ),
    );
  }
}
