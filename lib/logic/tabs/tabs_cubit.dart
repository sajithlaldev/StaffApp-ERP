import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabState extends Equatable {
  final int currentIndex;
  const TabState({
    required this.currentIndex,
  });
  @override
  List<Object?> get props => [currentIndex];
}

class TabsCubit extends Cubit<TabState> {
  TabsCubit({int? index})
      : super(
          TabState(
            currentIndex: index ?? 0,
          ),
        );

  onTabSwitch(int index) {
    emit(
      TabState(
        currentIndex: index,
      ),
    );
  }
}
