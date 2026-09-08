package com.bramble.novel.dto.book;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GenreResponse {
    private String id;
    private String name;
    private String slug;
    private String description;
    private String iconName;
    private Long booksCount;
}
