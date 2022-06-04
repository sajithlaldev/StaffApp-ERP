import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/faq/faq_cubit.dart';
import '../../../../logic/notifications/notification_alert_cubit.dart';
import '../../../../logic/notifications/notifications_cubit.dart';

import '../../../../utils/colors.dart';

import '../widgets/faq_item.dart';

class FaqList extends StatelessWidget {
  const FaqList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqCubit, FaqState>(
      builder: (context, state) {
        if (state is FaqLoaded) {
          if (state.faqs.isNotEmpty) {
            return ListView.builder(
              itemCount: state.faqs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return FaqItem(faqModel: state.faqs[index]);
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
                    'No Faqs Yet',
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
    );
  }
}
