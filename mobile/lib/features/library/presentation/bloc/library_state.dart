import 'package:equatable/equatable.dart';
import '../../domain/library_item_model.dart';

abstract class LibraryState extends Equatable {
  final String currentTab;

  const LibraryState({this.currentTab = 'Reading'});

  @override
  List<Object?> get props => [currentTab];
}

class LibraryInitial extends LibraryState {
  const LibraryInitial({super.currentTab});
}

class LibraryLoading extends LibraryState {
  const LibraryLoading({required super.currentTab});
}

class LibraryLoaded extends LibraryState {
  final List<LibraryItemModel> items;

  const LibraryLoaded({
    required super.currentTab,
    required this.items,
  });

  @override
  List<Object?> get props => [currentTab, items];
}

class LibraryFailure extends LibraryState {
  final String message;

  const LibraryFailure({
    required super.currentTab,
    required this.message,
  });

  @override
  List<Object?> get props => [currentTab, message];
}
