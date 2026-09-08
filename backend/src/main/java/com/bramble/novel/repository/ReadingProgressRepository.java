package com.bramble.novel.repository;

import com.bramble.novel.entity.ReadingProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ReadingProgressRepository extends JpaRepository<ReadingProgress, String> {

    Optional<ReadingProgress> findByUserIdAndBookId(String userId, String bookId);

    Optional<ReadingProgress> findFirstByUserIdOrderByLastReadAtDesc(String userId);
}
