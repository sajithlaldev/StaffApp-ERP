import 'package:flutter/material.dart';
import '../../../../data/models/shift.dart';
import '../../../../utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';
import '../../../common/widgets.dart';

class ConfirmationDetailsSection extends StatelessWidget {
  final Shift shift;
  const ConfirmationDetailsSection({Key? key, required this.shift})
      : super(key: key);

  void _launchURL(_url) async {
    if (!await launch(_url.toString())) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    String shiftTimeAsset = shift.shift_type! == "Day Shift"
        ? Assets.DAY_SHIFT
        : shift.shift_type! == "Night Shift"
            ? Assets.NIGHT_SHIFT
            : Assets.EARLY_SHIFT;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 480,
      child: Stack(
        children: [
          Positioned.fill(
            top: 15,
            child: Container(
              margin: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 8,
              ),
              decoration: Styles.boxDecoration(true),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 4,
                ),
                decoration:
                    BoxDecoration(color: AppColors.primary.withOpacity(0.05)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Confirmation Number : ' +
                          (shift.confirmation_number ?? "NA"),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          top: 0,
                          bottom: 0,
                          child: Divider(
                            height: 1,
                            thickness: 0.7,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: width * 0.45,
                            child: const ElevatedHeading(
                              title: Strings.CUSTOMER_DETAILS,
                              icon: Assets.CUSTOMER,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shift.customer!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  shift.customer!.address +
                                      ", " +
                                      shift.customer!.post_code,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (shift.status == "confirmed")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  _launchURL('tel:' + shift.customer!.phone);
                                },
                                child: Image.asset(Assets.CALL)),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          top: 0,
                          bottom: 0,
                          child: Divider(
                            height: 1,
                            thickness: 0.7,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: width * 0.45,
                            child: const ElevatedHeading(
                              title: Strings.SHIFT_DETAILS,
                              icon: Assets.SHIFT,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.FROM,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              Text(
                                Utils.formatTimeOnly(shift.from),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(Assets.CLOCK),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    shift.duration,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Image.asset(shiftTimeAsset),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                width: double.infinity,
                                child: DashedLine(
                                  color: Colors.white,
                                  height: 2,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(Assets.BREAKTIME),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    shift.break_time,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Strings.TILL,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              Text(
                                Utils.formatTimeOnly(shift.till),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.DATE,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              Text(
                                Utils.formatDateOnlyInReadFormat(shift.from),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Strings.AMOUNT,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Image.asset(Assets.POUNDS),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    shift.amount,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Strings.TYPE,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                shift.type,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          top: 0,
                          bottom: 0,
                          child: Divider(
                            height: 1,
                            thickness: 0.7,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: width * 0.45,
                            child: const ElevatedHeading(
                              title: Strings.PROVIDER_DETAILS,
                              icon: Assets.PROVIDER,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shift.provider.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                shift.provider.address1 +
                                    ", " +
                                    shift.provider.address2! +
                                    ", " +
                                    shift.provider.post_code,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final Uri params = Uri(
                                    scheme: 'mailto',
                                    path: shift.provider.email,
                                    query:
                                        'subject=Shift Enquiry&body=Enquiry on Shift:${shift.confirmation_number ?? shift.id}', //add subject and body here
                                  );
                                  _launchURL(params);
                                },
                                child: Image.asset(
                                  Assets.MAIL,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL('tel:' + shift.provider.phone);
                                },
                                child: Image.asset(
                                  Assets.CALL,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 25,
              width: width * 0.5,
              child: const ElevatedHeading(
                title: Strings.CONFIRMATION_DETAILS,
                isCentered: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ElevatedHeading extends StatelessWidget {
  final String title;
  final String? icon;
  final bool? isCentered;

  const ElevatedHeading({
    Key? key,
    required this.title,
    this.icon,
    this.isCentered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.boxDecoration(
        true,
        elevation: 1,
        spreadRadius: 2,
        cornerRadius: 8,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: isCentered != null && isCentered!
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (isCentered == null)
                const SizedBox(
                  width: 12,
                ),
              if (icon != null) Image.asset(icon!),
              if (icon != null)
                const SizedBox(
                  width: 10,
                ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
