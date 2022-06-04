import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class DateSelectorState extends Equatable {
  const DateSelectorState();
  @override
  List<Object> get props => [];
}

class DateSelectorInitial extends DateSelectorState {
  const DateSelectorInitial();
}

class DateSelectorLoading extends DateSelectorState {
  const DateSelectorLoading();
}

class DateSelectorLoaded extends DateSelectorState {
  final DateTime date;
  const DateSelectorLoaded({required this.date});

  @override
  List<Object> get props => [date];
}

class DateSelectorFailure extends DateSelectorState {
  final String message;

  const DateSelectorFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class DateSelectorCubit extends Cubit<DateSelectorState> {
  DateSelectorCubit() : super(const DateSelectorInitial()) {
    setDate(DateTime.now());
  }

  setDate(DateTime dateTime) {
    emit(const DateSelectorLoading());
    emit(DateSelectorLoaded(date: dateTime));
  }
}
