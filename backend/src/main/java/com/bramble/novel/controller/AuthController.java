package com.bramble.novel.controller;

import com.bramble.novel.dto.auth.*;
import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.AuthService;
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
@Tag(name = "Authentication & User", description = "Endpoints for user registration, login, token refresh, profile and preferences")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/auth/register")
    @Operation(summary = "Register a new user account")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse data = authService.register(request);
        return ResponseEntity.ok(ApiResponse.success("Registration successful", data));
    }

    @PostMapping("/auth/login")
    @Operation(summary = "Authenticate user with email and password")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse data = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Login successful", data));
    }

    @PostMapping({"/auth/refresh", "/auth/refresh-token"})
    @Operation(summary = "Refresh access token using refresh token")
    public ResponseEntity<ApiResponse<AuthResponse>> refresh(@Valid @RequestBody RefreshTokenRequest request) {
        AuthResponse data = authService.refreshToken(request);
        return ResponseEntity.ok(ApiResponse.success("Token refreshed", data));
    }

    @PostMapping("/auth/logout")
    @Operation(summary = "Logout user and revoke refresh token")
    public ResponseEntity<ApiResponse<Void>> logout(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestBody(required = false) RefreshTokenRequest request
    ) {
        String userId = principal != null ? principal.getId() : null;
        String refreshToken = request != null ? request.getRefreshToken() : null;
        authService.logout(userId, refreshToken);
        return ResponseEntity.ok(ApiResponse.success("Logged out successfully"));
    }

    @GetMapping({"/users/me", "/auth/me"})
    @Operation(summary = "Get current authenticated user profile")
    public ResponseEntity<ApiResponse<UserResponse>> getCurrentUser(@AuthenticationPrincipal UserPrincipal principal) {
        UserResponse data = authService.getCurrentUser(principal.getId());
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @PutMapping({"/users/me/preferences", "/auth/preferences"})
    @Operation(summary = "Update user reader and display preferences")
    public ResponseEntity<ApiResponse<UserResponse>> updatePreferences(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestBody UserPreferencesDto dto
    ) {
        UserResponse data = authService.updatePreferences(principal.getId(), dto);
        return ResponseEntity.ok(ApiResponse.success("Preferences updated", data));
    }
}
