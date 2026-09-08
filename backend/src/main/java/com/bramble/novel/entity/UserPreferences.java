package com.bramble.novel.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "user_preferences")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserPreferences {

    @Id
    @Column(length = 36)
    private String id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(length = 50)
    @Builder.Default
    private String theme = "CREAM";

    @Column(name = "font_size")
    @Builder.Default
    private Integer fontSize = 18;

    @Column(name = "font_family", length = 50)
    @Builder.Default
    private String fontFamily = "Serif";

    @Column(name = "line_height")
    @Builder.Default
    private Double lineHeight = 1.6;

    @Column(name = "margin_horizontal")
    @Builder.Default
    private Double marginHorizontal = 24.0;

    @Column(name = "auto_unlock")
    @Builder.Default
    private Boolean autoUnlock = false;

    @Column(name = "sound_effects")
    @Builder.Default
    private Boolean soundEffects = true;

    @Column(name = "reading_pace", length = 50)
    @Builder.Default
    private String readingPace = "daily";

    @Column(name = "hide_spoilers")
    @Builder.Default
    private Boolean hideSpoilers = true;

    public Boolean getAutoUnlock() {
        return autoUnlock != null ? autoUnlock : false;
    }

    public void setAutoUnlock(Boolean autoUnlock) {
        this.autoUnlock = autoUnlock;
    }

    public Boolean getSoundEffects() {
        return soundEffects != null ? soundEffects : true;
    }

    public void setSoundEffects(Boolean soundEffects) {
        this.soundEffects = soundEffects;
    }

    public Double getMarginHorizontal() {
        return marginHorizontal != null ? marginHorizontal : 24.0;
    }

    public void setMarginHorizontal(Double marginHorizontal) {
        this.marginHorizontal = marginHorizontal;
    }

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUID.randomUUID().toString();
        }
    }
}
