# Hướng dẫn chạy Spring Security Demo với SQL Server

## Thông tin tài khoản SQL Server:
- **Username:** `sa`
- **Password:** `1`
- **Server:** `localhost:1433`

## Cách chạy đơn giản:

### Bước 1: Chạy file SQL
```bash
sqlcmd -S localhost -U sa -P 1 -i sqlserver_setup.sql
```

**Hoặc sử dụng SSMS:**
1. Mở SQL Server Management Studio
2. Kết nối: `localhost` (hoặc `.\SQLEXPRESS`)
3. Username: `sa`, Password: `1`
4. Mở file `sqlserver_setup.sql` và chạy

### Bước 2: Chạy ứng dụng
```bash
mvn spring-boot:run
```

### Bước 3: Truy cập ứng dụng
- URL: `http://localhost:8080`
- Đăng nhập với tài khoản có sẵn trong hệ thống

## Thông tin đăng nhập (chỉ dành cho developer):
- **admin** / admin123 (ADMIN) - truy cập được trang admin
- **user** / user123 (USER) - chỉ truy cập được trang user
- **demo** / demo123 (USER) - chỉ truy cập được trang user

## URL endpoints:
- `/` - Trang chủ
- `/hello` - Trang hello
- `/customer` - Danh sách khách hàng (cần đăng nhập)
- `/admin` - Trang quản trị (chỉ ADMIN)
- `/register` - Đăng ký user mới
- `/login` - Đăng nhập
- `/jsp` - Phiên bản JSP

## Troubleshooting:

### Lỗi "Login failed":
- Kiểm tra SQL Server đang chạy
- Kiểm tra Authentication mode (Mixed Mode)
- Kiểm tra username/password: sa / 1

### Lỗi "Cannot connect":
- Kiểm tra SQL Server service
- Kiểm tra port 1433
- Kiểm tra firewall

### Lỗi "Database doesn't exist":
- Chạy lại file `sqlserver_setup.sql`

### Lỗi "Table doesn't exist":
- Spring Boot sẽ tự động tạo bảng
- Kiểm tra `spring.jpa.hibernate.ddl-auto=update`
