package com.bramble.novel.dto.chapter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChapterResponse {
    private String id;
    private String bookId;
    private Integer chapterNumber;
    private String title;
    private Integer wordCount;
    private Boolean isFree;
    private Integer coinCost;
    private Boolean isUnlocked;
    private Long commentsCount;
    private Instant createdAt;
}
