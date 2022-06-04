import 'package:flutter/material.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/strings.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../common/default_textfield.dart';

class ClientAuthorization extends StatelessWidget {
  final bool readOnly;
  final String? clientSignature;
  final String? workerSignature;

  ClientAuthorization({
    Key? key,
    required this.nameController,
    required this.thtpController,
    required this.positionHoldController,
    required this.dateController,
    required this.tetpController,
    required this.clientSignatureKey,
    required this.agencySignatureKey,
    required this.readOnly,
    required this.isClientSignDrawnController,
    required this.isWorkerSignDrawnController,
    this.clientSignature,
    this.workerSignature,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController thtpController;
  final TextEditingController positionHoldController;
  final TextEditingController dateController;
  final TextEditingController tetpController;
  final TextEditingController isClientSignDrawnController;
  final TextEditingController isWorkerSignDrawnController;

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();

  GlobalKey<SfSignaturePadState> clientSignatureKey;
  GlobalKey<SfSignaturePadState> agencySignatureKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            Strings.CLIENT_AUTHORIZATION.toUpperCase(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTextField(
            controller: nameController,
            labelText: Strings.CLIENT_NAME + "*",
            isDense: true,
            focusNode: focusNode1,
            nextFocusNode: focusNode2,
            readOnly: true,
          ),
          DefaultTextField(
            controller: positionHoldController,
            labelText: Strings.POSITION_HOLD + "*",
            isDense: true,
            focusNode: focusNode2,
            nextFocusNode: focusNode3,
            readOnly: readOnly,
          ),
          DefaultTextField(
            controller: dateController,
            labelText: Strings.DATE + "*",
            isDense: true,
            focusNode: focusNode3,
            nextFocusNode: focusNode4,
            readOnly: readOnly,
          ),
          DefaultTextField(
            controller: thtpController,
            labelText: Strings.TOTAL_HOURS_TO_BE_PAID + "*",
            isDense: true,
            focusNode: focusNode4,
            nextFocusNode: focusNode5,
            readOnly: readOnly,
            textInputType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
          ),
          DefaultTextField(
            controller: tetpController,
            labelText: Strings.TOTAL_EXPENSES_TO_BE_PAID,
            isDense: true,
            focusNode: focusNode5,
            textInputType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            action: TextInputAction.done,
            readOnly: readOnly,
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.SIGNATURE + "*",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  if (clientSignature == null)
                    GestureDetector(
                      onTap: () {
                        isClientSignDrawnController.clear();
                        clientSignatureKey.currentState!.clear();
                      },
                      child: Text(
                        Strings.CLEAR,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                child: clientSignature != null
                    ? Image.network(
                        clientSignature!,
                      )
                    : SfSignaturePad(
                        key: clientSignatureKey,
                        minimumStrokeWidth: 1,
                        maximumStrokeWidth: 3,
                        onDrawEnd: () {
                          isClientSignDrawnController.text = "true";
                        },
                        strokeColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            Strings.CA_HEADING,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            Strings.CA_DECLARATION,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.AGENCY_WORKER_SIGNATURE + "*",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  if (workerSignature == null)
                    GestureDetector(
                      onTap: () {
                        isWorkerSignDrawnController.clear();
                        agencySignatureKey.currentState!.clear();
                      },
                      child: Text(
                        Strings.CLEAR,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                child: workerSignature != null
                    ? Image.network(
                        workerSignature!,
                      )
                    : SfSignaturePad(
                        key: agencySignatureKey,
                        minimumStrokeWidth: 1,
                        onDrawEnd: () {
                          isWorkerSignDrawnController.text = "true";
                        },
                        maximumStrokeWidth: 3,
                        strokeColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Row(
          //         children: [
          //           const Icon(
          //             Icons.keyboard_arrow_left,
          //             size: 40,
          //             color: Colors.white,
          //           ),
          //           Text(
          //             Strings.PREVIOUS,
          //             style: Theme.of(context).textTheme.bodyText1!.copyWith(
          //                   fontSize: 24,
          //                 ),
          //           ),
          //         ],
          //       ),
          //     ),

          //   ],
          // ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
