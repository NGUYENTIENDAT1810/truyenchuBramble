import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/reader_repository.dart';
import 'reader_state.dart';

export 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  final ReaderRepository _readerRepository;

  ReaderCubit({required ReaderRepository readerRepository})
      : _readerRepository = readerRepository,
        super(const ReaderInitial());

  Future<void> chapterRequested(String chapterId) async {
    emit(ReaderLoading(chapterId));
    try {
      final data = await _readerRepository.getChapterContent(chapterId);
      emit(ReaderLoaded(chapterId: chapterId, chapterData: data));
    } catch (e) {
      emit(ReaderFailure(chapterId: chapterId, message: e.toString()));
    }
  }

  Future<void> chapterUnlocked(String chapterId) async {
    emit(ReaderLoading(chapterId));
    try {
      final data = await _readerRepository.getChapterContent(chapterId);
      emit(ReaderLoaded(chapterId: chapterId, chapterData: data));
    } catch (e) {
      emit(ReaderFailure(chapterId: chapterId, message: e.toString()));
    }
  }
}
