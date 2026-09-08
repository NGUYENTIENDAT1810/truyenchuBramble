package com.bramble.novel.dto.comment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommentResponse {
    private String id;
    private String chapterId;
    private String userId;
    private String userName;
    private String userAvatarUrl;
    private String content;
    private Integer paragraphIndex;
    private Long likesCount;
    private Boolean isLiked;
    private String parentId;
    private Instant createdAt;
}
