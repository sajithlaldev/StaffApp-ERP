import 'dart:ui';

import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';

Widget buildErrorSheet(
  BuildContext context, {
  String? title,
  required String errorMessage,
  String? assetName,
}) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    color: AppColors.lightAccent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        title != null
            ? Container(
                padding: const EdgeInsets.only(
                  top: 36,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: ElevatedButton(
            child: const Text(
              Strings.OK,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(
          height: 18,
        ),
      ],
    ),
  );
}
