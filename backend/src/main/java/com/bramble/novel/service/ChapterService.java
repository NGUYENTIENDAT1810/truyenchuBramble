package com.bramble.novel.service;

import com.bramble.novel.dto.chapter.ChapterDetailResponse;
import com.bramble.novel.dto.chapter.ChapterResponse;
import com.bramble.novel.dto.chapter.UnlockResponse;
import com.bramble.novel.entity.Chapter;
import com.bramble.novel.entity.User;
import com.bramble.novel.exception.BadRequestException;
import com.bramble.novel.exception.ForbiddenException;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.mapper.ChapterMapper;
import com.bramble.novel.repository.ChapterRepository;
import com.bramble.novel.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChapterService {

    private final ChapterRepository chapterRepository;
    private final UserRepository userRepository;
    private final ChapterMapper chapterMapper;

    @Transactional(readOnly = true)
    public List<ChapterResponse> getChaptersByBookId(String bookId, String userId) {
        List<Chapter> chapters = chapterRepository.findByBookIdOrderByChapterNumberAsc(bookId);

        return chapters.stream()
                .map(c -> {
                    boolean isUnlocked = isChapterUnlocked(c, userId);
                    return chapterMapper.toChapterResponse(c, isUnlocked);
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ChapterDetailResponse getChapterDetail(String chapterId, String userId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new ResourceNotFoundException("Chapter", "id", chapterId));

        boolean isUnlocked = isChapterUnlocked(chapter, userId);
        if (!isUnlocked) {
            throw new ForbiddenException("Chapter is locked. Please unlock using Bramble coins.");
        }

        // Find prev and next chapters
        String bookId = chapter.getBook().getId();
        int currentNum = chapter.getChapterNumber();

        Optional<Chapter> prevOpt = chapterRepository.findPreviousChapter(bookId, currentNum);
        Optional<Chapter> nextOpt = chapterRepository.findNextChapter(bookId, currentNum);

        String prevId = prevOpt.map(Chapter::getId).orElse(null);
        Integer prevNum = prevOpt.map(Chapter::getChapterNumber).orElse(null);
        String nextId = nextOpt.map(Chapter::getId).orElse(null);
        Integer nextNum = nextOpt.map(Chapter::getChapterNumber).orElse(null);

        return chapterMapper.toChapterDetailResponse(
                chapter,
                true,
                prevId,
                prevNum,
                nextId,
                nextNum
        );
    }

    @Transactional
    public UnlockResponse unlockChapter(String chapterId, String userId) {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new ResourceNotFoundException("Chapter", "id", chapterId));

        if (chapter.getIsFree()) {
            return UnlockResponse.builder()
                    .success(true)
                    .chapterId(chapterId)
                    .coinsDeducted(0)
                    .remainingCoins(0)
                    .message("Chapter is already free")
                    .build();
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));

        if (chapterRepository.isChapterUnlocked(userId, chapterId) > 0) {
            return UnlockResponse.builder()
                    .success(true)
                    .chapterId(chapterId)
                    .coinsDeducted(0)
                    .remainingCoins(user.getCoins())
                    .message("Chapter already unlocked")
                    .build();
        }

        int cost = chapter.getCoinCost() != null ? chapter.getCoinCost() : 10;
        int currentCoins = user.getCoins() != null ? user.getCoins() : 0;

        if (currentCoins < cost) {
            throw new BadRequestException("Insufficient coins to unlock chapter. Need " + cost + ", available: " + currentCoins);
        }

        // Deduct coins & record unlock
        user.setCoins(currentCoins - cost);
        userRepository.save(user);
        chapterRepository.unlockChapter(userId, chapterId);

        return UnlockResponse.builder()
                .success(true)
                .chapterId(chapterId)
                .coinsDeducted(cost)
                .remainingCoins(user.getCoins())
                .message("Chapter successfully unlocked")
                .build();
    }

    public boolean isChapterUnlocked(Chapter chapter, String userId) {
        if (Boolean.TRUE.equals(chapter.getIsFree())) {
            return true;
        }
        if (userId == null) {
            return false;
        }
        return chapterRepository.isChapterUnlocked(userId, chapter.getId()) > 0;
    }
}
