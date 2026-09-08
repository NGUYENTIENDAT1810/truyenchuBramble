package com.bramble.novel.controller;

import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.dto.library.LibraryItemResponse;
import com.bramble.novel.dto.library.LibraryStatusRequest;
import com.bramble.novel.dto.library.SaveBookRequest;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.LibraryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "Library", description = "Endpoints for managing user library, reading lists, saved books")
public class LibraryController {

    private final LibraryService libraryService;

    @GetMapping({"/me/library", "/library"})
    @Operation(summary = "Get current user's library items")
    public ResponseEntity<ApiResponse<List<LibraryItemResponse>>> getLibrary(
            @RequestParam(required = false) String status,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        List<LibraryItemResponse> data = libraryService.getUserLibrary(principal.getId(), status);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @PostMapping({"/me/library", "/library", "/library/toggle-save"})
    @Operation(summary = "Add a novel to user's library")
    public ResponseEntity<ApiResponse<LibraryItemResponse>> addToLibrary(
            @Valid @RequestBody SaveBookRequest request,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        LibraryItemResponse data = libraryService.addToLibrary(principal.getId(), request);
        return ResponseEntity.ok(ApiResponse.success("Book added to library", data));
    }

    @PatchMapping({"/me/library/{bookId}", "/library/{bookId}", "/library/status/{bookId}"})
    @Operation(summary = "Update library status (CURRENT, COMPLETED, SAVED)")
    public ResponseEntity<ApiResponse<LibraryItemResponse>> updateStatus(
            @PathVariable String bookId,
            @Valid @RequestBody LibraryStatusRequest request,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        LibraryItemResponse data = libraryService.updateStatus(principal.getId(), bookId, request.getStatus());
        return ResponseEntity.ok(ApiResponse.success("Library item updated", data));
    }

    @DeleteMapping({"/me/library/{bookId}", "/library/{bookId}"})
    @Operation(summary = "Remove a book from user's library")
    public ResponseEntity<ApiResponse<Void>> removeFromLibrary(
            @PathVariable String bookId,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        libraryService.removeFromLibrary(principal.getId(), bookId);
        return ResponseEntity.ok(ApiResponse.success("Book removed from library"));
    }
}
