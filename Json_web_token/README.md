# Spring Boot 1001 - Spring Security 6 & JWT Implementation

Dự án này triển khai Spring Security 6 với JWT Authentication và Authorization.

## Tính năng

- ✅ Spring Security 6 Configuration
- ✅ JWT Authentication & Authorization
- ✅ User Registration & Login
- ✅ Role-based Access Control (USER, ADMIN, MODERATOR)
- ✅ Refresh Token Support
- ✅ CORS Configuration
- ✅ Password Encryption (BCrypt)
- ✅ Database Integration (SQL Server)
- ✅ Unit Tests

## API Endpoints

### Authentication

- `POST /api/auth/register` - Đăng ký user mới
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/refresh` - Làm mới token
- `GET /api/auth/public/health` - Kiểm tra trạng thái service

### Test Endpoints

- `GET /api/test/public` - Endpoint công khai (không cần authentication)
- `GET /api/test/user` - Endpoint cho user đã đăng nhập
- `GET /api/test/admin` - Endpoint chỉ dành cho ADMIN
- `GET /api/test/moderator` - Endpoint chỉ dành cho MODERATOR
- `GET /api/test/profile` - Lấy thông tin profile của user hiện tại

## Cấu hình

### Database

- SQL Server (Production)
- H2 (Testing)

### JWT Configuration

- Secret Key: `404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970`
- Access Token Expiration: 24 hours
- Refresh Token Expiration: 7 days

## Cách sử dụng

### 1. Đăng ký user mới

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 2. Đăng nhập

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

### 3. Truy cập endpoint được bảo vệ

```bash
curl -X GET http://localhost:8080/api/test/user \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Làm mới token

```bash
curl -X POST http://localhost:8080/api/auth/refresh?refreshToken=YOUR_REFRESH_TOKEN
```

## Cấu trúc dự án

```
src/main/java/vn/hcmute/
├── config/
│   └── SecurityConfig.java          # Cấu hình Spring Security
├── controller/
│   ├── AuthController.java          # Controller cho authentication
│   └── TestController.java          # Controller test các endpoint
├── dto/
│   ├── AuthRequest.java             # DTO cho đăng ký
│   ├── AuthResponse.java            # DTO cho response
│   └── LoginRequest.java            # DTO cho đăng nhập
├── entity/
│   └── User.java                    # User entity với UserDetails
├── repository/
│   └── UserRepository.java          # Repository cho User
├── security/
│   └── JwtAuthenticationFilter.java # JWT Filter
├── service/
│   ├── AuthService.java             # Service cho authentication
│   └── CustomUserDetailsService.java # UserDetailsService
└── util/
    └── JwtUtil.java                 # Utility cho JWT
```

## Chạy ứng dụng

1. Cấu hình database SQL Server trong `application.properties`
2. Chạy ứng dụng: `mvn spring-boot:run`
3. Ứng dụng sẽ chạy trên port 8080

## Testing

Chạy tests:

```bash
mvn test
```

## Security Features

- **Password Encryption**: Sử dụng BCrypt
- **JWT Tokens**: Access token và refresh token
- **Role-based Access**: USER, ADMIN, MODERATOR
- **CORS Support**: Cấu hình CORS cho frontend
- **Session Management**: Stateless với JWT
