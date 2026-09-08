package com.bramble.novel.dto.reader;

import com.bramble.novel.dto.book.BookResponse;
import com.bramble.novel.dto.chapter.ChapterResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActiveReadingResponse {
    private String id;
    private String bookId;
    private BookResponse book;
    private String chapterId;
    private ChapterResponse chapter;
    private Integer chapterNumber;
    private String chapterTitle;
    private Integer progressPercent;
    private Double scrollOffset;
    private Integer readingTimeSeconds;
    private Instant lastReadAt;
}
