package com.bramble.novel.controller;

import com.bramble.novel.dto.chapter.ChapterDetailResponse;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.dto.chapter.UnlockResponse;
import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.ChapterService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "Chapters & Reader", description = "Endpoints for chapter listing, chapter content reader, and unlocking locked chapters")
public class ChapterController {

    private final ChapterService chapterService;

    @GetMapping({"/books/{bookId}/chapters", "/chapters/book/{bookId}"})
    @Operation(summary = "Get list of chapters for a specific book")
    public ResponseEntity<ApiResponse<List<ChapterResponse>>> getChaptersByBookId(
            @PathVariable String bookId,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        String userId = principal != null ? principal.getId() : null;
        List<ChapterResponse> data = chapterService.getChaptersByBookId(bookId, userId);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping("/chapters/{id}")
    @Operation(summary = "Get chapter content and details for reader view")
    public ResponseEntity<ApiResponse<ChapterDetailResponse>> getChapterDetail(
            @PathVariable String id,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        String userId = principal != null ? principal.getId() : null;
        ChapterDetailResponse data = chapterService.getChapterDetail(id, userId);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @PostMapping({"/chapters/{id}/unlock", "/chapters/{id}/unlock-chapter"})
    @Operation(summary = "Unlock premium chapter using user coins")
    public ResponseEntity<ApiResponse<UnlockResponse>> unlockChapter(
            @PathVariable String id,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        UnlockResponse data = chapterService.unlockChapter(id, principal.getId());
        return ResponseEntity.ok(ApiResponse.success(data.getMessage(), data));
    }
}
