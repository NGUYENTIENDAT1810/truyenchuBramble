import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/reader_repository.dart';
import 'reader_event.dart';
import 'reader_state.dart';

export 'reader_event.dart';
export 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final ReaderRepository _readerRepository;

  ReaderBloc({required ReaderRepository readerRepository})
      : _readerRepository = readerRepository,
        super(const ReaderInitial()) {
    on<ReaderChapterRequested>(_onChapterRequested);
    on<ReaderChapterUnlocked>(_onChapterUnlocked);
  }

  Future<void> _onChapterRequested(
    ReaderChapterRequested event,
    Emitter<ReaderState> emit,
  ) async {
    emit(ReaderLoading(event.chapterId));
    try {
      final data = await _readerRepository.getChapterContent(event.chapterId);
      emit(ReaderLoaded(chapterId: event.chapterId, chapterData: data));
    } catch (e) {
      emit(ReaderFailure(chapterId: event.chapterId, message: e.toString()));
    }
  }

  Future<void> _onChapterUnlocked(
    ReaderChapterUnlocked event,
    Emitter<ReaderState> emit,
  ) async {
    emit(ReaderLoading(event.chapterId));
    try {
      final data = await _readerRepository.getChapterContent(event.chapterId);
      emit(ReaderLoaded(chapterId: event.chapterId, chapterData: data));
    } catch (e) {
      emit(ReaderFailure(chapterId: event.chapterId, message: e.toString()));
    }
  }
}
