package com.bramble.novel.mapper;

import com.bramble.novel.dto.book.GenreResponse;
import com.bramble.novel.entity.Genre;
import org.springframework.stereotype.Component;

@Component
public class GenreMapper {

    public GenreResponse toGenreResponse(Genre genre, Long booksCount) {
        if (genre == null) return null;

        return GenreResponse.builder()
                .id(genre.getId())
                .name(genre.getName())
                .slug(genre.getSlug())
                .description(genre.getDescription())
                .iconName(genre.getIconName())
                .booksCount(booksCount != null ? booksCount : (genre.getBooks() != null ? (long) genre.getBooks().size() : 0L))
                .build();
    }
}
