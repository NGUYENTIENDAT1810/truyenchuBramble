import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/book_repository.dart';
import '../../domain/book_detail_model.dart';
import '../../domain/chapter_model.dart';

abstract class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object?> get props => [];
}

class BookDetailInitial extends BookDetailState {
  const BookDetailInitial();
}

class BookDetailLoading extends BookDetailState {
  const BookDetailLoading();
}

class BookDetailLoaded extends BookDetailState {
  final BookModel book;
  final List<ChapterModel> chapters;
  final bool? isSavedOverride;

  const BookDetailLoaded({
    required this.book,
    required this.chapters,
    this.isSavedOverride,
  });

  bool get isSaved => isSavedOverride ?? book.isSaved;

  BookDetailLoaded copyWith({
    BookModel? book,
    List<ChapterModel>? chapters,
    bool? isSavedOverride,
  }) {
    return BookDetailLoaded(
      book: book ?? this.book,
      chapters: chapters ?? this.chapters,
      isSavedOverride: isSavedOverride ?? this.isSavedOverride,
    );
  }

  @override
  List<Object?> get props => [book, chapters, isSavedOverride];
}

class BookDetailFailure extends BookDetailState {
  final String message;

  const BookDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class BookDetailCubit extends Cubit<BookDetailState> {
  final BookRepository _bookRepository;

  BookDetailCubit({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(const BookDetailInitial());

  Future<void> loadBook(String bookId) async {
    emit(const BookDetailLoading());
    try {
      final bookFuture = _bookRepository.getBookById(bookId);
      final chaptersFuture = _bookRepository.getChaptersByBookId(bookId);
      final results = await Future.wait([bookFuture, chaptersFuture]);

      final book = results[0] as BookModel;
      final chapters = results[1] as List<ChapterModel>;

      emit(BookDetailLoaded(book: book, chapters: chapters));
    } catch (e) {
      emit(BookDetailFailure(e.toString()));
    }
  }

  Future<void> toggleSave(String bookId) async {
    final currentState = state;
    if (currentState is BookDetailLoaded) {
      final newSaveState = !currentState.isSaved;
      emit(currentState.copyWith(isSavedOverride: newSaveState));
      try {
        final serverState = await _bookRepository.toggleSaveBook(bookId);
        emit(currentState.copyWith(isSavedOverride: serverState));
      } catch (_) {
        // revert on error
        emit(currentState.copyWith(isSavedOverride: currentState.isSaved));
      }
    }
  }
}
