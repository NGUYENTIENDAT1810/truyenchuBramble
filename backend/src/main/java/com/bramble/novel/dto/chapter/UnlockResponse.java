package com.bramble.novel.dto.chapter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UnlockResponse {
    private Boolean success;
    private String chapterId;
    private Integer coinsDeducted;
    private Integer remainingCoins;
    private String message;
}
