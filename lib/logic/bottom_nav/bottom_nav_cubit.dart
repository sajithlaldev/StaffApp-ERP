import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/service_provider.dart';

class BottomNavState extends Equatable {
  final int currentIndex;
  final ServiceProvider? provider;

  const BottomNavState({
    required this.currentIndex,
    this.provider,
  });
  @override
  List<Object?> get props => [currentIndex];
}

class BottomNavsCubit extends Cubit<BottomNavState> {
  BottomNavsCubit()
      : super(
          const BottomNavState(
            currentIndex: 0,
          ),
        );

  onBottomNavSwitch(int index, {ServiceProvider? provider}) {
    emit(
      BottomNavState(
        currentIndex: index,
        provider: provider,
      ),
    );
  }
}
