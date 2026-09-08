package com.bramble.novel.dto.book;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthorResponse {
    private String id;
    private String name;
    private String bio;
    private String avatarUrl;
    private Long followersCount;
    private Boolean isFollowed;
    private Long booksCount;
}
