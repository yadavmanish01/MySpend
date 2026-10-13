import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class FetchActivityEvent extends ActivityEvent {
  const FetchActivityEvent();
}

class FilterChangedEvent extends ActivityEvent {
  final int filterIndex;
  const FilterChangedEvent(this.filterIndex);

  @override
  List<Object?> get props => [filterIndex];
}

class SearchQueryChangedEvent extends ActivityEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}
