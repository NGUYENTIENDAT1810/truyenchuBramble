-- V3__create_user_libraries.sql: Create user_libraries table for book library management
CREATE TABLE IF NOT EXISTS user_libraries (
    id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    book_id VARCHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'READING',
    is_downloaded BIT(1) DEFAULT b'0',
    last_read_at DATETIME(6) DEFAULT NULL,
    created_at DATETIME(6) DEFAULT NULL,
    updated_at DATETIME(6) DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_user_book_library (user_id, book_id),
    KEY idx_user_libraries_user (user_id),
    KEY idx_user_libraries_book (book_id),
    CONSTRAINT fk_user_libraries_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_user_libraries_book FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
