import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LibraryStarted extends LibraryEvent {
  const LibraryStarted();
}

class LibraryTabChanged extends LibraryEvent {
  final String tab;

  const LibraryTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class LibraryRefreshed extends LibraryEvent {
  const LibraryRefreshed();
}
