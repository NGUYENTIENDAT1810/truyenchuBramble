package com.bramble.novel.repository;

import com.bramble.novel.entity.Library;
import com.bramble.novel.entity.LibraryStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LibraryRepository extends JpaRepository<Library, String> {

    List<Library> findByUserIdOrderByUpdatedAtDesc(String userId);

    List<Library> findByUserIdAndStatusOrderByUpdatedAtDesc(String userId, LibraryStatus status);

    List<Library> findByUserIdAndIsDownloadedTrueOrderByUpdatedAtDesc(String userId);

    Optional<Library> findByUserIdAndBookId(String userId, String bookId);

    boolean existsByUserIdAndBookId(String userId, String bookId);

    long countByUserIdAndStatus(String userId, LibraryStatus status);

    void deleteByUserIdAndBookId(String userId, String bookId);
}
