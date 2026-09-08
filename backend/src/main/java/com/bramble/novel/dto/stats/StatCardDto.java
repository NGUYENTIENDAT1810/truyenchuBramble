package com.bramble.novel.dto.stats;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatCardDto {
    private String label;
    private String value;
    private String unit;
    private String trend; // "+12%", etc.
}
