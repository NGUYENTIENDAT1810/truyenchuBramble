package com.bramble.novel.mapper;

import com.bramble.novel.dto.book.AuthorResponse;
import com.bramble.novel.entity.Author;
import org.springframework.stereotype.Component;

@Component
public class AuthorMapper {

    public AuthorResponse toAuthorResponse(Author author, Boolean isFollowed, Long booksCount) {
        if (author == null) return null;

        return AuthorResponse.builder()
                .id(author.getId())
                .name(author.getName())
                .bio(author.getBio())
                .avatarUrl(author.getAvatarUrl())
                .followersCount(author.getFollowersCount() != null ? author.getFollowersCount() : 0L)
                .isFollowed(isFollowed != null ? isFollowed : false)
                .booksCount(booksCount != null ? booksCount : (author.getBooks() != null ? (long) author.getBooks().size() : 0L))
                .build();
    }
}
