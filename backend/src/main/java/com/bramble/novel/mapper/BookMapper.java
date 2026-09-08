package com.bramble.novel.mapper;

import com.bramble.novel.dto.book.AuthorResponse;
import com.bramble.novel.dto.book.BookDetailResponse;
import com.bramble.novel.dto.book.BookResponse;
import com.bramble.novel.dto.book.GenreResponse;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.entity.Book;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class BookMapper {

    private final GenreMapper genreMapper;
    private final AuthorMapper authorMapper;

    public BookResponse toBookResponse(Book book) {
        if (book == null) return null;

        List<GenreResponse> genreResponses = book.getGenres() != null
                ? book.getGenres().stream().map(g -> genreMapper.toGenreResponse(g, null)).collect(Collectors.toList())
                : Collections.emptyList();

        List<String> genreNames = book.getGenres() != null
                ? book.getGenres().stream().map(g -> g.getName()).collect(Collectors.toList())
                : Collections.emptyList();

        return BookResponse.builder()
                .id(book.getId())
                .title(book.getTitle())
                .slug(book.getSlug())
                .authorId(book.getAuthor() != null ? book.getAuthor().getId() : null)
                .authorName(book.getAuthor() != null ? book.getAuthor().getName() : "Unknown")
                .authorAvatarUrl(book.getAuthor() != null ? book.getAuthor().getAvatarUrl() : null)
                .coverUrl(book.getCoverUrl())
                .description(book.getDescription())
                .status(book.getStatus() != null ? book.getStatus().name() : "ONGOING")
                .rating(book.getRating() != null ? book.getRating() : 0.0)
                .ratingsCount(book.getRatingsCount() != null ? book.getRatingsCount() : 0L)
                .viewsCount(book.getViewsCount() != null ? book.getViewsCount() : 0L)
                .totalChapters(book.getTotalChapters() != null ? book.getTotalChapters() : 0L)
                .genres(genreNames)
                .genreDetails(genreResponses)
                .isFeatured(book.getIsFeatured() != null ? book.getIsFeatured() : false)
                .isTrending(book.getIsTrending() != null ? book.getIsTrending() : false)
                .isNewRelease(book.getIsNewRelease() != null ? book.getIsNewRelease() : false)
                .createdAt(book.getCreatedAt())
                .updatedAt(book.getUpdatedAt())
                .build();
    }

    public BookDetailResponse toBookDetailResponse(
            Book book,
            Boolean inLibrary,
            String libraryStatus,
            Integer userProgressPercent,
            String lastReadChapterId,
            Integer lastReadChapterNumber,
            String lastReadChapterTitle,
            List<ChapterResponse> recentChapters
    ) {
        if (book == null) return null;

        AuthorResponse authorRes = book.getAuthor() != null
                ? authorMapper.toAuthorResponse(book.getAuthor(), false, null)
                : null;

        List<GenreResponse> genreResponses = book.getGenres() != null
                ? book.getGenres().stream().map(g -> genreMapper.toGenreResponse(g, null)).collect(Collectors.toList())
                : Collections.emptyList();

        return BookDetailResponse.builder()
                .id(book.getId())
                .title(book.getTitle())
                .slug(book.getSlug())
                .author(authorRes)
                .coverUrl(book.getCoverUrl())
                .description(book.getDescription())
                .status(book.getStatus() != null ? book.getStatus().name() : "ONGOING")
                .rating(book.getRating() != null ? book.getRating() : 0.0)
                .ratingsCount(book.getRatingsCount() != null ? book.getRatingsCount() : 0L)
                .viewsCount(book.getViewsCount() != null ? book.getViewsCount() : 0L)
                .totalChapters(book.getTotalChapters() != null ? book.getTotalChapters() : 0L)
                .genres(genreResponses)
                .isFeatured(book.getIsFeatured() != null ? book.getIsFeatured() : false)
                .isTrending(book.getIsTrending() != null ? book.getIsTrending() : false)
                .isNewRelease(book.getIsNewRelease() != null ? book.getIsNewRelease() : false)
                .inLibrary(inLibrary != null ? inLibrary : false)
                .libraryStatus(libraryStatus)
                .userProgressPercent(userProgressPercent != null ? userProgressPercent : 0)
                .lastReadChapterId(lastReadChapterId)
                .lastReadChapterNumber(lastReadChapterNumber)
                .lastReadChapterTitle(lastReadChapterTitle)
                .recentChapters(recentChapters != null ? recentChapters : Collections.emptyList())
                .createdAt(book.getCreatedAt())
                .updatedAt(book.getUpdatedAt())
                .build();
    }
}
