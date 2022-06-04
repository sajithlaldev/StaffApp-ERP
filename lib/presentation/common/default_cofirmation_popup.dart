import 'package:flutter/material.dart';
import 'widgets.dart';
import '../../utils/colors.dart';

import '../../utils/strings.dart';
import '../../utils/styles.dart';

class DefaultConfirmationPopup extends StatelessWidget {
  final String title;
  final String? caption;
  final Function yesFunction;
  final String yesText;
  final String? noText;

  final bool? isLoading;

  const DefaultConfirmationPopup({
    Key? key,
    required this.title,
    required this.yesText,
    this.isLoading,
    this.noText,
    this.caption,
    required this.yesFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: _size.width * 0.8,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    caption != null
                        ? Text(
                            caption!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.grey),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: OutlinedButton(
                              style: Styles.SECONDARY_ELEVATED_BUTTON_THEME,
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                noText ?? Strings.CLOSE,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: ElevatedButton(
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style!
                                  .copyWith(
                                    textStyle: MaterialStateProperty.all(
                                        Theme.of(context).textTheme.bodyText1),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                  ),
                              onPressed: () {
                                yesFunction();
                              },
                              child: isLoading != null && isLoading!
                                  ? const Loader()
                                  : Text(
                                      yesText,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
