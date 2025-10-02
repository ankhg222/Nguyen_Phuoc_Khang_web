# 🧪 HƯỚNG DẪN TEST ĐỒ ÁN SPRING BOOT JWT

## 📋 Tổng quan
Đồ án Spring Boot với JWT Authentication có các tính năng chính:
- Đăng ký user mới
- Đăng nhập với JWT token
- Bảo vệ API endpoints
- Quản lý session với Redis

## 🚀 BƯỚC 1: CHUẨN BỊ MÔI TRƯỜNG

### 1.1 Cài đặt SQL Server
```bash
# Sử dụng Docker (khuyến nghị)
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=1" -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
```

### 1.2 Tạo Database
```bash
# Chạy script SQL
sqlcmd -S localhost -U sa -P 1 -i complete_database_setup.sql
```

### 1.3 Cài đặt Redis (tùy chọn)
```bash
# Docker
docker run -d -p 6379:6379 --name redis redis:latest
```

## 🔧 BƯỚC 2: CHẠY ỨNG DỤNG

### 2.1 Build và chạy
```bash
# Build project
mvn clean compile

# Chạy ứng dụng
mvn spring-boot:run
```

### 2.2 Kiểm tra ứng dụng đã chạy
- Truy cập: http://localhost:8080/api/test/public
- Kết quả mong đợi: "This is a public endpoint - no authentication required!"

## 🧪 BƯỚC 3: TEST TỰ ĐỘNG (Unit Tests)

### 3.1 Chạy tất cả tests
```bash
mvn test
```

### 3.2 Chạy test cụ thể
```bash
mvn test -Dtest=AuthControllerTest
```

### 3.3 Test coverage
```bash
mvn test jacoco:report
```

## 🌐 BƯỚC 4: TEST THỦ CÔNG VỚI API

### 4.1 Test đăng ký user mới

**Request:**
```bash
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
    "username": "testuser2024",
    "email": "testuser2024@example.com",
    "password": "password123"
}
```

**Response mong đợi:**
```json
{
    "username": "testuser2024",
    "email": "testuser2024@example.com",
    "role": "USER",
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### 4.2 Test đăng nhập

**Request:**
```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
    "usernameOrEmail": "admin",
    "password": "admin123"
}
```

**Response mong đợi:**
```json
{
    "username": "admin",
    "email": "admin@example.com",
    "role": "ADMIN",
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### 4.3 Test truy cập protected endpoint

**Request:**
```bash
GET http://localhost:8080/api/test/protected
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Response mong đợi:**
```json
{
    "message": "This is a protected endpoint!",
    "username": "admin",
    "authorities": ["ROLE_ADMIN"]
}
```

### 4.4 Test truy cập admin endpoint

**Request:**
```bash
GET http://localhost:8080/api/test/admin
Authorization: Bearer YOUR_JWT_TOKEN_HERE
```

**Response mong đợi:**
```json
{
    "message": "This is an admin-only endpoint!",
    "username": "admin",
    "role": "ADMIN"
}
```

## 🔍 BƯỚC 5: TEST CÁC TRƯỜNG HỢP LỖI

### 5.1 Test đăng ký với username đã tồn tại
```bash
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
    "username": "admin",
    "email": "newemail@example.com",
    "password": "password123"
}
```
**Kết quả mong đợi:** HTTP 400 Bad Request

### 5.2 Test đăng nhập với password sai
```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
    "usernameOrEmail": "admin",
    "password": "wrongpassword"
}
```
**Kết quả mong đợi:** HTTP 401 Unauthorized

### 5.3 Test truy cập protected endpoint không có token
```bash
GET http://localhost:8080/api/test/protected
```
**Kết quả mong đợi:** HTTP 403 Forbidden

### 5.4 Test truy cập admin endpoint với user thường
```bash
GET http://localhost:8080/api/test/admin
Authorization: Bearer USER_JWT_TOKEN
```
**Kết quả mong đợi:** HTTP 403 Forbidden

## 📊 BƯỚC 6: TEST PERFORMANCE

### 6.1 Test load với nhiều request đồng thời
```bash
# Sử dụng Apache Bench
ab -n 1000 -c 10 http://localhost:8080/api/test/public
```

### 6.2 Test response time
```bash
# Sử dụng curl với time
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:8080/api/test/public
```

## 🎯 BƯỚC 7: TEST TÍNH NĂNG ĐẶC BIỆT

### 7.1 Test JWT token expiration
- Đăng nhập và lấy token
- Chờ token hết hạn (24 giờ)
- Thử sử dụng token đã hết hạn

### 7.2 Test refresh token
```bash
POST http://localhost:8080/api/auth/refresh
Content-Type: application/json

{
    "refreshToken": "YOUR_REFRESH_TOKEN"
}
```

### 7.3 Test logout
```bash
POST http://localhost:8080/api/auth/logout
Authorization: Bearer YOUR_JWT_TOKEN
```

## 📱 BƯỚC 8: TEST FRONTEND (Nếu có)

### 8.1 Test login page
- Truy cập: http://localhost:8080/login.html
- Test đăng nhập với các tài khoản mẫu

### 8.2 Test profile page
- Truy cập: http://localhost:8080/profile.html
- Kiểm tra hiển thị thông tin user

## 🔧 BƯỚC 9: DEBUG VÀ LOGGING

### 9.1 Kiểm tra logs
```bash
# Xem logs real-time
tail -f logs/spring-boot.log
```

### 9.2 Debug mode
- Thêm `logging.level.vn.hcmute=DEBUG` vào application.properties
- Restart ứng dụng và kiểm tra logs

## 📋 CHECKLIST TEST HOÀN CHỈNH

### ✅ Database Tests
- [ ] Database connection thành công
- [ ] Tables được tạo đúng
- [ ] Sample data được insert
- [ ] Stored procedures hoạt động

### ✅ Authentication Tests
- [ ] Đăng ký user mới thành công
- [ ] Đăng ký với username trùng lặp báo lỗi
- [ ] Đăng nhập thành công
- [ ] Đăng nhập với password sai báo lỗi
- [ ] JWT token được tạo đúng format

### ✅ Authorization Tests
- [ ] Public endpoint không cần authentication
- [ ] Protected endpoint yêu cầu authentication
- [ ] Admin endpoint chỉ cho phép ADMIN role
- [ ] Token hết hạn trả về 401

### ✅ API Tests
- [ ] Tất cả endpoints trả về đúng status code
- [ ] Response format đúng JSON
- [ ] Error handling đúng
- [ ] CORS headers đúng (nếu cần)

### ✅ Performance Tests
- [ ] Response time < 200ms cho public endpoints
- [ ] Response time < 500ms cho protected endpoints
- [ ] Ứng dụng xử lý được concurrent requests

## 🚨 TROUBLESHOOTING

### Lỗi thường gặp:

1. **Database connection failed**
   - Kiểm tra SQL Server service
   - Kiểm tra username/password
   - Kiểm tra port 1433

2. **JWT token invalid**
   - Kiểm tra JWT secret key
   - Kiểm tra token format
   - Kiểm tra token expiration

3. **CORS errors**
   - Thêm CORS configuration
   - Kiểm tra allowed origins

4. **Redis connection failed**
   - Kiểm tra Redis service
   - Kiểm tra Redis configuration

## 📞 HỖ TRỢ

Nếu gặp vấn đề trong quá trình test:
1. Kiểm tra logs của ứng dụng
2. Kiểm tra logs của database
3. Kiểm tra network connectivity
4. Tham khảo documentation Spring Security và JWT
