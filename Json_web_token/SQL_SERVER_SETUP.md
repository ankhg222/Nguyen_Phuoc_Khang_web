# Hướng dẫn cài đặt và cấu hình SQL Server cho SpringBoot_1001

## 1. Cài đặt SQL Server

### Cách 1: SQL Server Express (Miễn phí)

1. Tải SQL Server Express từ: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
2. Chọn "Express" version
3. Tải và cài đặt SQL Server Express
4. Trong quá trình cài đặt, chọn "Mixed Mode Authentication"
5. Đặt password cho user `sa` (ví dụ: `123456`)

### Cách 2: SQL Server Developer Edition (Miễn phí)

1. Tải SQL Server Developer Edition từ: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
2. Chọn "Developer" version
3. Cài đặt tương tự như Express

### Cách 3: Docker (Khuyến nghị cho development)

```bash
# Chạy SQL Server trong Docker
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=123456" -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
```

## 2. Cấu hình SQL Server

### Bước 1: Kích hoạt SQL Server Authentication

1. Mở SQL Server Management Studio (SSMS)
2. Kết nối với server bằng Windows Authentication
3. Right-click vào server name → Properties
4. Chọn "Security" tab
5. Chọn "SQL Server and Windows Authentication mode"
6. Click OK và restart SQL Server service

### Bước 2: Tạo database và user

1. Mở SSMS
2. Kết nối với server bằng user `sa` và password `123456`
3. Chạy script `database_setup.sql` để tạo database và bảng

### Bước 3: Kiểm tra kết nối

1. Mở Command Prompt
2. Chạy lệnh:

```cmd
sqlcmd -S localhost -U sa -P 123456 -Q "SELECT @@VERSION"
```

## 3. Cấu hình ứng dụng Spring Boot

### File application.properties đã được cấu hình:

```properties
# Database Configuration - SQL Server
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=SpringBoot1001;encrypt=false;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=123456
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.SQLServerDialect
spring.jpa.properties.hibernate.format_sql=true
```

## 4. Chạy ứng dụng

### Bước 1: Chạy script tạo database

```cmd
sqlcmd -S localhost -U sa -P 123456 -i database_setup.sql
```

### Bước 2: Chạy ứng dụng Spring Boot

```cmd
mvn spring-boot:run
```

### Bước 3: Kiểm tra ứng dụng

- Mở browser và truy cập: http://localhost:8080
- API endpoints:
  - POST http://localhost:8080/api/auth/register
  - POST http://localhost:8080/api/auth/login
  - GET http://localhost:8080/api/test/public
  - GET http://localhost:8080/api/test/protected

## 5. Troubleshooting

### Lỗi kết nối database

1. Kiểm tra SQL Server service có đang chạy không
2. Kiểm tra port 1433 có bị block không
3. Kiểm tra username/password có đúng không
4. Kiểm tra database có tồn tại không

### Lỗi authentication

1. Kiểm tra SQL Server Authentication có được enable không
2. Kiểm tra user `sa` có bị disable không
3. Kiểm tra password có đúng không

### Lỗi driver

1. Kiểm tra dependency SQL Server JDBC driver trong pom.xml
2. Chạy `mvn clean install` để tải lại dependencies

## 6. Dữ liệu mẫu

Sau khi chạy script `database_setup.sql`, bạn sẽ có:

- Database: `SpringBoot1001`
- Table: `users`
- User admin: username=`admin`, password=`admin123`
- User test: username=`test`, password=`test123`

## 7. Cấu trúc bảng users

```sql
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    role NVARCHAR(20) NOT NULL DEFAULT 'USER',
    enabled BIT NOT NULL DEFAULT 1,
    account_non_expired BIT NOT NULL DEFAULT 1,
    account_non_locked BIT NOT NULL DEFAULT 1,
    credentials_non_expired BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);
```

## 8. Lưu ý quan trọng

1. **Bảo mật**: Thay đổi password mặc định trong production
2. **Firewall**: Mở port 1433 nếu cần kết nối từ xa
3. **Backup**: Thường xuyên backup database
4. **Monitoring**: Theo dõi performance và logs

## 9. Liên hệ hỗ trợ

Nếu gặp vấn đề, hãy kiểm tra:

1. Logs của ứng dụng Spring Boot
2. Logs của SQL Server
3. Network connectivity
4. Firewall settings
