import 'package:flutter/material.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/strings.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 8,
        right: 8,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.keyboard_arrow_left,
                  color: AppColors.bottomNavIconColor,
                  size: 38,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  Strings.FAQ_FULL,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
