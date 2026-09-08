package com.bramble.novel.service;

import com.bramble.novel.dto.library.LibraryItemResponse;
import com.bramble.novel.dto.library.SaveBookRequest;
import com.bramble.novel.entity.Book;
import com.bramble.novel.entity.Library;
import com.bramble.novel.entity.LibraryStatus;
import com.bramble.novel.entity.ReadingProgress;
import com.bramble.novel.entity.User;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.mapper.BookMapper;
import com.bramble.novel.repository.BookRepository;
import com.bramble.novel.repository.LibraryRepository;
import com.bramble.novel.repository.ReadingProgressRepository;
import com.bramble.novel.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class LibraryService {

    private final LibraryRepository libraryRepository;
    private final BookRepository bookRepository;
    private final UserRepository userRepository;
    private final ReadingProgressRepository progressRepository;
    private final BookMapper bookMapper;

    @Transactional(readOnly = true)
    public List<LibraryItemResponse> getUserLibrary(String userId, String status) {
        List<Library> items;
        if (status != null && !status.trim().isEmpty()) {
            try {
                LibraryStatus libStatus = LibraryStatus.valueOf(status.trim().toUpperCase());
                items = libraryRepository.findByUserIdAndStatusOrderByUpdatedAtDesc(userId, libStatus);
            } catch (IllegalArgumentException e) {
                items = libraryRepository.findByUserIdOrderByUpdatedAtDesc(userId);
            }
        } else {
            items = libraryRepository.findByUserIdOrderByUpdatedAtDesc(userId);
        }

        return items.stream()
                .map(item -> {
                    Optional<ReadingProgress> progOpt = progressRepository.findByUserIdAndBookId(userId, item.getBook().getId());
                    Integer progressPercent = progOpt.map(ReadingProgress::getProgressPercent).orElse(0);
                    String lastChapterId = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getId() : null).orElse(null);
                    Integer lastChapterNum = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getChapterNumber() : null).orElse(null);
                    String lastChapterTitle = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getTitle() : null).orElse(null);

                    return LibraryItemResponse.builder()
                            .id(item.getId())
                            .bookId(item.getBook().getId())
                            .book(bookMapper.toBookResponse(item.getBook()))
                            .status(item.getStatus().name())
                            .progressPercent(progressPercent)
                            .lastReadChapterId(lastChapterId)
                            .lastReadChapterNumber(lastChapterNum)
                            .lastReadChapterTitle(lastChapterTitle)
                            .lastReadAt(item.getLastReadAt())
                            .createdAt(item.getCreatedAt())
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public LibraryItemResponse addToLibrary(String userId, SaveBookRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));

        Book book = bookRepository.findById(request.getBookId())
                .orElseThrow(() -> new ResourceNotFoundException("Book", "id", request.getBookId()));

        LibraryStatus status = LibraryStatus.CURRENT;
        if (request.getStatus() != null) {
            try {
                status = LibraryStatus.valueOf(request.getStatus().toUpperCase());
            } catch (IllegalArgumentException ignored) {}
        }

        LibraryStatus finalStatus = status;
        Library library = libraryRepository.findByUserIdAndBookId(userId, request.getBookId())
                .orElseGet(() -> Library.builder()
                        .user(user)
                        .book(book)
                        .status(finalStatus)
                        .build());

        library.setStatus(finalStatus);
        library = libraryRepository.save(library);

        Optional<ReadingProgress> progOpt = progressRepository.findByUserIdAndBookId(userId, book.getId());
        Integer progressPercent = progOpt.map(ReadingProgress::getProgressPercent).orElse(0);
        String lastChapterId = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getId() : null).orElse(null);
        Integer lastChapterNum = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getChapterNumber() : null).orElse(null);
        String lastChapterTitle = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getTitle() : null).orElse(null);

        return LibraryItemResponse.builder()
                .id(library.getId())
                .bookId(book.getId())
                .book(bookMapper.toBookResponse(book))
                .status(library.getStatus().name())
                .progressPercent(progressPercent)
                .lastReadChapterId(lastChapterId)
                .lastReadChapterNumber(lastChapterNum)
                .lastReadChapterTitle(lastChapterTitle)
                .lastReadAt(library.getLastReadAt())
                .createdAt(library.getCreatedAt())
                .build();
    }

    @Transactional
    public LibraryItemResponse updateStatus(String userId, String bookId, String statusStr) {
        Library library = libraryRepository.findByUserIdAndBookId(userId, bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Library entry not found for book: " + bookId));

        try {
            LibraryStatus status = LibraryStatus.valueOf(statusStr.toUpperCase());
            library.setStatus(status);
            library = libraryRepository.save(library);
        } catch (IllegalArgumentException e) {
            log.warn("Invalid library status: {}", statusStr);
        }

        Optional<ReadingProgress> progOpt = progressRepository.findByUserIdAndBookId(userId, bookId);
        Integer progressPercent = progOpt.map(ReadingProgress::getProgressPercent).orElse(0);
        String lastChapterId = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getId() : null).orElse(null);
        Integer lastChapterNum = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getChapterNumber() : null).orElse(null);
        String lastChapterTitle = progOpt.map(p -> p.getChapter() != null ? p.getChapter().getTitle() : null).orElse(null);

        return LibraryItemResponse.builder()
                .id(library.getId())
                .bookId(bookId)
                .book(bookMapper.toBookResponse(library.getBook()))
                .status(library.getStatus().name())
                .progressPercent(progressPercent)
                .lastReadChapterId(lastChapterId)
                .lastReadChapterNumber(lastChapterNum)
                .lastReadChapterTitle(lastChapterTitle)
                .lastReadAt(library.getLastReadAt())
                .createdAt(library.getCreatedAt())
                .build();
    }

    @Transactional
    public void removeFromLibrary(String userId, String bookId) {
        libraryRepository.deleteByUserIdAndBookId(userId, bookId);
    }
}
