package com.bramble.novel.dto.stats;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsResponse {
    private Integer totalMinutesRead;
    private Integer currentStreakDays;
    private Integer longestStreakDays;
    private Integer booksCompleted;
    private Integer chaptersRead;
    private List<StatCardDto> cards;
    private List<DayChartDto> weeklyActivity;
}
