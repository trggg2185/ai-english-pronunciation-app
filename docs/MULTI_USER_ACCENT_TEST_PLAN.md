# 📊 KẾ HOẠCH KIỂM THỬ & ĐÁNH GIÁ ĐA GIỌNG NÓI (MULTI-USER & ACCENT TESTING PLAN)
> **Người thực hiện:** Nguyễn Đăng Đại  
> **Dự án:** Ứng dụng di động luyện phát âm tiếng Anh chuẩn AI (Nhóm 6)  
> **Phạm vi kiểm thử:** Module Chấm điểm Chi tiết, Nhận dạng Âm vị & Gợi ý Bài tập Khắc phục (Yêu cầu 5 & Yêu cầu 7)  

---

## 1. 🎯 MỤC TIÊU KIỂM THỬ (TEST OBJECTIVES)
1. **Đánh giá độ nhạy và chính xác của AI:** Xác định khả năng nhận diện các âm vị đặc thù mà người Việt hay phát âm sai (âm xát răng `/θ/`, `/ð/`, âm đuôi `/s/`, `/z/`, `/t/`, `/d/`, âm chu môi `/ʃ/`, `/tʃ/`, `/dʒ/`).
2. **Khảo sát tính chịu lỗi đối với đa dạng phương ngữ:** Kiểm tra độ chính xác của hệ thống khi tiếp nhận giọng nói từ 3 miền (Bắc, Trung, Nam) tại Việt Nam với các đặc trưng ngữ âm vùng miền khác nhau.
3. **Phân tầng trình độ người học:** So sánh độ chuẩn xác giữa nhóm Người mới bắt đầu (Beginner - hay nuốt âm, phát âm theo mặt chữ) và Nhóm có nền tảng (Intermediate - ngữ điệu tốt hơn nhưng còn vấp âm khó).
4. **Đo lường hiệu năng kỹ thuật:** Đánh giá độ trễ xử lý (Latency từ lúc kết thúc thu âm đến khi hiển thị giao diện phản hồi chi tiết), đảm bảo trải nghiệm người dùng tức thì (< 2.0s).

---

## 2. 👥 BỘ DỮ LIỆU MẪU NGƯỜI DÙNG (TEST DATASET - 5 PROFILES)

| ID | Người thử nghiệm | Vùng miền / Phương ngữ | Trình độ tiếng Anh | Đặc trưng ngữ âm tự nhiên | Thiết bị thử nghiệm |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **U01** | **Nguyễn Văn A** | Miền Bắc (Hà Nội) | Beginner (A1) | Có xu hướng lẫn lộn /l/ và /n/, thường nuốt âm đuôi /s/, /z/, phát âm /θ/ thành /t/. | Samsung Galaxy A54 (Android 14) |
| **U02** | **Trần Thị B** | Miền Trung (Huế/Đà Nẵng) | Beginner (A2) | Trọng âm hơi nặng, nguyên âm ngắn bị kéo dẹp, âm /ð/ thường biến thành /d/ nặng, âm đuôi /t/ bị ngắt hụt hơi. | Xiaomi Redmi Note 12 (Android 13) |
| **U03** | **Lê Hoàng C** | Miền Nam (TP. Hồ Chí Minh) | Intermediate (B1) | Giọng tự nhiên, ngữ điệu lướt nhanh nhưng hay nuốt phụ âm cuối /ks/, /ts/ (books, cats), /v/ hay thành /d/ hoặc /w/. | Google Pixel 7 (Android 14) |
| **U04** | **Phạm Minh D** | Miền Bắc (Hải Phòng) | Intermediate (B1+) | Phản xạ nói tốt, nhưng hay nhầm giữa /s/ và /ʃ/ (she likes -> see likes), âm /θ/ phát âm còn gượng gạo. | iPhone 13 (iOS 17.2) |
| **U05** | **Võ Hoài E** | Miền Trung (Nghệ An) | Beginner (A1) | Giọng trầm, âm lượng hơi nhỏ, các âm phụ âm xát (/f/, /v/, /θ/, /s/) thường bị giữ kín trong vòm họng, thiếu luồng hơi xì. | Oppo Reno 8 (Android 13) |

---

## 3. 📝 BỘ CÂU KIỂM THỬ TIÊU CHUẨN (BENCHMARK SENTENCES)

1. **Test Case 1 (Tập trung âm đuôi /s/, /ks/, /ts/):**  
   - Văn bản: *"She likes books and cats"*  
   - Phiên âm IPA chuẩn: `/ʃiː laɪks bʊks ænd kæts/`  
   - Trọng tâm kiểm tra: Âm đuôi số nhiều và chia động từ ngôi thứ 3.

2. **Test Case 2 (Tập trung âm xát răng /θ/ và /ð/):**  
   - Văn bản: *"Think through three thousand things"*  
   - Phiên âm IPA chuẩn: `/θɪŋk θruː θriː ˈθaʊznd θɪŋz/`  
   - Trọng tâm kiểm tra: Vị trí đặt đầu lưỡi giữa hai hàm răng và đẩy luồng hơi vô thanh.

3. **Test Case 3 (Câu giao tiếp tổng hợp đa âm):**  
   - Văn bản: *"Good morning, how are you today?"*  
   - Phiên âm IPA chuẩn: `/ɡʊd ˈmɔːrnɪŋ haʊ ɑːr juː təˈdeɪ/`  
   - Trọng tâm kiểm tra: Ngữ điệu chào hỏi, nối âm và nguyên âm đôi.

---

## 4. 📋 BẢNG MA TRẬN KIỂM THỬ CHI TIẾT (TEST MATRIX RESULTS)

| Người test | Câu kiểm thử | Âm vị trọng tâm | Điểm AI chấm | Phân loại trạng thái | Lỗi phát âm thực tế ghi nhận | Độ trễ (Latency) | Đánh giá & Khắc phục |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **U01** *(Bắc - Beginner)* | *"She likes books and cats"* | `/s/`, `/ks/`, `/ts/` | **42/100** | 🔴 `wrong` | Nuốt hoàn toàn âm đuôi `/s/` ở cả 3 từ *likes*, *books*, *cats*. | **1.24s** | UI hiển thị thẻ đỏ cảnh báo nuốt âm, đề xuất ngay 5 từ drill cho âm `/s/`. |
| **U01** *(Bắc - Beginner)* | *"Think through three thousand things"* | `/θ/` | **35/100** | 🔴 `wrong` | Phát âm *"Think"* thành *"Tink"*, *"Three"* thành *"Tree"*. Lưỡi thụt hoàn toàn trong khoang miệng. | **1.35s** | BottomSheet hướng dẫn đặt lưỡi giữa răng xuất hiện chính xác. |
| **U02** *(Trung - Beginner)* | *"She likes books and cats"* | `/s/`, `/d/` | **48/100** | 🔴 `wrong` | Bật được âm `/k/` nhưng âm `/s/` phía sau bị ngắt đột ngột; âm `/d/` trong *"and"* bị biến thành âm câm. | **1.18s** | Waveform người học hiển thị rõ biên độ đuôi sụt giảm 50% so với mẫu chuẩn bản ngữ. |
| **U02** *(Trung - Beginner)* | *"Think through three thousand things"* | `/θ/`, `/ð/` | **52/100** | 🟡 `acceptable` | Có ý thức thè lưỡi nhưng luồng hơi bị tắc, tạo thành âm tắc thay vì âm xát. | **1.42s** | AI phân loại `acceptable`, đưa vào danh sách ôn tập ưu tiên trung bình. |
| **U03** *(Nam - Intermediate)* | *"She likes books and cats"* | `/ks/`, `/ts/` | **74/100** | 🟡 `acceptable` | Phát âm được âm `/s/` nhưng bỏ quên âm tắc `/t/` đứng trước trong tổ hợp `/ts/` (*cats* -> *cas*). | **1.05s** | AI bắt chính xác âm `/t/` bị thiếu, hiển thị điểm thành phần 60%. |
| **U03** *(Nam - Intermediate)* | *"Good morning, how are you today?"* | Tổng thể câu | **88/100** | 🟢 `correct` | Ngữ điệu tự nhiên, nối âm mượt mà, điểm số tổng đạt loại Xuất sắc. | **0.98s** | Vòng tròn điểm số chuyển màu xanh lục, chúc mừng người học. |
| **U04** *(Bắc - Intermediate)* | *"She likes books and cats"* | `/ʃ/`, `/s/` | **79/100** | 🟡 `acceptable` | Âm `/ʃ/` trong *"She"* khẩu hình môi chưa đủ tròn, hơi bị bẹt sang `/s/`. | **1.12s** | Gợi ý bài tập hiển thị mẹo chu môi tròn về phía trước. |
| **U04** *(Bắc - Intermediate)* | *"Think through three thousand things"* | `/θ/` | **82/100** | 🟢 `correct` | Khẩu hình lưỡi đạt chuẩn, hơi xì đều, phân biệt tốt với âm /t/. | **1.15s** | Đạt chuẩn, hiển thị badge màu xanh lá. |
| **U05** *(Trung - Beginner)* | *"She likes books and cats"* | `/s/`, `/k/` | **38/100** | 🔴 `wrong` | Âm lượng mic nhỏ kèm nuốt âm kết thúc hoàn toàn. | **1.50s** | Hệ thống cảnh báo âm lượng và hướng dẫn khẩu hình chi tiết. |
| **U05** *(Trung - Beginner)* | *"Good morning, how are you today?"* | `/ɡ/`, `/d/`, `/ŋ/` | **62/100** | 🟡 `acceptable` | Âm `/d/` cuối trong *"Good"* bị ngắt cụt ngủn; âm `/ŋ/` trong *"morning"* chưa vang. | **1.30s** | Đề xuất bài tập luyện âm đuôi /d/ với từ *good, card, and*. |

---

## 5. 🔍 KẾT QUẢ PHÂN TÍCH & KẾT LUẬN (FINDINGS & RECOMMENDATIONS)

### 5.1. Tương quan theo vùng miền (Regional Findings)
1. **Người học miền Bắc:** Dễ đạt điểm cao ở các nguyên âm và phụ âm tắc (/t/, /k/, /p/), nhưng gặp thách thức lớn nhất ở **âm đuôi /s/, /z/** và **âm cong lưỡi /ʃ/** do thói quen phát âm bẹt miệng.
2. **Người học miền Trung:** Âm lượng phát âm thường đanh, âm tắc mạnh, dễ bị nhầm âm xát răng `/θ/` thành âm tắc `/t/` và nuốt âm hữu thanh `/ð/` thành `/d/` nặng. Khẩu hình hướng dẫn dạng trực quan bằng hình ảnh/vị trí lưỡi giúp khắc phục nhanh nhất.
3. **Người học miền Nam:** Tốc độ nói nhanh, lướt từ tốt, ngữ điệu phong phú nhưng hay gặp lỗi nuốt phụ âm cuối ở các cụm phụ âm đôi (`/ks/`, `/ts/`, `/nd/`).

### 5.2. Hiệu năng kỹ thuật (Latency & System Stability)
- **Độ trễ trung bình:** **1.23 giây** (đạt mục tiêu kỹ thuật đề ra < 2.0 giây).
- **Trực quan hóa UI:** 100% người dùng thử nghiệm hiểu ngay ý nghĩa 3 màu sắc (Xanh lá >= 80, Vàng >= 50, Đỏ < 50) mà không cần hướng dẫn bằng lời.
- **Tính năng chạm vào âm vị (Tap-to-guide):** Được đánh giá là tính năng hữu ích nhất khi 5/5 người dùng bấm vào xem khẩu hình lưỡi và bấm nghe lại phát âm mẫu để tự sửa sai.

