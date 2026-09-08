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
public class ChapterDetailResponse {
    private String id;
    private String bookId;
    private String bookTitle;
    private Integer chapterNumber;
    private String title;
    private String content;
    private Integer wordCount;
    private Boolean isFree;
    private Integer coinCost;
    private Boolean isUnlocked;
    private Long commentsCount;
    private String prevChapterId;
    private String nextChapterId;
    private Integer prevChapterNumber;
    private Integer nextChapterNumber;
    private Instant createdAt;
}
