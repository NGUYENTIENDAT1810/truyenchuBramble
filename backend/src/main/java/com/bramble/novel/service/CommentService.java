package com.bramble.novel.service;

import com.bramble.novel.dto.comment.CommentCreateRequest;
import com.bramble.novel.dto.comment.CommentResponse;
import com.bramble.novel.dto.common.PageResponse;
import com.bramble.novel.entity.Chapter;
import com.bramble.novel.entity.Comment;
import com.bramble.novel.entity.User;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.mapper.CommentMapper;
import com.bramble.novel.repository.ChapterRepository;
import com.bramble.novel.repository.CommentLikeRepository;
import com.bramble.novel.repository.CommentRepository;
import com.bramble.novel.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final CommentLikeRepository commentLikeRepository;
    private final ChapterRepository chapterRepository;
    private final UserRepository userRepository;
    private final CommentMapper commentMapper;

    @Transactional(readOnly = true)
    public PageResponse<CommentResponse> getCommentsByChapter(
            String chapterId,
            Integer paragraphIndex,
            String userId,
            int page,
            int limit
    ) {
        Pageable pageable = PageRequest.of(page > 0 ? page - 1 : 0, limit > 0 ? limit : 20);
        Page<Comment> commentPage;

        if (paragraphIndex != null) {
            commentPage = commentRepository.findByChapterIdAndParagraphIndexOrderByCreatedAtDesc(chapterId, paragraphIndex, pageable);
        } else {
            commentPage = commentRepository.findByChapterIdAndParentIsNullOrderByCreatedAtDesc(chapterId, pageable);
        }

        List<CommentResponse> items = commentPage.getContent().stream()
                .map(c -> {
                    boolean isLiked = false;
                    if (userId != null) {
                        isLiked = commentLikeRepository.existsByUserIdAndCommentId(userId, c.getId());
                    }
                    return commentMapper.toCommentResponse(c, isLiked);
                })
                .collect(Collectors.toList());

        return PageResponse.<CommentResponse>builder()
                .items(items)
                .page(page > 0 ? page : 1)
                .limit(limit > 0 ? limit : 20)
                .totalElements(commentPage.getTotalElements())
                .totalPages(commentPage.getTotalPages())
                .hasNext(commentPage.hasNext())
                .hasPrev(commentPage.hasPrevious())
                .build();
    }

    @Transactional
    public CommentResponse createComment(String chapterId, String userId, CommentCreateRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));

        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new ResourceNotFoundException("Chapter", "id", chapterId));

        Comment parent = null;
        if (request.getParentId() != null) {
            parent = commentRepository.findById(request.getParentId()).orElse(null);
        }

        Comment comment = Comment.builder()
                .chapter(chapter)
                .user(user)
                .parent(parent)
                .content(request.getContent())
                .paragraphIndex(request.getParagraphIndex())
                .likesCount(0L)
                .build();

        comment = commentRepository.save(comment);

        // Update chapter comments count
        chapter.setCommentsCount((chapter.getCommentsCount() != null ? chapter.getCommentsCount() : 0L) + 1);
        chapterRepository.save(chapter);

        return commentMapper.toCommentResponse(comment, false);
    }

    @Transactional
    public boolean toggleLike(String commentId, String userId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("Comment", "id", commentId));

        boolean isLiked = commentLikeRepository.existsByUserIdAndCommentId(userId, commentId);
        if (isLiked) {
            commentLikeRepository.deleteByUserIdAndCommentId(userId, commentId);
            comment.setLikesCount(Math.max(0, (comment.getLikesCount() != null ? comment.getLikesCount() : 1) - 1));
            commentRepository.save(comment);
            return false;
        } else {
            commentLikeRepository.addLike(userId, commentId);
            comment.setLikesCount((comment.getLikesCount() != null ? comment.getLikesCount() : 0) + 1);
            commentRepository.save(comment);
            return true;
        }
    }
}
