import 'package:equatable/equatable.dart';
import '../../../books/domain/book_detail_model.dart';

class DiscoverState extends Equatable {
  final String query;
  final String selectedTag;
  final List<String> tags;
  final List<BookModel> books;
  final bool isLoading;
  final String? errorMessage;

  const DiscoverState({
    this.query = '',
    this.selectedTag = 'All',
    this.tags = const [
      'All',
      'Slow fantasy',
      'Progression',
      'Literary',
      'Court intrigue',
      'Epistolary',
      'Slipstream',
    ],
    this.books = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  DiscoverState copyWith({
    String? query,
    String? selectedTag,
    List<String>? tags,
    List<BookModel>? books,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DiscoverState(
      query: query ?? this.query,
      selectedTag: selectedTag ?? this.selectedTag,
      tags: tags ?? this.tags,
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        query,
        selectedTag,
        tags,
        books,
        isLoading,
        errorMessage,
      ];
}
