package com.bramble.novel.controller;

import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.dto.reader.ActiveReadingResponse;
import com.bramble.novel.dto.reader.ProgressRequest;
import com.bramble.novel.dto.reader.ProgressResponse;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.ReaderService;
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
@Tag(name = "Reader Progress", description = "Endpoints for synchronizing reading position, active reading session, and reading history")
public class ReaderController {

    private final ReaderService readerService;

    @GetMapping({"/me/active-reading", "/reader/active"})
    @Operation(summary = "Get the currently active novel/chapter being read by the user")
    public ResponseEntity<ApiResponse<ActiveReadingResponse>> getActiveReading(@AuthenticationPrincipal UserPrincipal principal) {
        ActiveReadingResponse data = readerService.getActiveReading(principal.getId());
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping({"/me/books/{bookId}/progress", "/reader/progress/{bookId}"})
    @Operation(summary = "Get reading progress for a specific novel")
    public ResponseEntity<ApiResponse<ProgressResponse>> getProgress(
            @PathVariable String bookId,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        ProgressResponse data = readerService.getProgressByBookId(principal.getId(), bookId);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @PostMapping({"/me/books/{bookId}/progress", "/reader/progress/{bookId}"})
    @Operation(summary = "Update reading progress and scroll position for a novel")
    public ResponseEntity<ApiResponse<ProgressResponse>> saveProgress(
            @PathVariable String bookId,
            @Valid @RequestBody ProgressRequest request,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        ProgressResponse data = readerService.saveProgress(principal.getId(), bookId, request);
        return ResponseEntity.ok(ApiResponse.success("Progress saved", data));
    }
}
