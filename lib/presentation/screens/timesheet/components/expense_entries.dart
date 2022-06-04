import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/data/models/shift.dart';
import 'package:hiftapp/data/models/view_timesheets/expense_entry_model.dart';
import 'package:hiftapp/data/models/view_timesheets/timesheet.dart';
import 'package:hiftapp/logic/expense_entries/expense_entries_cubit.dart';
import 'package:hiftapp/presentation/screens/timesheet/widgets/expense_entry.dart';
import '../../../../utils/assets.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';

class ExpenseEntriesPage extends StatelessWidget {
  final bool readOnly;
  final Shift? shift;
  final TimeSheet? timeSheet;

  ExpenseEntriesPage({
    Key? key,
    required this.readOnly,
    required this.shift,
    this.timeSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: BlocBuilder<ExpenseEntriesCubit, ExpenseEntriesState>(
        buildWhen: (previous, current) => current is ExpenseEntriesLoaded,
        builder: (context, state) {
          if (state is ExpenseEntriesLoaded) {
            List<Key> keys =
                List.generate(state.entries.length, (index) => Key("$index"));

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Strings.EXPENSE_ENTRIES.toUpperCase() +
                          " (${state.entries.length})",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (!readOnly)
                      InkWell(
                        onTap: () =>
                            BlocProvider.of<ExpenseEntriesCubit>(context)
                                .addExpense(
                          ExpenseEntryModel.fromMap(
                            {},
                          ),
                        ),
                        child: Image.asset(
                          Assets.ADD,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                if (state.entries.isEmpty && timeSheet == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'If you don\'t have any expense, click "Next"',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                for (int i = 0; i < state.entries.length; i++)
                  ExpenseEntry(
                    readOnly: readOnly,
                    key: keys[i],
                    expenseEntryModel: state.entries[i]!,
                    index: i,
                    shift: shift,
                    timeSheet: timeSheet,
                  )
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class ElevatedHeading extends StatelessWidget {
  final String title;
  final String? icon;
  final Widget? widget;

  const ElevatedHeading({
    Key? key,
    required this.title,
    this.widget,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
              if (widget != null) widget!
            ],
          ),
        ),
      ),
    );
  }
}
