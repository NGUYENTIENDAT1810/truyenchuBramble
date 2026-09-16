import 'package:equatable/equatable.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object?> get props => [];
}

class ReaderChapterRequested extends ReaderEvent {
  final String chapterId;

  const ReaderChapterRequested(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}

class ReaderChapterUnlocked extends ReaderEvent {
  final String chapterId;

  const ReaderChapterUnlocked(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}
