import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/faq.dart';
import '../../data/repositories/common/common_repositories.dart';


class FaqState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqLoaded extends FaqState {
  final List<FaqModel> faqs;

  FaqLoaded({
    required this.faqs,
  });
  @override
  List<Object?> get props => [faqs];
}

class FaqFailure extends FaqState {
  final String error;
  FaqFailure({
    required this.error,
  });
  @override
  List<Object?> get props => [
        error,
      ];
}

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqInitial()) {
    init();
  }

  init() async {
    emit(FaqLoading());
    try {
      List<FaqModel> allFaq = await CommonRepository().loadFaqs();

      emit(
        FaqLoaded(
          faqs: allFaq,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(
        FaqFailure(
          error: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
