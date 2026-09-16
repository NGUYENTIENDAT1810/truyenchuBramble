import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverStarted extends DiscoverEvent {
  const DiscoverStarted();
}

class DiscoverQueryChanged extends DiscoverEvent {
  final String query;

  const DiscoverQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class DiscoverTagSelected extends DiscoverEvent {
  final String tag;

  const DiscoverTagSelected(this.tag);

  @override
  List<Object?> get props => [tag];
}

class DiscoverRefreshed extends DiscoverEvent {
  const DiscoverRefreshed();
}
