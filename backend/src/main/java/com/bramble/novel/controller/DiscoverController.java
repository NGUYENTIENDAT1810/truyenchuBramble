package com.bramble.novel.controller;

import com.bramble.novel.dto.book.DiscoverResponse;
import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.service.BookService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/discover")
@RequiredArgsConstructor
@Tag(name = "Discover", description = "Discovery dashboard endpoints for featured, trending, new releases and genres")
public class DiscoverController {

    private final BookService bookService;

    @GetMapping
    @Operation(summary = "Get featured, trending, new releases and popular categories")
    public ResponseEntity<ApiResponse<DiscoverResponse>> getDiscoverData() {
        DiscoverResponse data = bookService.getDiscoverData();
        return ResponseEntity.ok(ApiResponse.success(data));
    }
}
