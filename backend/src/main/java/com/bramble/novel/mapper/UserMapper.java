package com.bramble.novel.mapper;

import com.bramble.novel.dto.auth.UserPreferencesDto;
import com.bramble.novel.dto.auth.UserResponse;
import com.bramble.novel.entity.User;
import com.bramble.novel.entity.UserPreferences;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserResponse toUserResponse(User user) {
        if (user == null) return null;

        UserPreferencesDto prefDto = null;
        if (user.getPreferences() != null) {
            UserPreferences p = user.getPreferences();
            prefDto = UserPreferencesDto.builder()
                    .theme(p.getTheme())
                    .fontSize(p.getFontSize())
                    .fontFamily(p.getFontFamily())
                    .lineHeight(p.getLineHeight())
                    .marginHorizontal(p.getMarginHorizontal())
                    .autoUnlock(p.getAutoUnlock())
                    .soundEffects(p.getSoundEffects())
                    .build();
        }

        return UserResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .displayName(user.getDisplayName())
                .avatarUrl(user.getAvatarUrl())
                .role(user.getRole() != null ? user.getRole().name() : "USER")
                .coins(user.getCoins())
                .isVip(user.getIsVip())
                .vipExpiresAt(user.getVipExpiresAt())
                .preferences(prefDto)
                .createdAt(user.getCreatedAt())
                .build();
    }
}
