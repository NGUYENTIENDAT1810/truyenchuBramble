package com.bramble.novel.repository;

import com.bramble.novel.entity.Chapter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter, String> {

    List<Chapter> findByBookIdOrderByChapterNumberAsc(String bookId);

    List<Chapter> findByBookIdOrderByChapterNumberDesc(String bookId);

    Optional<Chapter> findByBookIdAndChapterNumber(String bookId, Integer chapterNumber);

    @Query(value = "SELECT * FROM chapters WHERE book_id = :bookId AND chapter_number < :chapterNumber ORDER BY chapter_number DESC LIMIT 1", nativeQuery = true)
    Optional<Chapter> findPreviousChapter(@Param("bookId") String bookId, @Param("chapterNumber") Integer chapterNumber);

    @Query(value = "SELECT * FROM chapters WHERE book_id = :bookId AND chapter_number > :chapterNumber ORDER BY chapter_number ASC LIMIT 1", nativeQuery = true)
    Optional<Chapter> findNextChapter(@Param("bookId") String bookId, @Param("chapterNumber") Integer chapterNumber);

    @Query(value = "SELECT COUNT(*) FROM unlocked_chapters WHERE user_id = :userId AND chapter_id = :chapterId", nativeQuery = true)
    long isChapterUnlocked(@Param("userId") String userId, @Param("chapterId") String chapterId);

    @Modifying
    @Query(value = "INSERT IGNORE INTO unlocked_chapters (user_id, chapter_id) VALUES (:userId, :chapterId)", nativeQuery = true)
    void unlockChapter(@Param("userId") String userId, @Param("chapterId") String chapterId);

    long countByBookId(String bookId);
}
