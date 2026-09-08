package com.bramble.novel.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserPreferencesDto {
    private String theme;
    private Integer fontSize;
    private String fontFamily;
    private Double lineHeight;
    private Double marginHorizontal;
    private Boolean autoUnlock;
    private Boolean soundEffects;
}
