package com.bramble.novel.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private String id;
    private String email;
    private String displayName;
    private String avatarUrl;
    private String role;
    private Integer coins;
    private Boolean isVip;
    private Instant vipExpiresAt;
    private UserPreferencesDto preferences;
    private Instant createdAt;
}
