package com.bramble.novel.repository;

import com.bramble.novel.entity.ReadingHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ReadingHistoryRepository extends JpaRepository<ReadingHistory, String> {

    Page<ReadingHistory> findByUserIdOrderByCreatedAtDesc(String userId, Pageable pageable);

    @Query("SELECT COALESCE(SUM(r.readingTimeSeconds), 0) FROM ReadingHistory r WHERE r.user.id = :userId")
    Long getTotalReadingTimeSeconds(@Param("userId") String userId);

    @Query("SELECT COUNT(DISTINCT r.chapter.id) FROM ReadingHistory r WHERE r.user.id = :userId")
    Long getDistinctChaptersReadCount(@Param("userId") String userId);
}
