package com.bramble.novel.controller;

import com.bramble.novel.dto.common.ApiResponse;
import com.bramble.novel.dto.stats.StatsResponse;
import com.bramble.novel.security.UserPrincipal;
import com.bramble.novel.service.StatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "Reading Statistics", description = "Endpoints for user reading stats, weekly activity charts, streaks")
public class StatsController {

    private final StatsService statsService;

    @GetMapping({"/me/stats", "/stats", "/stats/me"})
    @Operation(summary = "Get reading statistics for current user")
    public ResponseEntity<ApiResponse<StatsResponse>> getStats(@AuthenticationPrincipal UserPrincipal principal) {
        StatsResponse data = statsService.getUserStats(principal.getId());
        return ResponseEntity.ok(ApiResponse.success(data));
    }
}
