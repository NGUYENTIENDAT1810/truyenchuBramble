package com.bramble.novel.dto.reader;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgressResponse {
    private String id;
    private String bookId;
    private String chapterId;
    private Integer progressPercent;
    private Double scrollOffset;
    private Integer readingTimeSeconds;
    private Instant lastReadAt;
}
