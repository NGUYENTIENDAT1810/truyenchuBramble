SQL luyện tập trên schema bramble_db
Cấp 1 — SELECT cơ bản, WHERE, ORDER BY, LIMIT
1. Liệt kê tên và slug của tất cả sách có status = ONGOING.
2. Tìm 10 sách có views_count cao nhất.
3. Đếm tổng số user có is_vip = true.
4. Liệt kê chapter nào is_free = true và coin_cost = 0.
5. Tìm sách có tên chứa chữ "Tình" (dùng LIKE).
Cấp 2 — JOIN cơ bản
1. Liệt kê tên sách kèm tên tác giả (join books với authors).
2. Liệt kê tên chapter kèm tên sách nó thuộc về.
3. Liệt kê comment kèm tên user viết comment đó và tên chapter được comment.
4. Với mỗi sách, liệt kê danh sách tên thể loại (join books → book_genres → genres).
5. Liệt kê user và sách họ đang READING trong user_libraries.
Cấp 3 — GROUP BY, aggregate
1. Đếm số sách theo từng status (ONGOING/COMPLETED/DRAFT).
2. Mỗi tác giả có bao nhiêu sách? Sắp xếp giảm dần.
3. Mỗi thể loại (genres) có bao nhiêu sách? (dùng book_genres)
4. Tính tổng likes_count của comment theo từng chapter, chỉ lấy chapter có tổng like > 50.
5. Trung bình rating của sách theo từng tác giả, chỉ hiện tác giả có ≥ 3 sách (dùng HAVING).
Cấp 4 — Subquery, nâng cao hơn
1. Tìm sách có views_count cao hơn trung bình toàn bộ sách.
2. Tìm user chưa từng comment lần nào (dùng NOT IN hoặc LEFT JOIN ... IS NULL).
3. Tìm tác giả có sách nhưng chưa tác giả nào có sách is_featured = true (subquery phủ định).
4. Với mỗi sách, tìm chapter mới nhất (MAX(chapter_number)) — dùng subquery tương quan hoặc window function.
5. Top 5 user đọc nhiều nhất (dựa vào reading_history, đếm số dòng theo user_id).
Cấp 5 — Window function, CTE (khó)
1. Xếp hạng (RANK()) sách theo views_count trong từng status.
2. Tính % đóng góp view của mỗi sách so với tổng view toàn hệ thống (SUM() OVER()).
3. Dùng CTE tìm 3 sách có rating cao nhất mỗi tác giả (ROW_NUMBER() OVER (PARTITION BY author_id ORDER BY rating DESC)).
4. Tính số comment theo từng ngày trong 30 ngày gần nhất, kèm running total (SUM() OVER (ORDER BY ngày)).
5. Tìm cặp user có cùng đang đọc chung ít nhất 1 sách (self-join trên user_libraries).
Cấp 6 — Thực chiến (gần business thật)
1. "Trending score" đơn giản: views_count / (DATEDIFF(NOW(), created_at) + 1), lấy top 10.
2. Với mỗi sách, tính tỉ lệ hoàn thành trung bình của user đang đọc (AVG(progress_percent) từ reading_progress).
3. Tìm chapter bị khóa (coin_cost > 0) nhưng chưa ai từng đọc (không xuất hiện trong reading_history).
4. Liệt kê top 5 sách có tốc độ tăng comment nhanh nhất trong 7 ngày gần đây so với 7 ngày trước đó.
5. Viết 1 query tổng hợp: mỗi tác giả → số sách, tổng view, rating trung bình, tổng comment nhận được trên toàn bộ sách của họ — 1 dòng/tác giả.
Làm từ đầu xuống, câu nào bí báo tôi gợi ý hoặc chấm bài giúp.