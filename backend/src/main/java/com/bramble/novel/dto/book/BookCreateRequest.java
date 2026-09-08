package com.bramble.novel.dto.book;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookCreateRequest {
    @NotBlank(message = "Title is required")
    private String title;

    private String authorId;
    private String coverUrl;
    private String description;
    private String status;
    private Boolean isFeatured;
    private Boolean isTrending;
    private Boolean isNewRelease;
    private List<String> genreIds;
}
