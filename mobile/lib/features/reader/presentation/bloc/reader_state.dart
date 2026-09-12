import 'package:equatable/equatable.dart';
import '../../domain/chapter_detail_model.dart';

abstract class ReaderState extends Equatable {
  const ReaderState();

  @override
  List<Object?> get props => [];
}

class ReaderInitial extends ReaderState {
  const ReaderInitial();
}

class ReaderLoading extends ReaderState {
  final String chapterId;

  const ReaderLoading(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}

class ReaderLoaded extends ReaderState {
  final String chapterId;
  final ChapterDetailModel chapterData;

  const ReaderLoaded({
    required this.chapterId,
    required this.chapterData,
  });

  @override
  List<Object?> get props => [chapterId, chapterData];
}

class ReaderFailure extends ReaderState {
  final String chapterId;
  final String message;

  const ReaderFailure({
    required this.chapterId,
    required this.message,
  });

  @override
  List<Object?> get props => [chapterId, message];
}
