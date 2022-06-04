import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/assets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/styles.dart';

class ReferSection extends StatelessWidget {
  const ReferSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Share.share(
        Constants.shareMessage,
        subject: Constants.shareSubject,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: Styles.boxDecoration(true, cornerRadius: 10).copyWith(
          color: AppColors.primary,
        ),
        child: Row(
          children: [
            Image.asset(
              Assets.REFER,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    Strings.REFER_A_FRIEND.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    Strings.REFER_A_FRIEND_CAPTION,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}
