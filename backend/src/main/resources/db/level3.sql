USE bramble_db;

SELECT * FROM chapters;
SELECT * FROM comments;
SELECT * FROM books;
-- Cấp 3 — GROUP BY, aggregate
-- 1. Đếm số sách theo từng status (ONGOING/COMPLETED/DRAFT).
SELECT books.status, COUNT(*)
FROM books
GROUP BY books.status;

-- 2. Mỗi tác giả có bao nhiêu sách? Sắp xếp giảm dần.
SELECT authors.name, COUNT(*) tong
FROM authors
INNER JOIN books
ON books.author_id = authors.id
GROUP BY authors.id
ORDER BY tong DESC;

-- 3. Mỗi thể loại (genres) có bao nhiêu sách? (dùng book_genres)
SELECT genres.name, COUNT(*) soluongsach
FROM book_genres bg
INNER JOIN books
    ON bg.book_id = books.id
INNER JOIN genres
    ON bg.genre_id = genres.id
GROUP BY genres.id;


-- 4. Tính tổng likes_count của comment theo từng chapter, chỉ lấy chapter có tổng like > 50.
-- (Bổ sung thêm sắp xếp số lượng giảm dần và hiển thị tên sách của chapter đó)
SELECT books.title,chapters.title, SUM(comments.likes_count) clc
FROM chapters
INNER JOIN comments ON comments.chapter_id =chapters.id
INNER JOIN books ON books.id =chapters.book_id
GROUP BY chapters.id
HAVING clc > 50
ORDER BY clc DESC;

-- 4.1. Nâng cao hơn chút -> liệt kê 1 quyẻn sách có bao nhiêu chương và liệt kê tổng số like của quyển sách đó
SELECT books.title, COUNT(DISTINCT chapters.id) SoLuongChuong, COUNT(*) SoLuongComment ,SUM(comments.likes_count) SoLuongLikeTruyen
FROM chapters
INNER JOIN comments ON comments.chapter_id =chapters.id
INNER JOIN books ON books.id =chapters.book_id
GROUP BY books.id
HAVING SoLuongLikeTruyen > 50
ORDER BY SoLuongLikeTruyen DESC;

-- 5. Trung bình rating của sách theo từng tác giả, chỉ hiện tác giả có ≥ 3 sách (dùng HAVING).
SELECT authors.name TenTacGia, AVG(books.rating) DanhGiaTrungBinh
FROM books
INNER JOIN authors on authors.id = books.author_id
GROUP BY authors.id
HAVING COUNT(*) > 2

