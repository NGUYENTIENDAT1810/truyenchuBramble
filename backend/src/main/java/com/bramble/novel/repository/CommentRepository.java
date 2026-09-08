package com.bramble.novel.repository;

import com.bramble.novel.entity.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, String> {

    List<Comment> findByChapterIdAndParentIsNullOrderByLikesCountDesc(String chapterId);

    Page<Comment> findByChapterIdAndParentIsNullOrderByCreatedAtDesc(String chapterId, Pageable pageable);

    Page<Comment> findByChapterIdAndParagraphIndexOrderByCreatedAtDesc(String chapterId, Integer paragraphIndex, Pageable pageable);

    List<Comment> findByParentIdOrderByCreatedAtAsc(String parentId);

    long countByChapterId(String chapterId);
}
