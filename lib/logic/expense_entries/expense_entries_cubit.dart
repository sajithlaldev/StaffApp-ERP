import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/data/models/view_timesheets/expense_entry_model.dart';

class ExpenseEntriesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ExpenseEntriesLoading extends ExpenseEntriesState {}

class ExpenseEntriesLoaded extends ExpenseEntriesState {
  final List<ExpenseEntryModel?> entries;

  ExpenseEntriesLoaded({
    required this.entries,
  });
  @override
  List<Object?> get props => [entries];
}

class ExpenseEntriesCubit extends Cubit<ExpenseEntriesState> {
  ExpenseEntriesCubit({required List<ExpenseEntryModel?> entries})
      : super(
          ExpenseEntriesLoaded(
            entries: entries,
          ),
        );

  addExpense(ExpenseEntryModel entry) {
    var entries = (state as ExpenseEntriesLoaded).entries;
    emit(ExpenseEntriesLoading());

    entries.add(entry);
    emit(
      ExpenseEntriesLoaded(entries: entries),
    );
  }

  onExpenseModelChanged(int index, ExpenseEntryModel entry) {
    var entries = (state as ExpenseEntriesLoaded).entries;
    entries[index] = entry;
    emit(
      ExpenseEntriesLoaded(entries: entries),
    );
  }

  removeExpense(int index) {
    var entries = (state as ExpenseEntriesLoaded).entries;
    emit(ExpenseEntriesLoading());

    entries.removeAt(index);
    emit(
      ExpenseEntriesLoaded(entries: entries),
    );
  }
}
