import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchStarted extends SearchState {
  final String searchText;
  const SearchStarted({
    required this.searchText,
  });
  @override
  List<Object?> get props => [searchText];
}

class SearchLoading extends SearchState {}

class SearchInitial extends SearchState {}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required String searchText})
      : super(
          SearchStarted(searchText: searchText),
        );

  onSearch(String searchText) {
    emit(SearchLoading());
    emit(
      SearchStarted(
        searchText: searchText,
      ),
    );
  }
}
