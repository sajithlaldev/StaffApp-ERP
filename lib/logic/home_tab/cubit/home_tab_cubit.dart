import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/shift.dart';
import '../../../data/repositories/home_tab/home_tab_repository.dart';

class HomeTabState extends Equatable {
  const HomeTabState();

  @override
  List<Object> get props => [];
}

class HomeTabInitial extends HomeTabState {}

class HomeTabLoading extends HomeTabState {}

class HomeTabLoaded extends HomeTabState {
  final List<Shift>? todaysShifts;

  const HomeTabLoaded({
    this.todaysShifts,
  });

  @override
  List<Object> get props => [
        todaysShifts ?? "",
      ];
}

class HomeTabSuccess extends HomeTabState {}

class HomeTabFailure extends HomeTabState {
  final String error;
  const HomeTabFailure(this.error);

  @override
  List<Object> get props => [error];
}

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(HomeTabInitial()) {
    loadHomeTab();
  }

  loadHomeTab() async {
    HomeTabRepository().fetchShifts().listen(
      (event) {
        emit(
          HomeTabLoaded(todaysShifts: event),
        );
      },
    );
  }
}
