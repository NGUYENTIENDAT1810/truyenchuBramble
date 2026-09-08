package com.bramble.novel.controller;

import com.bramble.novel.dto.comment.CommentCreateRequest;
import com.bramble.novel.dto.comment.CommentResponse;
import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.dto.common.PageResponse;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.CommentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "Comments", description = "Endpoints for chapter and inline paragraph comments, replies, and like toggling")
public class CommentController {

    private final CommentService commentService;

    @GetMapping({"/chapters/{chapterId}/comments", "/comments/chapter/{chapterId}"})
    @Operation(summary = "Get comments for a chapter (optionally filtered by paragraph index)")
    public ResponseEntity<ApiResponse<PageResponse<CommentResponse>>> getComments(
            @PathVariable String chapterId,
            @RequestParam(required = false) Integer paragraphIndex,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        String userId = principal != null ? principal.getId() : null;
        PageResponse<CommentResponse> data = commentService.getCommentsByChapter(chapterId, paragraphIndex, userId, page, limit);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @PostMapping({"/chapters/{chapterId}/comments", "/comments/{chapterId}"})
    @Operation(summary = "Post a new comment or reply to a chapter/paragraph")
    public ResponseEntity<ApiResponse<CommentResponse>> createComment(
            @PathVariable String chapterId,
            @Valid @RequestBody CommentCreateRequest request,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        CommentResponse data = commentService.createComment(chapterId, principal.getId(), request);
        return ResponseEntity.ok(ApiResponse.success("Comment posted", data));
    }

    @PostMapping("/comments/{id}/like")
    @Operation(summary = "Like or unlike a comment")
    public ResponseEntity<ApiResponse<Boolean>> toggleLike(
            @PathVariable String id,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        boolean isLiked = commentService.toggleLike(id, principal.getId());
        String msg = isLiked ? "Comment liked" : "Comment unliked";
        return ResponseEntity.ok(ApiResponse.success(msg, isLiked));
    }
}
