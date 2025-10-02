-- =============================================
-- SQL Server Database Setup cho Spring Security Demo
-- Tài khoản: sa / 1
-- Database: spring_security_final
-- =============================================

-- Tạo database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'spring_security_final')
BEGIN
    CREATE DATABASE spring_security_final;
END
GO

-- Sử dụng database
USE spring_security_final;
GO

-- Xóa các bảng cũ nếu tồn tại (để tránh conflict)
IF EXISTS (SELECT * FROM sysobjects WHERE name='products' AND xtype='U')
    DROP TABLE products;
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='roles' AND xtype='U')
    DROP TABLE roles;
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='user_info' AND xtype='U')
    DROP TABLE user_info;
GO

-- Tạo bảng products (theo entity Product.java)
CREATE TABLE products (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    brand NVARCHAR(255),
    madein NVARCHAR(255),
    price FLOAT NOT NULL
);
GO

-- Tạo bảng roles (theo entity Role.java)
CREATE TABLE roles (
    role_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL
);
GO

-- Tạo bảng user_info (theo entity UserInfo.java)
CREATE TABLE user_info (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(255),
    name VARCHAR(255),
    password VARCHAR(255),
    roles VARCHAR(255),
    username VARCHAR(255)
);
GO


-- Insert dữ liệu mẫu cho roles
INSERT INTO roles (role_name) VALUES 
('ROLE_USER'),
('ROLE_ADMIN'),
('ROLE_EDITOR'),
('ROLE_CREATOR');
GO

-- Insert dữ liệu mẫu cho user_info (password đã được mã hóa bằng BCrypt)
-- Mật khẩu gốc: admin123, user123, demo123
INSERT INTO user_info (name, username, email, password, roles) VALUES 
('admin', 'admin', 'admin@demo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ROLE_ADMIN'),
('user', 'user', 'user@demo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ROLE_USER'),
('demo', 'demo', 'demo@demo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ROLE_USER');
GO

-- Insert dữ liệu mẫu cho products
INSERT INTO products (name, brand, madein, price) VALUES 
('iPhone 15 Pro', 'Apple', 'USA', 29990000.0),
('Samsung Galaxy S24 Ultra', 'Samsung', 'South Korea', 27990000.0),
('MacBook Pro M3', 'Apple', 'USA', 45990000.0);
GO

-- Kiểm tra dữ liệu
PRINT '=== KIỂM TRA DỮ LIỆU ===';

PRINT 'Roles:';
SELECT * FROM roles;

PRINT 'User Info:';
SELECT id, name, username, email, roles FROM user_info;

PRINT 'Products:';
SELECT * FROM products;

PRINT '=== HOÀN THÀNH SETUP DATABASE ===';
PRINT 'Database: spring_security_final';
PRINT 'Tài khoản SQL: sa / 1';
PRINT 'Tài khoản ứng dụng:';
PRINT '  - Admin: admin@demo.com / admin123';
PRINT '  - User: user@demo.com / user123';
PRINT '  - Demo: demo@demo.com / demo123';

-- =============================================
-- HƯỚNG DẪN SỬ DỤNG:
-- =============================================
-- 
-- 1. Chạy file SQL này:
--    sqlcmd -S localhost -U sa -P 1 -i sqlserver_setup.sql
-- 
-- 2. Hoặc sử dụng SQL Server Management Studio (SSMS):
--    - Mở SSMS
--    - Kết nối: localhost (hoặc .\SQLEXPRESS)
--    - Username: sa, Password: 1
--    - Mở file này và chạy
-- 
-- 3. Chạy ứng dụng Spring Boot:
--    mvn spring-boot:run
-- 
-- 4. Truy cập ứng dụng:
--    http://localhost:8080
-- 
-- 5. Đăng nhập với các tài khoản:
--    - Admin: admin@demo.com / admin123 (có quyền ADMIN)
--    - User: user@demo.com / user123 (có quyền USER)
--    - Demo: demo@demo.com / demo123 (có quyền USER)
-- 
-- 6. Test các demo:
--    - Demo 1: /hello, /customer/all, /customer/001
--    - Demo 2: Database authentication
--    - Demo 3: / (Thymeleaf UI)
--    - Demo 4: /jsp (JSP UI)
-- 
-- =============================================