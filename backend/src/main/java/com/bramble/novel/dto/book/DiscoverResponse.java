package com.bramble.novel.dto.book;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DiscoverResponse {
    private List<BookResponse> featured;
    private List<BookResponse> trending;
    private List<BookResponse> newReleases;
    private List<GenreResponse> popularGenres;
    private List<AuthorResponse> popularAuthors;
}
