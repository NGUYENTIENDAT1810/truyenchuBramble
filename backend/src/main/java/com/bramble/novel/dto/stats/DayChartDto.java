package com.bramble.novel.dto.stats;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DayChartDto {
    private String day; // "Mon", "Tue", etc.
    private Integer minutes;
    private Integer chapters;
}
