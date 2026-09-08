package com.bramble.novel.repository;

import com.bramble.novel.entity.Book;
import com.bramble.novel.entity.BookStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookRepository extends JpaRepository<Book, String> {

    Optional<Book> findBySlug(String slug);

    List<Book> findByAuthorId(String authorId);

    @Query("SELECT b FROM Book b WHERE " +
           "LOWER(b.title) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(b.description) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(b.author.name) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Book> searchBooks(@Param("search") String search, Pageable pageable);

    @Query("SELECT b FROM Book b JOIN b.genres g WHERE LOWER(g.slug) = LOWER(:genreSlug)")
    Page<Book> findByGenreSlug(@Param("genreSlug") String genreSlug, Pageable pageable);

    Page<Book> findByStatus(BookStatus status, Pageable pageable);

    List<Book> findByIsFeaturedTrue();

    List<Book> findByIsTrendingTrue();

    List<Book> findByIsNewReleaseTrue();
}
