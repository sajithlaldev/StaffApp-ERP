import 'package:flutter/material.dart';
import '../../../common/default_textfield.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';

class ShiftEntriesPage extends StatelessWidget {
  final bool readOnly;
  final String? signature;

  ShiftEntriesPage({
    Key? key,
    required this.dayController,
    required this.fromController,
    required this.tillController,
    required this.dateController,
    required this.breakController,
    required this.billableHoursController,
    required this.shftRefController,
    required this.signaturePadKey,
    required this.signatureController,
    required this.readOnly,
    this.signature,
  }) : super(key: key);
  final TextEditingController dayController;
  final TextEditingController fromController;
  final TextEditingController tillController;
  final TextEditingController dateController;
  final TextEditingController breakController;
  final TextEditingController billableHoursController;
  final TextEditingController shftRefController;
  final TextEditingController signatureController;

  final GlobalKey<SfSignaturePadState> signaturePadKey;

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();
  final focusNode7 = FocusNode();
  final focusNode8 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: 520,
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
                    top: 15,
                  ),
                  decoration:
                      BoxDecoration(color: AppColors.primary.withOpacity(0.05)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextField(
                              controller: dayController,
                              caption: Strings.DAY + "*",
                              hintText: Strings.DAY,
                              isDense: true,
                              isColapsed: true,
                              focusNode: focusNode1,
                              nextFocusNode: focusNode2,
                              readOnly: readOnly,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DefaultTextField(
                              caption: Strings.DATE + "*",
                              controller: dateController,
                              hintText: Strings.DDMMYYYY,
                              isDense: true,
                              isColapsed: true,
                              focusNode: focusNode2,
                              nextFocusNode: focusNode3,
                              readOnly: readOnly,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextField(
                              controller: fromController,
                              caption: Strings.FROM + "*",
                              hintText: Strings.HHMM,
                              isDense: true,
                              isColapsed: true,
                              focusNode: focusNode3,
                              nextFocusNode: focusNode4,
                              readOnly: readOnly,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DefaultTextField(
                              controller: breakController,
                              caption: Strings.BREAK + "*",
                              hintText: Strings.HHMM,
                              isDense: true,
                              isColapsed: true,
                              focusNode: focusNode4,
                              nextFocusNode: focusNode5,
                              readOnly: readOnly,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DefaultTextField(
                              controller: tillController,
                              caption: Strings.TILL + "*",
                              hintText: Strings.HHMM,
                              isDense: true,
                              isColapsed: true,
                              focusNode: focusNode5,
                              nextFocusNode: focusNode6,
                              readOnly: readOnly,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextField(
                              controller: billableHoursController,
                              caption: Strings.BILLABLE_HOURS + "*",
                              hintText: Strings.HHMM,
                              isDense: true,
                              isColapsed: true,
                              focusNode: focusNode6,
                              nextFocusNode: focusNode7,
                              readOnly: readOnly,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                      DefaultTextField(
                        caption: Strings.SHIFT_REF + "*",
                        controller: shftRefController,
                        hintText: '',
                        isDense: true,
                        focusNode: focusNode7,
                        nextFocusNode: focusNode8,
                        isColapsed: true,
                        action: TextInputAction.done,
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Strings.AUTHORIZED_BY + "*",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              if (signature == null)
                                GestureDetector(
                                  onTap: () {
                                    signatureController.clear();
                                    signaturePadKey.currentState!.clear();
                                  },
                                  child: Text(
                                    Strings.CLEAR,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: signature != null
                                ? Image.network(
                                    signature!,
                                  )
                                : SfSignaturePad(
                                    minimumStrokeWidth: 1,
                                    maximumStrokeWidth: 3,
                                    onDrawEnd: () {
                                      signatureController.text = "true";
                                    },
                                    strokeColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    key: signaturePadKey,
                                  ),
                            height: 120,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 25,
                width: 150,
                child: ElevatedHeading(
                  title: Strings.SHIFT_ENTRY,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElevatedHeading extends StatelessWidget {
  final String title;
  final String? icon;

  const ElevatedHeading({
    Key? key,
    required this.title,
    this.icon,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Image.asset(icon!),
              if (icon != null)
                const SizedBox(
                  width: 5,
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
