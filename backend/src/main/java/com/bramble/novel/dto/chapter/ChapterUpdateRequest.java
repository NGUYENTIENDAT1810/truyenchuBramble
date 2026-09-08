package com.bramble.novel.dto.chapter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChapterUpdateRequest {
    private Integer chapterNumber;
    private String title;
    private String content;
    private Boolean isFree;
    private Integer coinCost;
    private String status;
}
