import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  const CalendarState();
  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  final DateTime date;
  const CalendarLoaded({required this.date});

  @override
  List<Object> get props => [date];
}

class CalendarFailure extends CalendarState {
  final String message;

  const CalendarFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(DateTime dateTime) : super(const CalendarInitial()) {
    setDate(dateTime);
  }

  setDate(DateTime dateTime) {
    emit(const CalendarLoading());
    emit(CalendarLoaded(date: dateTime));
  }

  changeDate(DateTime dateTime, {int? year, int? month}) {
    emit(const CalendarLoading());
    emit(
      CalendarLoaded(
        date: DateTime.utc(
          year ?? dateTime.year,
          month ?? dateTime.month,
          dateTime.day,
        ),
      ),
    );
  }
}
