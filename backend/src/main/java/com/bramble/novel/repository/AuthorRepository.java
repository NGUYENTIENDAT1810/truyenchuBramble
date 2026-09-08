package com.bramble.novel.repository;

import com.bramble.novel.entity.Author;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AuthorRepository extends JpaRepository<Author, String> {
    Optional<Author> findByName(String name);

    @Query(value = "SELECT COUNT(*) > 0 FROM followed_authors WHERE user_id = :userId AND author_id = :authorId", nativeQuery = true)
    boolean isFollowingAuthor(@Param("userId") String userId, @Param("authorId") String authorId);

    @Modifying
    @Query(value = "INSERT INTO followed_authors (user_id, author_id) VALUES (:userId, :authorId) ON CONFLICT DO NOTHING", nativeQuery = true)
    void followAuthor(@Param("userId") String userId, @Param("authorId") String authorId);

    @Modifying
    @Query(value = "DELETE FROM followed_authors WHERE user_id = :userId AND author_id = :authorId", nativeQuery = true)
    void unfollowAuthor(@Param("userId") String userId, @Param("authorId") String authorId);
}
