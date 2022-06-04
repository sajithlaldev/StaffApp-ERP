import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiftapp/utils/colors.dart';
import '../../../../data/models/notification.dart';
import '../../../../utils/utils.dart';
import '../../../../../../utils/styles.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationItem({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 6,
        top: 6,
      ),
      decoration: Styles.boxDecoration(false),
      child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 8,
            bottom: 4,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationModel.title ??
                              ("New key from " +
                                  (notificationModel.created_by_name?['name'] ??
                                      notificationModel.created_by!)),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          notificationModel.message ??
                              "Your enrollment key is ${notificationModel.key}. Please copy by clicking the icon and paste it in the enrollment key section.",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (notificationModel.type == "key")
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: notificationModel.key,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard.'),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  Utils.formatDate(notificationModel.created_on!),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                ),
              )
            ],
          )),
    );
  }
}
