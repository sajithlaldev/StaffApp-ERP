import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/common/common_repositories.dart';
import '../../../utils/constants.dart';
import '../../../utils/strings.dart';

class FilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnFilter extends FilterState {
  final List<String?> filters;
  late List<List<String>> filterLists;
  OnFilter({
    required this.filters,
    required this.filterLists,
  });
  @override
  List<Object?> get props => [
        filters,
      ];
}

class OnFilterLoading extends FilterState {}

class FilterCubit extends Cubit<FilterState> {
  late int filterCount;
  FilterCubit() : super(OnFilterLoading());
  init(
    int filtersCount,
    List<String> neededfilters,
  ) async {
    filterCount = filtersCount;
    List<List<String>> filters = [];

    if (state is OnFilter) {
      (state as OnFilter).filters.clear();
    }

    Map<String, List<String>> temp = {};

    if (neededfilters.contains("locations") ||
        neededfilters.contains("types") ||
        neededfilters.contains("service_providers")) {
      //fetching locations and types
      Map<String, List<String>> locationAndTypes =
          await CommonRepository().getProviders();

      if (neededfilters.contains("types")) {
        temp['types'] = locationAndTypes['types']!;
      }
      if (neededfilters.contains("service_providers")) {
        temp['service_providers'] = locationAndTypes['service_providers']!;
      }
      if (neededfilters.contains("locations")) {
        temp['locations'] = locationAndTypes['locations']!;
      }
    }

    if (neededfilters.contains("staffs")) {
      //fetching staffs
      Map<String, List<String>> staffs = await CommonRepository().getStaffs();
      temp['staffs'] = staffs['staffs']!;
    }
    print("NEEDED FILTERS : ${neededfilters.length}");

    //sorting according to neededFilter
    for (int i = 0; i < neededfilters.length; i++) {
      if (neededfilters[i] == "types") {
        filters.add(temp['types']!);
      } else if (neededfilters[i] == "service_providers") {
        filters.add(temp['service_providers']!);
      } else if (neededfilters[i] == "staffs") {
        filters.add(temp['staffs']!);
      } else if (neededfilters[i] == "locations") {
        filters.add(temp['locations']!);
      } else if (neededfilters[i] == "hot_shift") {
        filters.add(
          [
            Strings.HOT_SHIFT,
          ],
        );
      }
    }

    emit(
      OnFilter(
        filters: List.generate(filtersCount, (index) => null),
        filterLists: filters,
      ),
    );
  }

  onFilter(List<String?> selectedFilterItem) {
    List<List<String>> filters =
        state is OnFilter ? (state as OnFilter).filterLists : [];
    emit(OnFilterLoading());
    emit(
      OnFilter(
        filters: selectedFilterItem,
        filterLists: filters,
      ),
    );
  }

  clearSelectedFilters() {
    List<List<String>> filters =
        state is OnFilter ? (state as OnFilter).filterLists : [];
    emit(OnFilterLoading());
    emit(
      OnFilter(
        filters: List.generate(filterCount, (index) => null),
        filterLists: filters,
      ),
    );
    print(filters);
  }
}
