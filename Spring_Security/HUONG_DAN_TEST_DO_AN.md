# 🧪 HƯỚNG DẪN TEST ĐỒ ÁN SPRING SECURITY

## 📋 **Tổng Quan**
Đồ án Spring Security đã hoàn thành đầy đủ 4 demo. Dưới đây là hướng dẫn test từng demo một cách chi tiết.

## 🚀 **Bước 1: Khởi Động Ứng Dụng**

### 1.1. Kiểm tra SQL Server
```bash
# Kiểm tra SQL Server đang chạy
sqlcmd -S localhost -U sa -P 1 -Q "SELECT @@VERSION"
```

### 1.2. Chạy ứng dụng
```bash
# Trong thư mục project
mvn spring-boot:run
```

### 1.3. Kiểm tra ứng dụng đã chạy
- Truy cập: `http://localhost:8080`
- Nếu thành công sẽ thấy trang đăng nhập

## 🔐 **Bước 2: Test Authentication & Authorization**

### 2.1. Tài khoản có sẵn
```
Admin: admin@demo.com / admin123 (ROLE_ADMIN)
User:  user@demo.com / user123 (ROLE_USER)  
Demo:  demo@demo.com / demo123 (ROLE_USER)
```

### 2.2. Test đăng nhập
1. Truy cập `http://localhost:8080/login`
2. Đăng nhập với từng tài khoản
3. Kiểm tra redirect sau khi đăng nhập thành công

## 📊 **Bước 3: Test Demo 1 - Spring Security Cơ Bản**

### 3.1. Test endpoints không cần đăng nhập
- **URL:** `http://localhost:8080/hello`
- **Kết quả mong đợi:** Hiển thị trang hello với thông tin user

### 3.2. Test endpoints cần đăng nhập
- **URL:** `http://localhost:8080/customer/all`
- **Test với ROLE_USER:** Phải bị chặn (403)
- **Test với ROLE_ADMIN:** Phải truy cập được

- **URL:** `http://localhost:8080/customer/001`
- **Test với ROLE_USER:** Phải truy cập được
- **Test với ROLE_ADMIN:** Phải truy cập được

### 3.3. Test phân quyền
1. Đăng nhập với `user@demo.com`
2. Thử truy cập `/customer/all` → Phải bị chặn
3. Đăng xuất và đăng nhập với `admin@demo.com`
4. Thử truy cập `/customer/all` → Phải thành công

## 🗄️ **Bước 4: Test Demo 2 - Database Integration**

### 4.1. Kiểm tra database
```bash
# Kiểm tra users trong database
sqlcmd -S localhost -U sa -P 1 -d spring_security_final -Q "SELECT id, name, username, email, roles FROM user_info;"
```

### 4.2. Test đăng ký user mới qua API
```bash
# Sử dụng Postman hoặc curl
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "username": "testuser",
    "email": "test@example.com",
    "password": "test123"
  }'
```

### 4.3. Kiểm tra user mới trong database
```bash
sqlcmd -S localhost -U sa -P 1 -d spring_security_final -Q "SELECT * FROM user_info WHERE email = 'test@example.com';"
```

## 🎨 **Bước 5: Test Demo 3 - Thymeleaf UI**

### 5.1. Test trang chủ
- **URL:** `http://localhost:8080/`
- **Kết quả:** Hiển thị danh sách sản phẩm với UI đẹp

### 5.2. Test CRUD sản phẩm (với ADMIN)
1. Đăng nhập với `admin@demo.com`
2. **Tạo sản phẩm mới:**
   - URL: `http://localhost:8080/new`
   - Điền thông tin và submit
   - Kiểm tra sản phẩm xuất hiện trong danh sách

3. **Sửa sản phẩm:**
   - Click "Sửa" trên sản phẩm bất kỳ
   - Thay đổi thông tin và save
   - Kiểm tra thay đổi được lưu

4. **Xóa sản phẩm:**
   - Click "Xóa" trên sản phẩm bất kỳ
   - Confirm dialog
   - Kiểm tra sản phẩm bị xóa

### 5.3. Test phân quyền UI
1. Đăng nhập với `user@demo.com`
2. Kiểm tra:
   - Không thấy nút "Tạo Sản Phẩm Mới"
   - Không thấy nút "Sửa" và "Xóa"
   - Chỉ thấy danh sách sản phẩm

### 5.4. Test trang 403
1. Đăng nhập với `user@demo.com`
2. Truy cập trực tiếp: `http://localhost:8080/new`
3. Phải redirect đến trang 403 với UI đẹp

## 📄 **Bước 6: Test Demo 4 - JSP/JSTL**

### 6.1. Test trang chủ JSP
- **URL:** `http://localhost:8080/jsp`
- **Kết quả:** Hiển thị trang chủ JSP với danh sách sản phẩm

### 6.2. Test các trang JSP
1. **Trang đăng nhập JSP:**
   - URL: `http://localhost:8080/jsp/login`
   - Test đăng nhập với các tài khoản

2. **Trang đăng ký JSP:**
   - URL: `http://localhost:8080/jsp/register`
   - Test đăng ký user mới

3. **Trang khách hàng JSP:**
   - URL: `http://localhost:8080/jsp/customer`
   - Hiển thị danh sách users

4. **Trang sản phẩm JSP:**
   - URL: `http://localhost:8080/jsp/products`
   - Hiển thị danh sách sản phẩm với JSTL

5. **Trang admin JSP (chỉ ADMIN):**
   - URL: `http://localhost:8080/jsp/admin`
   - Test với ROLE_USER: Phải bị chặn
   - Test với ROLE_ADMIN: Phải truy cập được

6. **Trang tổng kết:**
   - URL: `http://localhost:8080/jsp/summary`
   - Hiển thị tổng kết 4 demo

### 6.3. Test JSTL Security Tags
1. Đăng nhập với các role khác nhau
2. Kiểm tra các element UI hiển thị/ẩn theo role
3. Kiểm tra thông tin user hiển thị đúng

## 🔍 **Bước 7: Test Tổng Hợp**

### 7.1. Test flow hoàn chỉnh
1. **Không đăng nhập:**
   - Truy cập `/` → Redirect đến `/login`
   - Truy cập `/hello` → Cho phép
   - Truy cập `/customer/all` → Redirect đến `/login`

2. **Đăng nhập USER:**
   - Truy cập `/` → Hiển thị trang chủ (không có nút tạo/sửa/xóa)
   - Truy cập `/customer/all` → 403
   - Truy cập `/customer/001` → Thành công
   - Truy cập `/jsp/admin` → 403

3. **Đăng nhập ADMIN:**
   - Truy cập `/` → Hiển thị trang chủ (có đầy đủ nút)
   - Truy cập `/customer/all` → Thành công
   - Truy cập `/jsp/admin` → Thành công
   - Test CRUD sản phẩm → Thành công

### 7.2. Test đăng xuất
1. Click "Đăng Xuất" trên bất kỳ trang nào
2. Kiểm tra redirect về trang login
3. Thử truy cập trang protected → Phải redirect đến login

## 🐛 **Bước 8: Test Error Handling**

### 8.1. Test trang 403
1. Đăng nhập với ROLE_USER
2. Truy cập các URL chỉ dành cho ADMIN
3. Kiểm tra hiển thị trang 403 với UI đẹp

### 8.2. Test đăng nhập sai
1. Nhập sai email/password
2. Kiểm tra hiển thị thông báo lỗi
3. Kiểm tra không redirect

## 📱 **Bước 9: Test Responsive UI**

### 9.1. Test trên desktop
- Kiểm tra UI hiển thị đẹp trên màn hình lớn

### 9.2. Test trên mobile
- Mở Developer Tools → Device Mode
- Kiểm tra UI responsive trên các kích thước màn hình

## ✅ **Bước 10: Checklist Hoàn Thành**

### Demo 1 ✅
- [ ] `/hello` không cần login
- [ ] `/customer/all` cần ROLE_ADMIN
- [ ] `/customer/001` cần ROLE_USER
- [ ] Form login hoạt động

### Demo 2 ✅
- [ ] Database connection thành công
- [ ] Users được tạo trong database
- [ ] API đăng ký hoạt động
- [ ] Password được mã hóa BCrypt

### Demo 3 ✅
- [ ] Trang chủ hiển thị sản phẩm
- [ ] CRUD sản phẩm với ADMIN
- [ ] Phân quyền UI với Thymeleaf
- [ ] Trang 403 đẹp

### Demo 4 ✅
- [ ] Tất cả trang JSP hoạt động
- [ ] JSTL security tags hoạt động
- [ ] Phân quyền JSP đúng
- [ ] Trang tổng kết hiển thị đầy đủ

## 🎯 **Kết Luận**

Nếu tất cả các test trên đều pass, đồ án Spring Security đã được thực hiện thành công và đầy đủ 4 demo theo yêu cầu!

**Lưu ý:** Nếu gặp lỗi, kiểm tra:
1. SQL Server đang chạy
2. Database `spring_security_final` đã được tạo
3. Port 8080 không bị chiếm dụng
4. Tất cả dependencies đã được cài đặt
