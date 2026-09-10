package com.bramble.novel.controller;

import com.bramble.novel.dto.book.AuthorResponse;
import com.bramble.novel.dto.book.BookDetailResponse;
import com.bramble.novel.dto.book.BookResponse;
import com.bramble.novel.dto.book.GenreResponse;
import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.dto.common.PageResponse;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.BookService;
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
@Tag(name = "Books & Metadata", description = "Endpoints for novel catalog, genres, authors, and author follows")
public class BookController {

    private final BookService bookService;

    @GetMapping("/books")
    @Operation(summary = "Get list of books with search, filter, and pagination")
    public ResponseEntity<ApiResponse<PageResponse<BookResponse>>> getAllBooks(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) String tag,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit
    ) {
        String effectiveSearch = (search != null && !search.isEmpty()) ? search : query;
        String effectiveGenre = (genre != null && !genre.isEmpty() && !genre.equalsIgnoreCase("All")) ? genre : ((tag != null && !tag.equalsIgnoreCase("All")) ? tag : null);
        PageResponse<BookResponse> data = bookService.getAllBooks(effectiveSearch, effectiveGenre, status, sortBy, page, limit);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping("/books/{id}")
    @Operation(summary = "Get detailed information about a single book")
    public ResponseEntity<ApiResponse<BookDetailResponse>> getBookDetail(
            @PathVariable String id,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        String userId = principal != null ? principal.getId() : null;
        BookDetailResponse data = bookService.getBookDetail(id, userId);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping({"/discover", "/books/discover"})
    @Operation(summary = "Get featured, trending, new releases and popular categories")
    public ResponseEntity<ApiResponse<com.bramble.novel.dto.book.DiscoverResponse>> getDiscoverData() {
        com.bramble.novel.dto.book.DiscoverResponse data = bookService.getDiscoverData();
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping({"/authors", "/books/authors"})
    @Operation(summary = "Get list of authors")
    public ResponseEntity<ApiResponse<List<AuthorResponse>>> getAllAuthors(@AuthenticationPrincipal UserPrincipal principal) {
        String userId = principal != null ? principal.getId() : null;
        List<AuthorResponse> data = bookService.getAllAuthors(userId);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @GetMapping({"/authors/{id}", "/books/authors/{id}"})
    @Operation(summary = "Get author profile by id")
    public ResponseEntity<ApiResponse<AuthorResponse>> getAuthorDetail(
            @PathVariable String id,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        String userId = principal != null ? principal.getId() : null;
        AuthorResponse data = bookService.getAuthorDetail(id, userId);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @PostMapping({"/authors/{id}/follow", "/books/authors/{id}/follow"})
    @Operation(summary = "Follow or unfollow an author")
    public ResponseEntity<ApiResponse<Boolean>> toggleFollowAuthor(
            @PathVariable String id,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        boolean isFollowing = bookService.toggleFollowAuthor(id, principal.getId());
        String msg = isFollowing ? "Author followed" : "Author unfollowed";
        return ResponseEntity.ok(ApiResponse.success(msg, isFollowing));
    }

    @GetMapping("/genres")
    @Operation(summary = "Get list of novel genres")
    public ResponseEntity<ApiResponse<List<GenreResponse>>> getAllGenres() {
        List<GenreResponse> data = bookService.getAllGenres();
        return ResponseEntity.ok(ApiResponse.success(data));
    }
}
