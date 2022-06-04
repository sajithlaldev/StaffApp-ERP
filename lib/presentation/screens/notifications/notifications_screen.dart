import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/notifications/notifications_cubit.dart';
import '../../../utils/colors.dart';
import 'components/appbar.dart';
import 'components/notification_list.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
        ),
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: AppBarWidget(),
          ),
          backgroundColor: AppColors.accent,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: _size.height * 0.82,
                  child: const NotificationList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
