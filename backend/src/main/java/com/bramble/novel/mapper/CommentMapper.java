package com.bramble.novel.mapper;

import com.bramble.novel.dto.comment.CommentResponse;
import com.bramble.novel.entity.Comment;
import org.springframework.stereotype.Component;

@Component
public class CommentMapper {

    public CommentResponse toCommentResponse(Comment comment, Boolean isLiked) {
        if (comment == null) return null;

        return CommentResponse.builder()
                .id(comment.getId())
                .chapterId(comment.getChapter() != null ? comment.getChapter().getId() : null)
                .userId(comment.getUser() != null ? comment.getUser().getId() : null)
                .userName(comment.getUser() != null ? comment.getUser().getDisplayName() : "Anonymous")
                .userAvatarUrl(comment.getUser() != null ? comment.getUser().getAvatarUrl() : null)
                .content(comment.getContent())
                .paragraphIndex(comment.getParagraphIndex())
                .likesCount(comment.getLikesCount() != null ? comment.getLikesCount() : 0L)
                .isLiked(isLiked != null ? isLiked : false)
                .parentId(comment.getParent() != null ? comment.getParent().getId() : null)
                .createdAt(comment.getCreatedAt())
                .build();
    }
}
