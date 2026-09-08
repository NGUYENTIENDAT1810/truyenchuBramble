package com.bramble.novel.service;

import com.bramble.novel.dto.book.*;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.dto.common.PageResponse;
import com.bramble.novel.entity.*;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.mapper.AuthorMapper;
import com.bramble.novel.mapper.BookMapper;
import com.bramble.novel.mapper.ChapterMapper;
import com.bramble.novel.mapper.GenreMapper;
import com.bramble.novel.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;
    private final ChapterRepository chapterRepository;
    private final AuthorRepository authorRepository;
    private final GenreRepository genreRepository;
    private final LibraryRepository libraryRepository;
    private final ReadingProgressRepository readingProgressRepository;
    private final BookMapper bookMapper;
    private final ChapterMapper chapterMapper;
    private final AuthorMapper authorMapper;
    private final GenreMapper genreMapper;

    @Transactional(readOnly = true)
    public PageResponse<BookResponse> getAllBooks(
            String search,
            String genreSlug,
            String status,
            String sortBy,
            int page,
            int limit
    ) {
        Sort sort = Sort.by(Sort.Direction.DESC, "createdAt");
        if ("popular".equalsIgnoreCase(sortBy) || "views".equalsIgnoreCase(sortBy)) {
            sort = Sort.by(Sort.Direction.DESC, "viewsCount");
        } else if ("rating".equalsIgnoreCase(sortBy)) {
            sort = Sort.by(Sort.Direction.DESC, "rating");
        } else if ("title".equalsIgnoreCase(sortBy)) {
            sort = Sort.by(Sort.Direction.ASC, "title");
        }

        Pageable pageable = PageRequest.of(page > 0 ? page - 1 : 0, limit > 0 ? limit : 20, sort);

        Page<Book> bookPage;
        if (search != null && !search.trim().isEmpty()) {
            bookPage = bookRepository.searchBooks(search.trim(), pageable);
        } else if (genreSlug != null && !genreSlug.trim().isEmpty()) {
            bookPage = bookRepository.findByGenreSlug(genreSlug.trim(), pageable);
        } else if (status != null && !status.trim().isEmpty()) {
            try {
                BookStatus bookStatus = BookStatus.valueOf(status.trim().toUpperCase());
                bookPage = bookRepository.findByStatus(bookStatus, pageable);
            } catch (IllegalArgumentException e) {
                bookPage = bookRepository.findAll(pageable);
            }
        } else {
            bookPage = bookRepository.findAll(pageable);
        }

        List<BookResponse> items = bookPage.getContent().stream()
                .map(bookMapper::toBookResponse)
                .collect(Collectors.toList());

        return PageResponse.<BookResponse>builder()
                .items(items)
                .page(page > 0 ? page : 1)
                .limit(limit > 0 ? limit : 20)
                .totalElements(bookPage.getTotalElements())
                .totalPages(bookPage.getTotalPages())
                .hasNext(bookPage.hasNext())
                .hasPrev(bookPage.hasPrevious())
                .build();
    }

    @Transactional
    public BookDetailResponse getBookDetail(String bookId, String userId) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book", "id", bookId));

        // Increment views count
        book.setViewsCount((book.getViewsCount() != null ? book.getViewsCount() : 0L) + 1);
        bookRepository.save(book);

        boolean inLibrary = false;
        String libraryStatus = null;
        Integer progressPercent = 0;
        String lastReadChapterId = null;
        Integer lastReadChapterNumber = null;
        String lastReadChapterTitle = null;

        if (userId != null) {
            Optional<Library> libOpt = libraryRepository.findByUserIdAndBookId(userId, bookId);
            if (libOpt.isPresent()) {
                inLibrary = true;
                libraryStatus = libOpt.get().getStatus().name();
            }

            Optional<ReadingProgress> progOpt = readingProgressRepository.findByUserIdAndBookId(userId, bookId);
            if (progOpt.isPresent()) {
                ReadingProgress prog = progOpt.get();
                progressPercent = prog.getProgressPercent();
                if (prog.getChapter() != null) {
                    lastReadChapterId = prog.getChapter().getId();
                    lastReadChapterNumber = prog.getChapter().getChapterNumber();
                    lastReadChapterTitle = prog.getChapter().getTitle();
                }
            }
        }

        // Fetch recent/preview chapters (first 5)
        List<Chapter> chapters = chapterRepository.findByBookIdOrderByChapterNumberAsc(bookId);
        List<ChapterResponse> recentChapters = chapters.stream()
                .limit(5)
                .map(c -> chapterMapper.toChapterResponse(c, c.getIsFree()))
                .collect(Collectors.toList());

        return bookMapper.toBookDetailResponse(
                book,
                inLibrary,
                libraryStatus,
                progressPercent,
                lastReadChapterId,
                lastReadChapterNumber,
                lastReadChapterTitle,
                recentChapters
        );
    }

    @Transactional(readOnly = true)
    public DiscoverResponse getDiscoverData() {
        List<BookResponse> featured = bookRepository.findByIsFeaturedTrue().stream()
                .map(bookMapper::toBookResponse)
                .collect(Collectors.toList());

        List<BookResponse> trending = bookRepository.findByIsTrendingTrue().stream()
                .map(bookMapper::toBookResponse)
                .collect(Collectors.toList());

        List<BookResponse> newReleases = bookRepository.findByIsNewReleaseTrue().stream()
                .map(bookMapper::toBookResponse)
                .collect(Collectors.toList());

        List<GenreResponse> popularGenres = genreRepository.findAll().stream()
                .map(g -> genreMapper.toGenreResponse(g, (long) (g.getBooks() != null ? g.getBooks().size() : 0)))
                .collect(Collectors.toList());

        List<AuthorResponse> popularAuthors = authorRepository.findAll().stream()
                .map(a -> authorMapper.toAuthorResponse(a, false, (long) (a.getBooks() != null ? a.getBooks().size() : 0)))
                .collect(Collectors.toList());

        return DiscoverResponse.builder()
                .featured(featured)
                .trending(trending)
                .newReleases(newReleases)
                .popularGenres(popularGenres)
                .popularAuthors(popularAuthors)
                .build();
    }

    @Transactional(readOnly = true)
    public List<AuthorResponse> getAllAuthors(String userId) {
        return authorRepository.findAll().stream()
                .map(a -> {
                    boolean isFollowed = false;
                    if (userId != null) {
                        isFollowed = authorRepository.isFollowingAuthor(userId, a.getId());
                    }
                    return authorMapper.toAuthorResponse(a, isFollowed, (long) (a.getBooks() != null ? a.getBooks().size() : 0));
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public AuthorResponse getAuthorDetail(String authorId, String userId) {
        Author author = authorRepository.findById(authorId)
                .orElseThrow(() -> new ResourceNotFoundException("Author", "id", authorId));

        boolean isFollowed = false;
        if (userId != null) {
            isFollowed = authorRepository.isFollowingAuthor(userId, authorId);
        }

        return authorMapper.toAuthorResponse(author, isFollowed, (long) (author.getBooks() != null ? author.getBooks().size() : 0));
    }

    @Transactional
    public boolean toggleFollowAuthor(String authorId, String userId) {
        Author author = authorRepository.findById(authorId)
                .orElseThrow(() -> new ResourceNotFoundException("Author", "id", authorId));

        boolean isFollowing = authorRepository.isFollowingAuthor(userId, authorId);
        if (isFollowing) {
            authorRepository.unfollowAuthor(userId, authorId);
            author.setFollowersCount(Math.max(0, (author.getFollowersCount() != null ? author.getFollowersCount() : 1) - 1));
            authorRepository.save(author);
            return false;
        } else {
            authorRepository.followAuthor(userId, authorId);
            author.setFollowersCount((author.getFollowersCount() != null ? author.getFollowersCount() : 0) + 1);
            authorRepository.save(author);
            return true;
        }
    }

    @Transactional(readOnly = true)
    public List<GenreResponse> getAllGenres() {
        return genreRepository.findAll().stream()
                .map(g -> genreMapper.toGenreResponse(g, (long) (g.getBooks() != null ? g.getBooks().size() : 0)))
                .collect(Collectors.toList());
    }
}
