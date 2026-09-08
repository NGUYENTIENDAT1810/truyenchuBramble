package com.bramble.novel.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
    name = "reading_progress",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "book_id"})
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReadingProgress {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chapter_id", nullable = false)
    private Chapter chapter;

    @Column(name = "progress_percent")
    @Builder.Default
    private Integer progressPercent = 0;

    @Column(name = "scroll_offset")
    @Builder.Default
    private Double scrollOffset = 0.0;

    @Column(name = "reading_time_seconds")
    @Builder.Default
    private Integer readingTimeSeconds = 0;

    @Column(name = "last_read_at")
    @Builder.Default
    private Instant lastReadAt = Instant.now();

    public Integer getProgressPercent() {
        return progressPercent != null ? progressPercent : 0;
    }

    public void setProgressPercent(Integer progressPercent) {
        this.progressPercent = progressPercent;
    }

    public Double getScrollOffset() {
        return scrollOffset != null ? scrollOffset : 0.0;
    }

    public void setScrollOffset(Double scrollOffset) {
        this.scrollOffset = scrollOffset;
    }

    public Integer getReadingTimeSeconds() {
        return readingTimeSeconds != null ? readingTimeSeconds : 0;
    }

    public void setReadingTimeSeconds(Integer readingTimeSeconds) {
        this.readingTimeSeconds = readingTimeSeconds;
    }

    public Instant getLastReadAt() {
        return lastReadAt;
    }

    public void setLastReadAt(Instant lastReadAt) {
        this.lastReadAt = lastReadAt;
    }

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUID.randomUUID().toString();
        }
    }
}
