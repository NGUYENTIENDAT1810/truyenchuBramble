package com.bramble.novel.dto.book;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookResponse {
    private String id;
    private String title;
    private String slug;
    private String authorId;
    private String authorName;
    private String authorAvatarUrl;
    private String coverUrl;
    private String description;
    private String status;
    private Double rating;
    private Long ratingsCount;
    private Long viewsCount;
    private Long totalChapters;
    private List<String> genres;
    private List<GenreResponse> genreDetails;
    private Boolean isFeatured;
    private Boolean isTrending;
    private Boolean isNewRelease;
    private Instant createdAt;
    private Instant updatedAt;
}
