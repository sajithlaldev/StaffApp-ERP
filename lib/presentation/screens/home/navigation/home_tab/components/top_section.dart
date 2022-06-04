import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../logic/notifications/notification_alert_cubit.dart';
import '../../../../../../utils/routes.dart';

import '../../../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../../../utils/assets.dart';
import '../../../../../../utils/strings.dart';
import '../../../../../common/badge_icon.dart';

class TopSection extends StatelessWidget {
  const TopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationSuccess? state =
        context.read<AuthenticationCubit>().state is AuthenticationSuccess
            ? context.read<AuthenticationCubit>().state as AuthenticationSuccess
            : null;

    return BlocProvider(
      create: (context) => NotificationAlertCubit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.WELCOME_BACK,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    state?.staff?.name ?? "",
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.NOTIFICATIONS,
                    ),
                    child: BlocBuilder<NotificationAlertCubit,
                        NotificationAlertState>(
                      builder: (context, state) {
                        return BadgeIcon(
                          icon: Assets.NOTIFICATIONS,
                          text: state is NotificationNewAlert &&
                                  state.notificationModel.isNotEmpty
                              ? state.notificationModel.length.toString()
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
