package com.bramble.novel.dto.reader;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgressRequest {
    @NotBlank(message = "Chapter ID is required")
    private String chapterId;

    private Integer progressPercent;
    private Double scrollOffset;
    private Integer readingTimeSeconds;
}
