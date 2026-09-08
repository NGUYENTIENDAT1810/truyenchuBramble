package com.bramble.novel.controller;

import com.bramble.novel.dto.book.BookCreateRequest;
import com.bramble.novel.dto.book.BookResponse;
import com.bramble.novel.dto.chapter.ChapterCreateRequest;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.dto.chapter.ChapterUpdateRequest;
import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.service.AdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "Admin Management", description = "Endpoints for platform administrators to manage books, chapters, and metadata")
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/books")
    @Operation(summary = "Create a new book")
    public ResponseEntity<ApiResponse<BookResponse>> createBook(@Valid @RequestBody BookCreateRequest request) {
        BookResponse data = adminService.createBook(request);
        return ResponseEntity.ok(ApiResponse.success("Book created successfully", data));
    }

    @PutMapping("/books/{id}")
    @Operation(summary = "Update an existing book")
    public ResponseEntity<ApiResponse<BookResponse>> updateBook(
            @PathVariable String id,
            @Valid @RequestBody BookCreateRequest request
    ) {
        BookResponse data = adminService.updateBook(id, request);
        return ResponseEntity.ok(ApiResponse.success("Book updated successfully", data));
    }

    @DeleteMapping("/books/{id}")
    @Operation(summary = "Delete a book")
    public ResponseEntity<ApiResponse<Void>> deleteBook(@PathVariable String id) {
        adminService.deleteBook(id);
        return ResponseEntity.ok(ApiResponse.success("Book deleted successfully"));
    }

    @PostMapping("/books/{bookId}/chapters")
    @Operation(summary = "Create a new chapter for a book")
    public ResponseEntity<ApiResponse<ChapterResponse>> createChapter(
            @PathVariable String bookId,
            @Valid @RequestBody ChapterCreateRequest request
    ) {
        ChapterResponse data = adminService.createChapter(bookId, request);
        return ResponseEntity.ok(ApiResponse.success("Chapter created successfully", data));
    }

    @PutMapping("/chapters/{id}")
    @Operation(summary = "Update an existing chapter")
    public ResponseEntity<ApiResponse<ChapterResponse>> updateChapter(
            @PathVariable String id,
            @Valid @RequestBody ChapterUpdateRequest request
    ) {
        ChapterResponse data = adminService.updateChapter(id, request);
        return ResponseEntity.ok(ApiResponse.success("Chapter updated successfully", data));
    }

    @DeleteMapping("/chapters/{id}")
    @Operation(summary = "Delete a chapter")
    public ResponseEntity<ApiResponse<Void>> deleteChapter(@PathVariable String id) {
        adminService.deleteChapter(id);
        return ResponseEntity.ok(ApiResponse.success("Chapter deleted successfully"));
    }
}
