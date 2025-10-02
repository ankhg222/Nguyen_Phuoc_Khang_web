# 🧪 HƯỚNG DẪN TEST ĐỒ ÁN SPRING BOOT JWT

## 📋 TỔNG QUAN ĐỒ ÁN

**Đồ án:** Spring Boot JWT Authentication System  
**Công nghệ:** Spring Boot 3, Spring Security 6, JWT, SQL Server  
**Giao diện:** HTML5, CSS3, JavaScript ES6+ với thiết kế hiện đại  

## 🚀 BƯỚC 1: CHUẨN BỊ MÔI TRƯỜNG

### 1.1 Kiểm tra ứng dụng đang chạy
```bash
# Kiểm tra ứng dụng có chạy trên port 8080 không
curl http://localhost:8080/api/test/public
```

**Kết quả mong đợi:** "This is a public endpoint - no authentication required!"

### 1.2 Kiểm tra database
```bash
# Kiểm tra SQL Server có chạy không
sqlcmd -S localhost -U sa -P 1 -Q "SELECT COUNT(*) FROM users"
```

**Kết quả mong đợi:** Số lượng users trong database (khoảng 9 users)

## 🌐 BƯỚC 2: TEST GIAO DIỆN WEB

### 2.1 Test trang chủ
1. Mở browser và truy cập: `http://localhost:8080/`
2. **Kiểm tra:**
   - ✅ Trang chủ hiển thị đẹp với hero section
   - ✅ Features grid hiển thị 4 tính năng chính
   - ✅ Buttons "Get Started", "Try Public API", "API Documentation"
   - ✅ Tech stack section hiển thị các công nghệ
   - ✅ Responsive design trên mobile/desktop

### 2.2 Test trang đăng nhập
1. Click "Get Started" hoặc truy cập: `http://localhost:8080/login.html`
2. **Kiểm tra:**
   - ✅ Form đăng nhập với icons đẹp
   - ✅ Demo accounts section với 3 tài khoản
   - ✅ Loading animation khi đăng nhập
   - ✅ Error/success messages hiển thị đúng

### 2.3 Test đăng nhập với demo accounts
**Sử dụng các tài khoản có sẵn:**

| Username | Password | Role | Mô tả |
|----------|----------|------|-------|
| admin | admin123 | ADMIN | Quản trị viên |
| test | test123 | USER | User thường |
| newuser123 | password123 | USER | User mẫu |

**Cách test:**
1. Click button "Use" bên cạnh tài khoản muốn test
2. Username và password sẽ tự động điền vào form
3. Click "Sign In"
4. **Kết quả mong đợi:** Redirect đến dashboard với thông báo "Login successful!"

## 📊 BƯỚC 3: TEST DASHBOARD

### 3.1 Kiểm tra dashboard chính
Sau khi đăng nhập thành công, bạn sẽ được redirect đến: `http://localhost:8080/dashboard.html`

**Kiểm tra các thành phần:**
- ✅ **Header:** Hiển thị avatar, username, role, logout button
- ✅ **Stats Cards:** 4 cards hiển thị API Calls, Uptime, Users, Security
- ✅ **API Testing Cards:** 4 cards để test các endpoint

### 3.2 Test API endpoints từ dashboard

#### **Test User API:**
1. Click button "Call /api/test/user" trong User API card
2. **Kết quả mong đợi:** 
   ```json
   "Hello [username]! This is a protected endpoint for authenticated users."
   ```

#### **Test Admin API:**
1. Click button "Call /api/test/admin" trong Admin API card
2. **Kết quả mong đợi:**
   - **Với admin:** "Hello admin! This is an admin-only endpoint."
   - **Với user thường:** Error 403 Forbidden

#### **Test Public API:**
1. Click button "Call /api/test/public" trong Public API card
2. **Kết quả mong đợi:** "This is a public endpoint - no authentication required!"

#### **Test Token Refresh:**
1. Click button "Refresh Token" trong Token Refresh card
2. **Kết quả mong đợi:** "Token refreshed successfully!"

## 👤 BƯỚC 4: TEST PROFILE PAGE

### 4.1 Truy cập profile
1. Click "Profile" button trong header hoặc truy cập: `http://localhost:8080/profile.html`
2. **Kiểm tra:**
   - ✅ User profile information hiển thị đúng
   - ✅ Token information section
   - ✅ API testing buttons

### 4.2 Test token management
1. **Kiểm tra token info:**
   - ✅ Access Token hiển thị (50 ký tự đầu + "...")
   - ✅ Refresh Token hiển thị
   - ✅ Token Type: JWT
   - ✅ Expires In: 24 hours

2. **Test refresh token:**
   - Click "Refresh Token" button
   - **Kết quả mong đợi:** Token được cập nhật và hiển thị mới

## 🔧 BƯỚC 5: TEST TỰ ĐỘNG VỚI SCRIPTS

### 5.1 Test script Windows
```bash
# Chạy script test nhanh
quick_test.bat
```

**Kết quả mong đợi:**
- ✅ Application is running
- ✅ Public endpoint test passed
- ✅ Health check passed
- ✅ Admin login successful
- ✅ JWT token extracted
- ✅ Sample users login successful

### 5.2 Test script PowerShell
```bash
# Chạy script test chi tiết
.\test_app.ps1
```

**Kết quả mong đợi:**
- ✅ Tất cả tests pass
- ✅ Success rate: 100%
- ✅ Detailed test results

### 5.3 Test với Maven
```bash
# Chạy unit tests
mvn test
```

**Kết quả mong đợi:**
- ✅ All tests passed
- ✅ No compilation errors

## 🌐 BƯỚC 6: TEST API VỚI POSTMAN/CURL

### 6.1 Test đăng nhập API
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"usernameOrEmail":"admin","password":"admin123"}'
```

**Kết quả mong đợi:**
```json
{
  "accessToken": "eyJhbGciOiJIUzM4NCJ9...",
  "refreshToken": "eyJhbGciOiJIUzM4NCJ9...",
  "username": "admin",
  "email": "admin@example.com",
  "role": "ADMIN",
  "expiresIn": 86400000
}
```

### 6.2 Test protected endpoint
```bash
# Lấy token từ response trước
TOKEN="your_jwt_token_here"

curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/test/user
```

**Kết quả mong đợi:**
```json
"Hello admin! This is a protected endpoint for authenticated users."
```

### 6.3 Test unauthorized access
```bash
curl http://localhost:8080/api/test/user
```

**Kết quả mong đợi:** HTTP 403 Forbidden

## 🎯 BƯỚC 7: TEST CÁC TRƯỜNG HỢP LỖI

### 7.1 Test đăng nhập sai
1. Vào trang login
2. Nhập username: "admin", password: "wrongpassword"
3. Click "Sign In"
4. **Kết quả mong đợi:** Error message "Login failed. Please check your credentials."

### 7.2 Test truy cập không có token
1. Mở tab mới (private/incognito)
2. Truy cập: `http://localhost:8080/dashboard.html`
3. **Kết quả mong đợi:** Redirect về trang login

### 7.3 Test token hết hạn
1. Đăng nhập thành công
2. Chờ 24 giờ (hoặc modify token trong localStorage)
3. Thử gọi API
4. **Kết quả mong đợi:** Auto refresh token hoặc redirect login

## 📱 BƯỚC 8: TEST RESPONSIVE DESIGN

### 8.1 Test trên desktop
- ✅ Layout hiển thị đầy đủ
- ✅ Cards sắp xếp theo grid
- ✅ Hover effects hoạt động

### 8.2 Test trên tablet (768px)
- ✅ Layout responsive
- ✅ Cards stack vertically
- ✅ Touch-friendly buttons

### 8.3 Test trên mobile (< 480px)
- ✅ Single column layout
- ✅ Large touch targets
- ✅ Readable text sizes

## 🔍 BƯỚC 9: TEST PERFORMANCE

### 9.1 Test loading time
1. Mở Developer Tools (F12)
2. Vào tab Network
3. Refresh trang
4. **Kiểm tra:** Load time < 2 giây

### 9.2 Test API response time
1. Vào tab Network trong DevTools
2. Click các API buttons
3. **Kiểm tra:** Response time < 500ms

## ✅ CHECKLIST TEST HOÀN CHỈNH

### 🌐 Frontend Tests
- [ ] Trang chủ hiển thị đẹp và responsive
- [ ] Trang login hoạt động với demo accounts
- [ ] Dashboard hiển thị đúng thông tin user
- [ ] Profile page quản lý token đúng
- [ ] Navigation giữa các trang smooth
- [ ] Error messages hiển thị rõ ràng
- [ ] Loading states hoạt động

### 🔐 Authentication Tests
- [ ] Đăng nhập thành công với admin/test/newuser123
- [ ] JWT token được tạo và lưu đúng
- [ ] Protected endpoints yêu cầu authentication
- [ ] Admin endpoints chỉ cho ADMIN role
- [ ] Token refresh hoạt động
- [ ] Logout xóa token và redirect

### 🌐 API Tests
- [ ] Public API không cần authentication
- [ ] User API cần authentication
- [ ] Admin API cần ADMIN role
- [ ] Error handling đúng status codes
- [ ] Response format JSON đúng

### 📱 Responsive Tests
- [ ] Desktop layout (>= 768px)
- [ ] Tablet layout (480px - 768px)
- [ ] Mobile layout (< 480px)
- [ ] Touch interactions
- [ ] Font sizes readable

### ⚡ Performance Tests
- [ ] Page load time < 2s
- [ ] API response time < 500ms
- [ ] Smooth animations
- [ ] No memory leaks

## 🚨 TROUBLESHOOTING

### Lỗi thường gặp:

1. **"Application not running"**
   - **Giải pháp:** `mvn spring-boot:run`

2. **"Database connection failed"**
   - **Giải pháp:** Kiểm tra SQL Server service và chạy `complete_database_setup.sql`

3. **"Login failed"**
   - **Giải pháp:** Chạy `fix_all_passwords.sql` để cập nhật password hash

4. **"403 Forbidden"**
   - **Giải pháp:** Kiểm tra JWT token và role permissions

5. **"Page not found"**
   - **Giải pháp:** Kiểm tra SecurityConfig có permit all cho static files

## 🎉 KẾT LUẬN

Nếu tất cả tests pass → **Đồ án hoạt động hoàn hảo!** 🎯

**Điểm mạnh của đồ án:**
- ✅ Giao diện hiện đại và responsive
- ✅ Authentication/Authorization hoàn chỉnh
- ✅ Error handling tốt
- ✅ Performance cao
- ✅ Code structure clean
- ✅ Documentation đầy đủ

**Công nghệ được sử dụng:**
- 🚀 Spring Boot 3 + Spring Security 6
- 🔐 JWT Authentication
- 🗄️ SQL Server + JPA/Hibernate
- 🎨 Modern Frontend (HTML5/CSS3/JS)
- 📱 Responsive Design
- 🧪 Comprehensive Testing
