import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class DateRangeSelectorState extends Equatable {
  const DateRangeSelectorState();
  @override
  List<Object> get props => [];
}

class DateRangeSelectorInitial extends DateRangeSelectorState {
  const DateRangeSelectorInitial();
}

class DateRangeSelectorLoading extends DateRangeSelectorState {
  const DateRangeSelectorLoading();
}

class DateRangeSelectorLoaded extends DateRangeSelectorState {
  final DateTime fromDate;
  final DateTime tillDate;

  const DateRangeSelectorLoaded({
    required this.fromDate,
    required this.tillDate,
  });

  @override
  List<Object> get props => [fromDate, tillDate];
}

class DateRangeSelectorFailure extends DateRangeSelectorState {
  final String message;

  const DateRangeSelectorFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class DateRangeSelectorCubit extends Cubit<DateRangeSelectorState> {
  DateRangeSelectorCubit() : super(const DateRangeSelectorInitial()) {
    setDates(DateTime(2022), DateTime.now());
  }

  setDates(DateTime fromDate, DateTime tillDate) {
    emit(const DateRangeSelectorLoading());
    emit(DateRangeSelectorLoaded(fromDate: fromDate, tillDate: tillDate));
  }
}
