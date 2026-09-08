package com.bramble.novel.repository;

import com.bramble.novel.entity.Genre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GenreRepository extends JpaRepository<Genre, String> {
    Optional<Genre> findByName(String name);
    Optional<Genre> findBySlug(String slug);
}
