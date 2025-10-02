# 🚀 Quick Start Guide - SpringBoot_1001

## Bước 1: Cài đặt SQL Server

### Tùy chọn A: Docker (Khuyến nghị)

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=123456" -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
```

### Tùy chọn B: SQL Server Express

1. Tải từ: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
2. Cài đặt với Mixed Mode Authentication
3. Đặt password cho user `sa` là `123456`

## Bước 2: Tạo database

### Cách 1: Chạy script tự động

```cmd
# Windows Command Prompt
setup_database.bat

# Windows PowerShell
.\setup_database.ps1
```

### Cách 2: Chạy thủ công

```cmd
sqlcmd -S localhost -U sa -P 123456 -i database_setup.sql
```

## Bước 3: Chạy ứng dụng

```cmd
mvn spring-boot:run
```

## Bước 4: Kiểm tra ứng dụng

Mở browser và truy cập:

- http://localhost:8080/api/test/public
- http://localhost:8080/api/test/protected

## 🔧 API Endpoints

### 1. Đăng ký user mới

```bash
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
    "username": "newuser",
    "email": "newuser@example.com",
    "password": "password123"
}
```

### 2. Đăng nhập

```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
    "usernameOrEmail": "admin",
    "password": "admin123"
}
```

### 3. Truy cập protected endpoint

```bash
GET http://localhost:8080/api/test/protected
Authorization: Bearer YOUR_JWT_TOKEN
```

## 🧪 Test với dữ liệu mẫu

Sau khi chạy database setup, bạn có thể test với:

- **Admin user**: `admin` / `admin123`
- **Test user**: `test` / `test123`

## 📁 Cấu trúc project

```
SpringBoot_1001/
├── src/main/java/vn/hcmute/
│   ├── entity/User.java
│   ├── repository/UserRepository.java
│   ├── service/AuthService.java
│   ├── service/CustomUserDetailsService.java
│   ├── controller/AuthController.java
│   ├── controller/TestController.java
│   ├── security/JwtAuthenticationFilter.java
│   ├── config/SecurityConfig.java
│   ├── util/JwtUtil.java
│   └── dto/
├── src/main/resources/
│   └── application.properties
├── database_setup.sql
├── setup_database.bat
├── setup_database.ps1
└── README.md
```

## 🐛 Troubleshooting

### Lỗi kết nối database

1. Kiểm tra SQL Server service có chạy không
2. Kiểm tra port 1433 có mở không
3. Kiểm tra username/password

### Lỗi 404 Not Found

1. Kiểm tra ứng dụng có chạy không
2. Kiểm tra endpoint URL có đúng không
3. Kiểm tra database có được tạo không

### Lỗi authentication

1. Kiểm tra JWT token có hợp lệ không
2. Kiểm tra user có tồn tại trong database không
3. Kiểm tra password có đúng không

## 📞 Hỗ trợ

Nếu gặp vấn đề, hãy kiểm tra:

1. Logs của ứng dụng Spring Boot
2. Logs của SQL Server
3. Network connectivity
4. Firewall settings

## 🎯 Next Steps

1. Tùy chỉnh cấu hình JWT
2. Thêm validation cho input
3. Thêm logging
4. Thêm unit tests
5. Deploy lên production
