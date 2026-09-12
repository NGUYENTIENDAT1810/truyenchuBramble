import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/book_repository.dart';

abstract class AuthorDetailState extends Equatable {
  const AuthorDetailState();

  @override
  List<Object?> get props => [];
}

class AuthorDetailInitial extends AuthorDetailState {
  const AuthorDetailInitial();
}

class AuthorDetailLoading extends AuthorDetailState {
  const AuthorDetailLoading();
}

class AuthorDetailLoaded extends AuthorDetailState {
  final Map<String, dynamic> authorData;
  final bool? isFollowedOverride;

  const AuthorDetailLoaded({
    required this.authorData,
    this.isFollowedOverride,
  });

  bool get isFollowed =>
      isFollowedOverride ?? (authorData['isFollowed'] as bool? ?? false);

  AuthorDetailLoaded copyWith({
    Map<String, dynamic>? authorData,
    bool? isFollowedOverride,
  }) {
    return AuthorDetailLoaded(
      authorData: authorData ?? this.authorData,
      isFollowedOverride: isFollowedOverride ?? this.isFollowedOverride,
    );
  }

  @override
  List<Object?> get props => [authorData, isFollowedOverride];
}

class AuthorDetailFailure extends AuthorDetailState {
  final String message;

  const AuthorDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthorDetailCubit extends Cubit<AuthorDetailState> {
  final BookRepository _bookRepository;

  AuthorDetailCubit({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(const AuthorDetailInitial());

  Future<void> loadAuthor(String authorId) async {
    emit(const AuthorDetailLoading());
    try {
      final authorData = await _bookRepository.getAuthorById(authorId);
      emit(AuthorDetailLoaded(authorData: authorData));
    } catch (e) {
      emit(AuthorDetailFailure(e.toString()));
    }
  }

  Future<void> toggleFollow(String authorId) async {
    final currentState = state;
    if (currentState is AuthorDetailLoaded) {
      final newFollowState = !currentState.isFollowed;
      emit(currentState.copyWith(isFollowedOverride: newFollowState));
      try {
        final serverState = await _bookRepository.toggleFollowAuthor(authorId);
        emit(currentState.copyWith(isFollowedOverride: serverState));
      } catch (_) {
        emit(currentState.copyWith(isFollowedOverride: currentState.isFollowed));
      }
    }
  }
}
