package com.bramble.novel.dto.book;

import com.bramble.novel.dto.chapter.ChapterResponse;
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
public class BookDetailResponse {
    private String id;
    private String title;
    private String slug;
    private AuthorResponse author;
    private String coverUrl;
    private String description;
    private String status;
    private Double rating;
    private Long ratingsCount;
    private Long viewsCount;
    private Long totalChapters;
    private List<GenreResponse> genres;
    private Boolean isFeatured;
    private Boolean isTrending;
    private Boolean isNewRelease;
    private Boolean inLibrary;
    private String libraryStatus;
    private Integer userProgressPercent;
    private String lastReadChapterId;
    private Integer lastReadChapterNumber;
    private String lastReadChapterTitle;
    private List<ChapterResponse> recentChapters;
    private Instant createdAt;
    private Instant updatedAt;
}
