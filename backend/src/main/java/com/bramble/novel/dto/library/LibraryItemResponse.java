package com.bramble.novel.dto.library;

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
public class LibraryItemResponse {
    private String id;
    private String bookId;
    private BookResponse book;
    private String status;
    private Integer progressPercent;
    private String lastReadChapterId;
    private Integer lastReadChapterNumber;
    private String lastReadChapterTitle;
    private Instant lastReadAt;
    private Instant createdAt;
}
