package com.bramble.novel.mapper;

import com.bramble.novel.dto.chapter.ChapterDetailResponse;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.entity.Chapter;
import org.springframework.stereotype.Component;

@Component
public class ChapterMapper {

    public ChapterResponse toChapterResponse(Chapter chapter, Boolean isUnlocked) {
        if (chapter == null) return null;

        return ChapterResponse.builder()
                .id(chapter.getId())
                .bookId(chapter.getBook() != null ? chapter.getBook().getId() : null)
                .chapterNumber(chapter.getChapterNumber())
                .title(chapter.getTitle())
                .wordCount(chapter.getWordCount() != null ? chapter.getWordCount() : 0)
                .isFree(chapter.getIsFree() != null ? chapter.getIsFree() : true)
                .coinCost(chapter.getCoinCost() != null ? chapter.getCoinCost() : 0)
                .isUnlocked(isUnlocked != null ? isUnlocked : (chapter.getIsFree() != null ? chapter.getIsFree() : true))
                .commentsCount(chapter.getCommentsCount() != null ? chapter.getCommentsCount() : 0L)
                .createdAt(chapter.getCreatedAt())
                .build();
    }

    public ChapterDetailResponse toChapterDetailResponse(
            Chapter chapter,
            Boolean isUnlocked,
            String prevChapterId,
            Integer prevChapterNumber,
            String nextChapterId,
            Integer nextChapterNumber
    ) {
        if (chapter == null) return null;

        return ChapterDetailResponse.builder()
                .id(chapter.getId())
                .bookId(chapter.getBook() != null ? chapter.getBook().getId() : null)
                .bookTitle(chapter.getBook() != null ? chapter.getBook().getTitle() : null)
                .chapterNumber(chapter.getChapterNumber())
                .title(chapter.getTitle())
                .content(chapter.getContent())
                .wordCount(chapter.getWordCount() != null ? chapter.getWordCount() : 0)
                .isFree(chapter.getIsFree() != null ? chapter.getIsFree() : true)
                .coinCost(chapter.getCoinCost() != null ? chapter.getCoinCost() : 0)
                .isUnlocked(isUnlocked != null ? isUnlocked : (chapter.getIsFree() != null ? chapter.getIsFree() : true))
                .commentsCount(chapter.getCommentsCount() != null ? chapter.getCommentsCount() : 0L)
                .prevChapterId(prevChapterId)
                .prevChapterNumber(prevChapterNumber)
                .nextChapterId(nextChapterId)
                .nextChapterNumber(nextChapterNumber)
                .createdAt(chapter.getCreatedAt())
                .build();
    }
}
