import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsentState extends Equatable {
  final bool isAgreed;
  const ConsentState(this.isAgreed);
  @override
  List<Object?> get props => [isAgreed];
}

class ConsentCubit extends Cubit<ConsentState> {
  ConsentCubit() : super(const ConsentState(false));

  change(bool isAgreed) {
    emit(ConsentState(isAgreed));
  }
}
