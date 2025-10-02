# 🧪 CÁCH TEST ĐỒ ÁN SPRING BOOT JWT

## 🚀 Test Nhanh (1 phút)

### Bước 1: Chạy ứng dụng
```bash
mvn spring-boot:run
```

### Bước 2: Test cơ bản
```bash
# Windows
quick_test.bat

# Linux/Mac
chmod +x test_app.sh
./test_app.sh

# PowerShell
.\test_app.ps1
```

## 📋 Test Chi Tiết

### 1. Test Tự Động
- **Linux/Mac**: `./test_app.sh`
- **Windows**: `.\test_app.ps1`
- **Windows Batch**: `quick_test.bat`

### 2. Test Thủ Công
- **Postman**: Import file `test_requests.http`
- **VS Code**: Sử dụng REST Client extension
- **curl**: Copy commands từ `test_requests.http`

### 3. Test Unit Tests
```bash
mvn test
```

## 🎯 Các Test Cases Chính

### ✅ Authentication Tests
- [ ] Đăng ký user mới
- [ ] Đăng nhập với admin/test user
- [ ] JWT token được tạo đúng
- [ ] Login với password sai

### ✅ Authorization Tests  
- [ ] Public endpoint không cần auth
- [ ] Protected endpoint yêu cầu token
- [ ] Admin endpoint chỉ cho ADMIN
- [ ] Unauthorized access trả về 403

### ✅ API Tests
- [ ] Tất cả endpoints trả về đúng status
- [ ] Response format đúng JSON
- [ ] Error handling đúng

## 🔧 Tài Khoản Test

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | ADMIN |
| test | test123 | USER |
| newuser123 | password123 | USER |
| testuser4 | password123 | USER |

## 📊 Kết Quả Mong Đợi

### Thành công:
- ✅ Tất cả tests pass
- ✅ JWT token được tạo
- ✅ Protected endpoints hoạt động
- ✅ Error cases trả về đúng status

### Lỗi thường gặp:
- ❌ Database connection failed
- ❌ Application not running
- ❌ JWT token invalid
- ❌ CORS errors

## 🆘 Troubleshooting

1. **App không chạy**: `mvn spring-boot:run`
2. **Database lỗi**: Chạy `complete_database_setup.sql`
3. **Port bị chiếm**: Đổi port trong `application.properties`
4. **JWT lỗi**: Kiểm tra secret key

## 📁 Files Test

- `TEST_GUIDE.md` - Hướng dẫn chi tiết
- `test_app.sh` - Script test Linux/Mac
- `test_app.ps1` - Script test PowerShell
- `quick_test.bat` - Script test Windows Batch
- `test_requests.http` - HTTP requests cho Postman
- `src/test/` - Unit tests Java

## 🎉 Kết Luận

Nếu tất cả tests pass → Đồ án hoạt động đúng! 🎯
