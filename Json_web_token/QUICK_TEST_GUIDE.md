# 🚀 HƯỚNG DẪN TEST NHANH ĐỒ ÁN SPRING BOOT JWT

## ⚡ TEST NHANH (5 PHÚT)

### Bước 1: Kiểm tra ứng dụng
```bash
# Chạy script test tự động
complete_test.bat
```

### Bước 2: Test giao diện
1. Mở browser: `http://localhost:8080/`
2. Click "Get Started" → Login page
3. Click "Use" bên cạnh "admin" → Auto fill credentials
4. Click "Sign In" → Redirect to dashboard

### Bước 3: Test dashboard
- ✅ Kiểm tra stats cards hiển thị
- ✅ Click "Call /api/test/user" → Success response
- ✅ Click "Call /api/test/admin" → Admin response
- ✅ Click "Call /api/test/public" → Public response

### Bước 4: Test profile
- Click "Profile" → Profile page
- ✅ Kiểm tra user info hiển thị
- ✅ Kiểm tra token info
- ✅ Test API buttons

## 🎯 TÀI KHOẢN TEST

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | ADMIN |
| test | test123 | USER |
| newuser123 | password123 | USER |

## ✅ CHECKLIST NHANH

### Frontend
- [ ] Trang chủ đẹp và responsive
- [ ] Login form hoạt động
- [ ] Dashboard hiển thị đúng
- [ ] Profile page quản lý token

### Authentication
- [ ] Đăng nhập thành công
- [ ] JWT token được tạo
- [ ] Protected endpoints hoạt động
- [ ] Admin endpoints chỉ cho ADMIN

### API
- [ ] Public API không cần auth
- [ ] User API cần authentication
- [ ] Admin API cần ADMIN role
- [ ] Error handling đúng

## 🚨 NẾU CÓ LỖI

1. **App không chạy:** `mvn spring-boot:run`
2. **Database lỗi:** Chạy `complete_database_setup.sql`
3. **Login lỗi:** Chạy `fix_all_passwords.sql`
4. **403 Forbidden:** Kiểm tra JWT token

## 🎉 KẾT QUẢ MONG ĐỢI

**Thành công:** Tất cả tests pass, giao diện đẹp, API hoạt động đúng  
**Lỗi:** Kiểm tra logs và fix theo hướng dẫn troubleshooting

---
**📚 Chi tiết:** Xem `TESTING_GUIDE.md` để test đầy đủ
