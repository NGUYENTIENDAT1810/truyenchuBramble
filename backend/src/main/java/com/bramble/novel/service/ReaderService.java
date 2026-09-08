package com.bramble.novel.service;

import com.bramble.novel.dto.reader.ActiveReadingResponse;
import com.bramble.novel.dto.reader.ProgressRequest;
import com.bramble.novel.dto.reader.ProgressResponse;
import com.bramble.novel.entity.*;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.mapper.BookMapper;
import com.bramble.novel.mapper.ChapterMapper;
import com.bramble.novel.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReaderService {

    private final ReadingProgressRepository progressRepository;
    private final ReadingHistoryRepository historyRepository;
    private final ChapterRepository chapterRepository;
    private final BookRepository bookRepository;
    private final UserRepository userRepository;
    private final LibraryRepository libraryRepository;
    private final BookMapper bookMapper;
    private final ChapterMapper chapterMapper;

    @Transactional(readOnly = true)
    public ActiveReadingResponse getActiveReading(String userId) {
        Optional<ReadingProgress> progressOpt = progressRepository.findFirstByUserIdOrderByLastReadAtDesc(userId);
        if (progressOpt.isEmpty()) {
            return null;
        }

        ReadingProgress p = progressOpt.get();
        return ActiveReadingResponse.builder()
                .id(p.getId())
                .bookId(p.getBook().getId())
                .book(bookMapper.toBookResponse(p.getBook()))
                .chapterId(p.getChapter() != null ? p.getChapter().getId() : null)
                .chapter(p.getChapter() != null ? chapterMapper.toChapterResponse(p.getChapter(), true) : null)
                .chapterNumber(p.getChapter() != null ? p.getChapter().getChapterNumber() : null)
                .chapterTitle(p.getChapter() != null ? p.getChapter().getTitle() : null)
                .progressPercent(p.getProgressPercent())
                .scrollOffset(p.getScrollOffset())
                .readingTimeSeconds(p.getReadingTimeSeconds())
                .lastReadAt(p.getLastReadAt())
                .build();
    }

    @Transactional(readOnly = true)
    public ProgressResponse getProgressByBookId(String userId, String bookId) {
        ReadingProgress p = progressRepository.findByUserIdAndBookId(userId, bookId)
                .orElse(null);

        if (p == null) {
            return null;
        }

        return ProgressResponse.builder()
                .id(p.getId())
                .bookId(p.getBook().getId())
                .chapterId(p.getChapter() != null ? p.getChapter().getId() : null)
                .progressPercent(p.getProgressPercent())
                .scrollOffset(p.getScrollOffset())
                .readingTimeSeconds(p.getReadingTimeSeconds())
                .lastReadAt(p.getLastReadAt())
                .build();
    }

    @Transactional
    public ProgressResponse saveProgress(String userId, String bookId, ProgressRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));

        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book", "id", bookId));

        Chapter chapter = chapterRepository.findById(request.getChapterId())
                .orElseThrow(() -> new ResourceNotFoundException("Chapter", "id", request.getChapterId()));

        ReadingProgress progress = progressRepository.findByUserIdAndBookId(userId, bookId)
                .orElseGet(() -> ReadingProgress.builder()
                        .user(user)
                        .book(book)
                        .build());

        progress.setChapter(chapter);
        if (request.getProgressPercent() != null) progress.setProgressPercent(request.getProgressPercent());
        if (request.getScrollOffset() != null) progress.setScrollOffset(request.getScrollOffset());
        if (request.getReadingTimeSeconds() != null) {
            int current = progress.getReadingTimeSeconds() != null ? progress.getReadingTimeSeconds() : 0;
            progress.setReadingTimeSeconds(current + request.getReadingTimeSeconds());
        }
        progress.setLastReadAt(Instant.now());

        progress = progressRepository.save(progress);

        // Record history entry
        ReadingHistory history = ReadingHistory.builder()
                .user(user)
                .book(book)
                .chapter(chapter)
                .progressPercent(request.getProgressPercent() != null ? request.getProgressPercent() : 0)
                .scrollOffset(request.getScrollOffset() != null ? request.getScrollOffset() : 0.0)
                .readingTimeSeconds(request.getReadingTimeSeconds() != null ? request.getReadingTimeSeconds() : 0)
                .build();
        historyRepository.save(history);

        // Update library lastReadAt if present
        libraryRepository.findByUserIdAndBookId(userId, bookId).ifPresent(lib -> {
            lib.setLastReadAt(Instant.now());
            libraryRepository.save(lib);
        });

        return ProgressResponse.builder()
                .id(progress.getId())
                .bookId(book.getId())
                .chapterId(chapter.getId())
                .progressPercent(progress.getProgressPercent())
                .scrollOffset(progress.getScrollOffset())
                .readingTimeSeconds(progress.getReadingTimeSeconds())
                .lastReadAt(progress.getLastReadAt())
                .build();
    }
}
