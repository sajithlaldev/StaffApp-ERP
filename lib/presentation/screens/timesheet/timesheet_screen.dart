import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hiftapp/logic/expense_entries/expense_entries_cubit.dart';
import 'package:hiftapp/logic/timesheet/timesheet_cubit.dart';
import '../../../data/models/shift.dart';
import '../../../data/models/view_timesheets/signatures.dart';
import '../../common/default_textfield.dart';
import 'components/expense_entries.dart';
import 'components/shift_entries.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../../data/models/view_timesheets/client_auth_model.dart';
import '../../../data/models/view_timesheets/shift_entry_model.dart';
import '../../../data/models/view_timesheets/staff_section_model.dart';
import '../../../data/models/view_timesheets/timesheet.dart';
import '../../../logic/add_timesheet/cubit/add_timesheet_cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/routes.dart';
import '../../common/default_cofirmation_popup.dart';
import 'components/appbar.dart';
import 'components/client_authorization.dart';
import 'widgets/dot_widget.dart';

class TimeSheetScreen extends StatefulWidget {
  final Shift? shift;
  final String? shiftId;

  TimeSheetScreen({
    Key? key,
    this.shift,
    this.shiftId,
  }) : super(key: key);

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  final GlobalKey<SfSignaturePadState> _shiftSignaturePadKey = GlobalKey();

  final GlobalKey<SfSignaturePadState> _clientAuthSignaturePadKey = GlobalKey();

  final GlobalKey<SfSignaturePadState> _agencyWorkerSignaturePadKey =
      GlobalKey();

  final TextEditingController _shiftSignatureController =
      TextEditingController();

  final TextEditingController _clientAuthSignatureController =
      TextEditingController();

  final TextEditingController _agencyWorkerSignatureController =
      TextEditingController();

  final candidateNameController = TextEditingController();

  final candidateRefController = TextEditingController();

  final invoiceClientRefController = TextEditingController();

  final orgNameController = TextEditingController();

  final clientNameController = TextEditingController();

  final postCodeController = TextEditingController();

  final wardController = TextEditingController();

  final clientRefController = TextEditingController();

  final ourRefController = TextEditingController();

  final poNumberController = TextEditingController();

  final jobTitleController = TextEditingController();

  final clientName2Controller = TextEditingController();

  final thtpController = TextEditingController();

  final positionHoldController = TextEditingController();

  final clientDateController = TextEditingController();

  final tetpController = TextEditingController();

  final shiftDayController = TextEditingController();

  final shiftDateController = TextEditingController();

  final shiftBillableHoursController = TextEditingController();

  final shiftFromController = TextEditingController();

  final shiftTillController = TextEditingController();

  final shiftShiftRefController = TextEditingController();

  final shiftBreakController = TextEditingController();

  final expenseDayController = TextEditingController();

  final expenseDateController = TextEditingController();

  final expenseTypeController = TextEditingController();

  final expenseDescController = TextEditingController();

  final expenseQtyController = TextEditingController();

  final expensePoNumberController = TextEditingController();

  final expenseUnitCostController = TextEditingController();

  final expenseTotalController = TextEditingController();

  final _selectedIndex = ValueNotifier(0);

  addTimeSheet(
    BuildContext context,
  ) async {
    final providerDetails = widget.shift!.provider;
    final staffDetails = widget.shift!.staff;

    TimeSheet timeSheetModel = TimeSheet(
      agencyWorkerSignature: '',
      id: '',
      shift_id: widget.shift?.id,
      clientAuthModel: ClientAuthModel(
        name: clientName2Controller.text,
        thtp: thtpController.text,
        positionHold: positionHoldController.text,
        date: clientDateController.text,
        tetp: tetpController.text,
        signature: "",
      ),
      created_on: DateTime.now().toString(),
      customer: widget.shift?.customer,
      customerName: widget.shift?.customer!.name,
      expenseEntries:
          (context.read<ExpenseEntriesCubit>().state as ExpenseEntriesLoaded)
              .entries,
      shiftEntry: ShiftEntryModel(
        authorizedBy: "",
        billableHours: shiftBillableHoursController.text,
        breakTime: shiftBreakController.text,
        date: shiftDateController.text,
        day: shiftDayController.text,
        from: shiftFromController.text,
        shiftRef: shiftShiftRefController.text,
        till: shiftTillController.text,
      ),
      staffSectionModel: StaffSectionModel(
        candidateName: candidateNameController.text,
        candidateReference: candidateRefController.text,
        clientName: clientNameController.text,
        clientReference: clientRefController.text,
        invoiceClientReference: invoiceClientRefController.text,
        jobTitle: jobTitleController.text,
        orgName: orgNameController.text,
        ourReference: ourRefController.text,
        poNumber: poNumberController.text,
        postcode: postCodeController.text,
        ward: wardController.text,
      ),
      timesheet_number: Utils.generateRandomNumber().toString(),
      providerId: providerDetails.email,
      staffId: staffDetails!.email,
      provider: providerDetails,
      staff: staffDetails,
      providerName: providerDetails.name,
      staffName: staffDetails.name,
    );

    Signatures singatures = Signatures(
      agencyWorkerSign: _agencyWorkerSignatureController.text.isEmpty
          ? null
          : await _agencyWorkerSignaturePadKey.currentState!.toImage(),
      clientAuthSign: _clientAuthSignatureController.text.isEmpty
          ? null
          : await _clientAuthSignaturePadKey.currentState!.toImage(),
      shiftSign: _shiftSignatureController.text.isEmpty
          ? null
          : await _shiftSignaturePadKey.currentState!.toImage(),
    );

    log(_clientAuthSignatureController.text.toString());

    BlocProvider.of<AddTimeSheetCubit>(context).addTimesheet(
      timeSheet: timeSheetModel,
      isAdd: true,
      signatures: singatures,
    );
  }

  showFinishPopup(BuildContext sdcontext) async {
    var res = await showDialog(
      context: sdcontext,
      builder: (context) => BlocProvider.value(
        value: sdcontext.read<ExpenseEntriesCubit>(),
        child: BlocProvider(
          create: (context) => AddTimeSheetCubit(),
          child: BlocConsumer<AddTimeSheetCubit, AddTimeSheetState>(
            listener: (context, state) {
              if (state is AddTimeSheetSuccess) {
                Utils.showSnackBar(context, "Timesheet has been submitted");
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.HOME, (route) => false);
              } else if (state is AddTimeSheetFailure) {
                Navigator.pop(context);
                Utils.showSnackBar(context, state.error);
              }
            },
            builder: (context, state) {
              return DefaultConfirmationPopup(
                title: Strings.SUBMIT_TIMESHEET,
                caption: Strings.SUBMIT_TIMESHEET_CAPTION,
                yesText: Strings.SUBMIT_TIMESHEET,
                isLoading: state is AddTimeSheetLoading,
                yesFunction: () {
                  if (DateTime.now().isAfter(DateFormat("yyyy-MM-dd HH:mm")
                      .parse(widget.shift!.till))) {
                    addTimeSheet(context);
                  } else {
                    Utils.showSnackBar(context, "Shift time is not over");
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final double appBarHeight = 48;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimesheetCubit(
            shiftId: widget.shiftId ?? widget.shift!.id!,
          ),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBarWidget(),
        ),
        backgroundColor: AppColors.accent,
        body: SafeArea(
          child: SizedBox(
            height: _size.height - appBarHeight,
            child: BlocConsumer<TimesheetCubit, TimesheetState>(
              listener: (context, state) {
                if (state is TimesheetLoaded) {
                  candidateRefController.text =
                      state.timesheet?.staffSectionModel?.candidateReference ??
                          "";
                  candidateNameController.text = widget.shift?.staff?.name ??
                      state.timesheet?.staffSectionModel?.candidateName ??
                      "";
                  invoiceClientRefController.text = state.timesheet
                          ?.staffSectionModel?.invoiceClientReference ??
                      "";
                  orgNameController.text = widget.shift?.provider.name ??
                      state.timesheet?.staffSectionModel?.orgName ??
                      "";
                  clientNameController.text =
                      widget.shift?.customer?.name ?? "";
                  postCodeController.text = widget.shift?.customer?.post_code ??
                      state.timesheet?.staffSectionModel?.postcode ??
                      "";

                  wardController.text =
                      state.timesheet?.staffSectionModel?.ward ?? "";
                  clientRefController.text =
                      state.timesheet?.staffSectionModel?.clientReference ?? "";
                  ourRefController.text = widget.shift?.confirmation_number ??
                      state.timesheet?.staffSectionModel?.ourReference ??
                      "";
                  poNumberController.text =
                      state.timesheet?.staffSectionModel?.poNumber ?? "";
                  jobTitleController.text = widget.shift?.type ??
                      state.timesheet?.staffSectionModel?.jobTitle ??
                      "";

                  //shift entries fields
                  shiftDayController.text = Utils.getDayOfWeekFromDate(
                      widget.shift?.from ?? state.timesheet!.shiftEntry!.date!);
                  shiftFromController.text = widget.shift == null
                      ? state.timesheet?.shiftEntry?.from ?? ""
                      : Utils.formatTimeOnly(widget.shift!.from);
                  shiftTillController.text = widget.shift == null
                      ? state.timesheet?.shiftEntry?.till ?? ""
                      : Utils.formatTimeOnly(widget.shift!.till);
                  shiftDateController.text = widget.shift == null
                      ? state.timesheet?.shiftEntry?.date! ?? ""
                      : Utils.formatDateOnly(widget.shift!.from);
                  shiftBreakController.text = widget.shift == null
                      ? state.timesheet?.shiftEntry?.breakTime ?? ""
                      : widget.shift!.break_time;
                  shiftBillableHoursController.text = widget.shift == null
                      ? state.timesheet?.shiftEntry?.billableHours ?? ""
                      : widget.shift?.duration ?? "";

                  shiftShiftRefController.text =
                      widget.shift?.confirmation_number ??
                          state.timesheet?.shiftEntry?.shiftRef ??
                          "";

                  //client auth
                  clientName2Controller.text = widget.shift?.customer?.name ??
                      state.timesheet?.clientAuthModel?.name ??
                      "";
                  thtpController.text =
                      state.timesheet?.clientAuthModel?.thtp ?? "";
                  positionHoldController.text =
                      state.timesheet?.clientAuthModel?.positionHold ?? "";
                  clientDateController.text =
                      state.timesheet?.clientAuthModel?.date ??
                          DateFormat("dd-MM-yyyy").format(DateTime.now());
                  tetpController.text =
                      state.timesheet?.clientAuthModel?.tetp ?? "";
                }
              },
              builder: (context, state) {
                if (state is TimesheetLoaded) {
                  pages = [
                    OverviewPage(
                      candidateNameController: candidateNameController,
                      candidateRefController: candidateRefController,
                      invoiceClientRefController: invoiceClientRefController,
                      orgNameController: orgNameController,
                      clientNameController: clientNameController,
                      postCodeController: postCodeController,
                      wardController: wardController,
                      clientRefController: clientRefController,
                      ourRefController: ourRefController,
                      poNumberController: poNumberController,
                      jobTitleController: jobTitleController,
                      readOnly: state.timesheet != null,
                    ),
                    ShiftEntriesPage(
                      signatureController: _shiftSignatureController,
                      dayController: shiftDayController,
                      fromController: shiftFromController,
                      tillController: shiftTillController,
                      dateController: shiftDateController,
                      breakController: shiftBreakController,
                      billableHoursController: shiftBillableHoursController,
                      shftRefController: shiftShiftRefController,
                      signaturePadKey: _shiftSignaturePadKey,
                      readOnly: state.timesheet != null,
                      signature: state.timesheet?.shiftEntry?.authorizedBy,
                    ),
                    ExpenseEntriesPage(
                      readOnly: state.timesheet != null,
                      shift: widget.shift,
                      timeSheet: state.timesheet,
                    ),
                    ClientAuthorization(
                      isClientSignDrawnController:
                          _clientAuthSignatureController,
                      isWorkerSignDrawnController:
                          _agencyWorkerSignatureController,
                      nameController: clientName2Controller,
                      thtpController: thtpController,
                      positionHoldController: positionHoldController,
                      dateController: clientDateController,
                      tetpController: tetpController,
                      clientSignatureKey: _clientAuthSignaturePadKey,
                      agencySignatureKey: _agencyWorkerSignaturePadKey,
                      readOnly: state.timesheet != null,
                      clientSignature:
                          state.timesheet?.clientAuthModel?.signature,
                      workerSignature: state.timesheet?.agencyWorkerSignature,
                    ),
                  ];
                }

                return BlocProvider(
                  create: (context) => ExpenseEntriesCubit(
                      entries: state is TimesheetLoaded
                          ? state.timesheet?.expenseEntries ?? []
                          : []),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < 4; i++)
                                GestureDetector(
                                  onTap: () {
                                    _selectedIndex.value = i;
                                  },
                                  child: ValueListenableBuilder(
                                    valueListenable: _selectedIndex,
                                    builder: (context, value, child) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12),
                                        child: DotWidget(
                                          isSelected: value! as int <= i - 1
                                              ? false
                                              : true,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: _size.height -
                              appBarHeight -
                              (_size.height > 750
                                  ? _size.height * 0.17
                                  : _size.height * 0.13),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                left: 10,
                                right: 10,
                                bottom: 50,
                                child: ValueListenableBuilder(
                                  valueListenable: _selectedIndex,
                                  builder: (context, value, child) {
                                    return IndexedStack(
                                      children: pages,
                                      index: value as int,
                                      sizing: StackFit.expand,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: ValueListenableBuilder(
                                  valueListenable: _selectedIndex,
                                  builder: (context, value, child) {
                                    return Container(
                                      color: AppColors.accent,
                                      height: 50,
                                      width: _size.width,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          value != 0
                                              ? InkWell(
                                                  onTap: () {
                                                    _selectedIndex.value =
                                                        (value! as int) - 1;
                                                  },
                                                  child: SizedBox(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .keyboard_arrow_left,
                                                          size: 20,
                                                          color: AppColors
                                                              .iconColor,
                                                        ),
                                                        Text(
                                                          Strings.PREVIOUS,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              if (value == 3) {
                                                if (widget.shift != null &&
                                                    (state is TimesheetLoaded &&
                                                        state.timesheet ==
                                                            null)) {
                                                  showFinishPopup(context);
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              } else {
                                                _selectedIndex.value =
                                                    (value! as int) + 1;
                                              }
                                            },
                                            child: SizedBox(
                                              height: 20,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  value == 3
                                                      ? Text(
                                                          Strings.FINISH,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        )
                                                      : Text(
                                                          Strings.NEXT,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        ),
                                                  const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    size: 20,
                                                    color: AppColors.iconColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  final bool readOnly;
  OverviewPage({
    Key? key,
    required this.candidateNameController,
    required this.candidateRefController,
    required this.invoiceClientRefController,
    required this.orgNameController,
    required this.clientNameController,
    required this.postCodeController,
    required this.wardController,
    required this.clientRefController,
    required this.ourRefController,
    required this.poNumberController,
    required this.jobTitleController,
    required this.readOnly,
  }) : super(key: key);

  final TextEditingController candidateNameController;
  final TextEditingController candidateRefController;
  final TextEditingController invoiceClientRefController;
  final TextEditingController orgNameController;
  final TextEditingController clientNameController;
  final TextEditingController postCodeController;
  final TextEditingController wardController;
  final TextEditingController clientRefController;
  final TextEditingController ourRefController;
  final TextEditingController poNumberController;
  final TextEditingController jobTitleController;

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();
  final focusNode7 = FocusNode();
  final focusNode8 = FocusNode();
  final focusNode9 = FocusNode();
  final focusNode10 = FocusNode();
  final focusNode11 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextField(
            controller: candidateNameController,
            labelText: Strings.CANDIDATE_NAME + "*",
            isDense: true,
            action: TextInputAction.next,
            focusNode: focusNode1,
            nextFocusNode: focusNode2,
            readOnly: true,
          ),
          DefaultTextField(
            controller: candidateRefController,
            labelText: Strings.CANDIDATE_REFERENCE,
            focusNode: focusNode2,
            nextFocusNode: focusNode3,
            isDense: true,
            readOnly: readOnly,
          ),
          DefaultTextField(
            controller: invoiceClientRefController,
            labelText: Strings.INVOICE_CLIENT_REFERENCE,
            isDense: true,
            focusNode: focusNode3,
            nextFocusNode: focusNode6,
            readOnly: readOnly,
          ),
          DefaultTextField(
            controller: orgNameController,
            labelText: Strings.ORG_NAME + "*",
            isDense: true,
            focusNode: focusNode4,
            nextFocusNode: focusNode5,
            readOnly: true,
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextField(
                  controller: postCodeController,
                  labelText: Strings.POST_CODE,
                  isDense: true,
                  focusNode: focusNode5,
                  nextFocusNode: focusNode6,
                  readOnly: true,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: DefaultTextField(
                  controller: wardController,
                  labelText: Strings.WARD_UNIT,
                  focusNode: focusNode6,
                  nextFocusNode: focusNode7,
                  readOnly: readOnly,
                  isDense: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextField(
                  controller: clientRefController,
                  labelText: Strings.CLIENT_REFERENCE,
                  isDense: true,
                  focusNode: focusNode7,
                  nextFocusNode: focusNode9,
                  readOnly: readOnly,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: DefaultTextField(
                  controller: ourRefController,
                  labelText: Strings.OUR_REFERENCE,
                  focusNode: focusNode8,
                  nextFocusNode: focusNode9,
                  isDense: true,
                  readOnly: true,
                ),
              ),
            ],
          ),
          DefaultTextField(
            controller: poNumberController,
            labelText: Strings.PO_NUMBER,
            focusNode: focusNode9,
            isDense: true,
            action: TextInputAction.done,
            readOnly: readOnly,
          ),
          DefaultTextField(
            controller: jobTitleController,
            labelText: Strings.JOB_TITLE + "*",
            focusNode: focusNode10,
            isDense: true,
            readOnly: true,
          )
        ],
      ),
    );
  }
}
