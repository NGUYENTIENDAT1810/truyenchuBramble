-- DESCRIBE bramble_db.books;
USE bramble_db;


-- Cấp 1 — SELECT cơ bản, WHERE, ORDER BY, LIMIT
-- 2. Tìm 10 sách có views_count cao nhất.
-- SELECT *
-- FROM books
-- ORDER BY views_count DESC;


-- 3. Đếm tổng số user có is_vip = true.
-- SELECT COUNT(*)
-- FROM users
-- WHERE is_vip = FALSE;


-- 4. Liệt kê chapter nào is_free = true và coin_cost = 0.
-- SELECT *
-- FROM chapters
-- WHERE is_free= TRUE && coin_cost = 0;

-- 5. Tìm sách có tên chứa chữ "Tình" (dùng LIKE).
-- SELECT *
-- FROM books
-- WHERE title LIKE '%3';


-- Cấp 2 — JOIN cơ bản
SELECT * FROM users;
SELECT * FROM books;
SELECT * FROM reading_history;
SELECT * FROM user_libraries;
-- 1. Liệt kê tên sách kèm tên tác giả (join books với authors).
SELECT books.title, authors.name
FROM books
INNER JOIN authors 
ON books.author_id = authors.id;

-- 2. Liệt kê tên chapter kèm tên sách nó thuộc về.
SELECT chapters.title, books.title
FROM chapters
INNER JOIN books
    ON chapters.book_id = books.id;

-- 3. Liệt kê comment kèm tên user viết comment đó và tên chapter được comment.
SELECT comments.content, users.display_name, chapters.title
FROM comments
INNER JOIN users
ON comments.user_id=users.id 
INNER JOIN chapters
ON comments.chapter_id = chapters.id;

-- 4. Với mỗi sách, liệt kê danh sách tên thể loại (join books → book_genres → genres).
SELECT books.title, genres.name
    FROM book_genres
INNER JOIN books
    ON book_genres.book_id = books.id
INNER JOIN genres
    ON book_genres.genre_id = genres.id;

-- 5. Liệt kê user và sách họ đang READING trong user_libraries.
SELECT users.display_name, books.title
FROM user_libraries ul
INNER JOIN users
ON ul.user_id = users.id
INNER JOIN books
ON ul.book_id = books.id
WHERE ul.status = 'READING';

