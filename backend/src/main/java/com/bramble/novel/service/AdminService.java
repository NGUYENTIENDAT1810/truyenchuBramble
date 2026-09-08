package com.bramble.novel.service;

import com.bramble.novel.dto.book.BookCreateRequest;
import com.bramble.novel.dto.book.BookResponse;
import com.bramble.novel.dto.chapter.ChapterCreateRequest;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.dto.chapter.ChapterUpdateRequest;
import com.bramble.novel.entity.*;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.mapper.BookMapper;
import com.bramble.novel.mapper.ChapterMapper;
import com.bramble.novel.repository.AuthorRepository;
import com.bramble.novel.repository.BookRepository;
import com.bramble.novel.repository.ChapterRepository;
import com.bramble.novel.repository.GenreRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminService {

    private final BookRepository bookRepository;
    private final ChapterRepository chapterRepository;
    private final AuthorRepository authorRepository;
    private final GenreRepository genreRepository;
    private final BookMapper bookMapper;
    private final ChapterMapper chapterMapper;

    @Transactional
    public BookResponse createBook(BookCreateRequest request) {
        Author author = null;
        if (request.getAuthorId() != null) {
            author = authorRepository.findById(request.getAuthorId())
                    .orElseThrow(() -> new ResourceNotFoundException("Author", "id", request.getAuthorId()));
        }

        Set<Genre> genres = new HashSet<>();
        if (request.getGenreIds() != null && !request.getGenreIds().isEmpty()) {
            genres.addAll(genreRepository.findAllById(request.getGenreIds()));
        }

        String slug = request.getTitle().toLowerCase().replaceAll("[^a-z0-9]+", "-").replaceAll("^-|-$", "");

        Book book = Book.builder()
                .title(request.getTitle())
                .slug(slug + "-" + System.currentTimeMillis() % 10000)
                .author(author)
                .coverUrl(request.getCoverUrl())
                .description(request.getDescription())
                .status(request.getStatus() != null ? BookStatus.valueOf(request.getStatus().toUpperCase()) : BookStatus.ONGOING)
                .isFeatured(request.getIsFeatured() != null ? request.getIsFeatured() : false)
                .isTrending(request.getIsTrending() != null ? request.getIsTrending() : false)
                .isNewRelease(request.getIsNewRelease() != null ? request.getIsNewRelease() : true)
                .genres(genres)
                .rating(5.0)
                .ratingsCount(1L)
                .viewsCount(0L)
                .totalChapters(0L)
                .build();

        book = bookRepository.save(book);
        return bookMapper.toBookResponse(book);
    }

    @Transactional
    public BookResponse updateBook(String bookId, BookCreateRequest request) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book", "id", bookId));

        if (request.getTitle() != null) book.setTitle(request.getTitle());
        if (request.getCoverUrl() != null) book.setCoverUrl(request.getCoverUrl());
        if (request.getDescription() != null) book.setDescription(request.getDescription());
        if (request.getStatus() != null) book.setStatus(BookStatus.valueOf(request.getStatus().toUpperCase()));
        if (request.getIsFeatured() != null) book.setIsFeatured(request.getIsFeatured());
        if (request.getIsTrending() != null) book.setIsTrending(request.getIsTrending());
        if (request.getIsNewRelease() != null) book.setIsNewRelease(request.getIsNewRelease());

        if (request.getAuthorId() != null) {
            Author author = authorRepository.findById(request.getAuthorId())
                    .orElseThrow(() -> new ResourceNotFoundException("Author", "id", request.getAuthorId()));
            book.setAuthor(author);
        }

        if (request.getGenreIds() != null) {
            Set<Genre> genres = new HashSet<>(genreRepository.findAllById(request.getGenreIds()));
            book.setGenres(genres);
        }

        book = bookRepository.save(book);
        return bookMapper.toBookResponse(book);
    }

    @Transactional
    public void deleteBook(String bookId) {
        bookRepository.deleteById(bookId);
    }

    @Transactional
    public ChapterResponse createChapter(String bookId, ChapterCreateRequest request) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book", "id", bookId));

        int words = request.getContent() != null ? request.getContent().split("\\s+").length : 0;

        Chapter chapter = Chapter.builder()
                .book(book)
                .chapterNumber(request.getChapterNumber())
                .title(request.getTitle())
                .content(request.getContent())
                .wordCount(words)
                .isFree(request.getIsFree() != null ? request.getIsFree() : true)
                .coinCost(request.getCoinCost() != null ? request.getCoinCost() : 0)
                .status(request.getStatus() != null ? ChapterStatus.valueOf(request.getStatus().toUpperCase()) : ChapterStatus.PUBLISHED)
                .commentsCount(0L)
                .build();

        chapter = chapterRepository.save(chapter);

        // Update book totalChapters
        book.setTotalChapters((book.getTotalChapters() != null ? book.getTotalChapters() : 0L) + 1);
        bookRepository.save(book);

        return chapterMapper.toChapterResponse(chapter, true);
    }

    @Transactional
    public ChapterResponse updateChapter(String chapterId, ChapterUpdateRequest request) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new ResourceNotFoundException("Chapter", "id", chapterId));

        if (request.getTitle() != null) chapter.setTitle(request.getTitle());
        if (request.getContent() != null) {
            chapter.setContent(request.getContent());
            chapter.setWordCount(request.getContent().split("\\s+").length);
        }
        if (request.getChapterNumber() != null) chapter.setChapterNumber(request.getChapterNumber());
        if (request.getIsFree() != null) chapter.setIsFree(request.getIsFree());
        if (request.getCoinCost() != null) chapter.setCoinCost(request.getCoinCost());
        if (request.getStatus() != null) chapter.setStatus(ChapterStatus.valueOf(request.getStatus().toUpperCase()));

        chapter = chapterRepository.save(chapter);
        return chapterMapper.toChapterResponse(chapter, true);
    }

    @Transactional
    public void deleteChapter(String chapterId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new ResourceNotFoundException("Chapter", "id", chapterId));
        Book book = chapter.getBook();
        chapterRepository.delete(chapter);

        if (book != null) {
            book.setTotalChapters(Math.max(0, (book.getTotalChapters() != null ? book.getTotalChapters() : 1) - 1));
            bookRepository.save(book);
        }
    }
}
