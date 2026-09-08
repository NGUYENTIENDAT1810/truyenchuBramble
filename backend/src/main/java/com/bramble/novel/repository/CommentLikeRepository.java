package com.bramble.novel.repository;

import com.bramble.novel.entity.CommentLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CommentLikeRepository extends JpaRepository<CommentLike, CommentLike.CommentLikeId> {

    Optional<CommentLike> findByUserIdAndCommentId(String userId, String commentId);

    boolean existsByUserIdAndCommentId(String userId, String commentId);

    void deleteByUserIdAndCommentId(String userId, String commentId);

    @Modifying
    @Query(value = "INSERT INTO comment_likes (user_id, comment_id) VALUES (:userId, :commentId) ON CONFLICT DO NOTHING", nativeQuery = true)
    void addLike(@Param("userId") String userId, @Param("commentId") String commentId);
}
