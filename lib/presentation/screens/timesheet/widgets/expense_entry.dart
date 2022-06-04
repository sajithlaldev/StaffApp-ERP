import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/data/models/view_timesheets/expense_entry_model.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../../data/models/shift.dart';
import '../../../../data/models/view_timesheets/timesheet.dart';
import '../../../../logic/expense_entries/expense_entries_cubit.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../common/default_textfield.dart';
import '../components/expense_entries.dart';

class ExpenseEntry extends StatefulWidget {
  final bool readOnly;
  final int index;
  final ExpenseEntryModel expenseEntryModel;
  final Shift? shift;
  final TimeSheet? timeSheet;

  ExpenseEntry({
    Key? key,
    required this.readOnly,
    required this.expenseEntryModel,
    required this.index,
    required this.shift,
    this.timeSheet,
  }) : super(key: key);

  @override
  State<ExpenseEntry> createState() => _ExpenseEntryState();
}

class _ExpenseEntryState extends State<ExpenseEntry> {
  final TextEditingController dayController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController typeController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  final TextEditingController qtyController = TextEditingController();

  final TextEditingController poNumberController = TextEditingController();

  final TextEditingController unitCostController = TextEditingController();

  final TextEditingController totalController = TextEditingController();

  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

  final focusNode1 = FocusNode();

  final focusNode2 = FocusNode();

  final focusNode3 = FocusNode();

  final focusNode4 = FocusNode();

  final focusNode5 = FocusNode();

  final focusNode6 = FocusNode();

  final focusNode7 = FocusNode();

  final focusNode8 = FocusNode();

  bool isDrawn = false;

  onContrillersChnaged(BuildContext context) {
    BlocProvider.of<ExpenseEntriesCubit>(context).onExpenseModelChanged(
      widget.index,
      ExpenseEntryModel(
        day: dayController.text,
        date: dateController.text,
        desc: descController.text,
        quatity: qtyController.text,
        total: totalController.text,
        unitCosts: unitCostController.text,
        poNumber: poNumberController.text,
        type: typeController.text,
        authorizedBy: widget.expenseEntryModel.authorizedBy ?? "",
        signatureKey: signaturePadKey,
        isDrawn: isDrawn,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onContrillersChnaged(context);

    dayController.addListener(() {
      onContrillersChnaged(context);
    });
    dateController.addListener(() {
      onContrillersChnaged(context);
    });
    descController.addListener(() {
      onContrillersChnaged(context);
    });
    qtyController.addListener(() {
      onContrillersChnaged(context);
    });
    totalController.addListener(() {
      onContrillersChnaged(context);
    });
    unitCostController.addListener(() {
      onContrillersChnaged(context);
    });
    poNumberController.addListener(() {
      onContrillersChnaged(context);
    });
    typeController.addListener(() {
      onContrillersChnaged(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 540,
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
                  top: 12,
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
                            controller: dayController
                              ..text = Utils.getDayOfWeekFromDate(
                                  widget.shift?.from ??
                                      widget.expenseEntryModel.date ??
                                      ""),
                            caption: Strings.DAY+"*",
                            hintText: Strings.DAY,
                            isDense: true,
                            isColapsed: true,
                            focusNode: focusNode1,
                            nextFocusNode: focusNode2,
                            readOnly: widget.readOnly,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DefaultTextField(
                            caption: Strings.DATE+"*",
                            controller: dateController
                              ..text = widget.shift?.from != null
                                  ? Utils.formatDateOnly(widget.shift!.from)
                                  : widget.expenseEntryModel.date,
                            hintText: Strings.DDMMYYYY,
                            isDense: true,
                            isColapsed: true,
                            focusNode: focusNode2,
                            nextFocusNode: focusNode3,
                            readOnly: widget.readOnly,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextField(
                            controller: typeController
                              ..text = widget.expenseEntryModel.type ?? "",
                            labelText: Strings.TYPE+"*",
                            isDense: true,
                            isColapsed: true,
                            focusNode: focusNode3,
                            nextFocusNode: focusNode4,
                            readOnly: widget.readOnly,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DefaultTextField(
                            controller: qtyController
                              ..text = widget.expenseEntryModel.quatity ?? "",
                            labelText: Strings.QUANTITY+"*",
                            readOnly: widget.readOnly,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                            isDense: true,
                            isColapsed: true,
                            focusNode: focusNode4,
                            nextFocusNode: focusNode5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextField(
                            controller: unitCostController
                              ..text = widget.expenseEntryModel.unitCosts ?? "",
                            labelText: Strings.UNIT_COSTS+"*",
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                            isDense: true,
                            isColapsed: true,
                            focusNode: focusNode5,
                            nextFocusNode: focusNode6,
                            readOnly: widget.readOnly,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DefaultTextField(
                            controller: totalController
                              ..text = widget.expenseEntryModel.total ?? "",
                            labelText: Strings.TOTAL+"*",
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                            isDense: true,
                            isColapsed: true,
                            focusNode: focusNode6,
                            nextFocusNode: focusNode7,
                            readOnly: widget.readOnly,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DefaultTextField(
                      controller: descController
                        ..text = widget.expenseEntryModel.desc ?? "",
                      labelText: Strings.DESCRIPTION+"*",
                      isDense: true,
                      isColapsed: true,
                      focusNode: focusNode7,
                      nextFocusNode: focusNode8,
                      readOnly: widget.readOnly,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DefaultTextField(
                      controller: poNumberController
                        ..text = widget.expenseEntryModel.poNumber ?? "",
                      labelText: Strings.PO_NUMBER+"*",
                      isDense: true,
                      isColapsed: true,
                      focusNode: focusNode8,
                      action: TextInputAction.done,
                      readOnly: widget.readOnly,
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
                              Strings.AUTHORIZED_BY+"*",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                            if (widget.expenseEntryModel.authorizedBy == null ||
                                (widget.expenseEntryModel.authorizedBy !=
                                        null &&
                                    widget.expenseEntryModel.authorizedBy!
                                        .isEmpty))
                              GestureDetector(
                                onTap: () {
                                  isDrawn = false;
                                  signaturePadKey.currentState!.clear();
                                  onContrillersChnaged(context);
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
                          child:
                              widget.expenseEntryModel.authorizedBy != null &&
                                      widget.expenseEntryModel.authorizedBy!
                                          .isNotEmpty
                                  ? Image.network(
                                      widget.expenseEntryModel.authorizedBy!,
                                    )
                                  : SfSignaturePad(
                                      key: signaturePadKey,
                                      minimumStrokeWidth: 1,
                                      maximumStrokeWidth: 3,
                                      strokeColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      onDrawEnd: () {
                                        isDrawn = true;
                                        onContrillersChnaged(context);
                                      },
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
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedHeading(
                    title: "Expense Entry #${widget.index + 1}",
                    widget: widget.readOnly
                        ? null
                        : InkWell(
                            onTap: () =>
                                BlocProvider.of<ExpenseEntriesCubit>(context)
                                    .removeExpense(widget.index),
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
