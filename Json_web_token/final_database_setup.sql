-- =============================================
-- Script Name: FINAL COMPLETE DATABASE SETUP FOR SPRINGBOOT_1001
-- Description: File SQL hoàn chỉnh gộp từ 3 file: complete_database_setup.sql, fix_all_passwords.sql, fix_bcrypt_passwords.sql
-- Author: SpringBoot_1001 Team
-- Created: 2025-10-02
-- Purpose: Tạo database, bảng, stored procedures, triggers và dữ liệu mẫu với password hash đúng
-- =============================================

-- =============================================
-- PHẦN 1: TẠO DATABASE VÀ CẤU TRÚC
-- =============================================

-- 1. Tạo database (nếu chưa tồn tại)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SpringBoot1001')
BEGIN
    CREATE DATABASE SpringBoot1001;
    PRINT 'Database SpringBoot1001 created successfully.';
END
ELSE
BEGIN
    PRINT 'Database SpringBoot1001 already exists.';
END
GO

-- 2. Sử dụng database SpringBoot1001
USE SpringBoot1001;
GO

-- 3. Tạo bảng users
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
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
    PRINT 'Table users created successfully.';
END
ELSE
BEGIN
    PRINT 'Table users already exists.';
END
GO

-- 4. Tạo index cho username và email để tăng hiệu suất
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_users_username')
BEGIN
    CREATE INDEX IX_users_username ON users(username);
    PRINT 'Index IX_users_username created successfully.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_users_email')
BEGIN
    CREATE INDEX IX_users_email ON users(email);
    PRINT 'Index IX_users_email created successfully.';
END
GO

-- =============================================
-- PHẦN 2: TẠO STORED PROCEDURES
-- =============================================

-- 5. Tạo stored procedure để tạo user mới
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_CreateUser')
    DROP PROCEDURE sp_CreateUser;
GO

CREATE PROCEDURE sp_CreateUser
    @username NVARCHAR(50),
    @password NVARCHAR(255),
    @email NVARCHAR(100),
    @role NVARCHAR(20) = 'USER'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra username đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM users WHERE username = @username)
    BEGIN
        RAISERROR('Username already exists', 16, 1);
        RETURN;
    END
    
    -- Kiểm tra email đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM users WHERE email = @email)
    BEGIN
        RAISERROR('Email already exists', 16, 1);
        RETURN;
    END
    
    -- Tạo user mới
    INSERT INTO users (username, password, email, role, created_at, updated_at)
    VALUES (@username, @password, @email, @role, GETDATE(), GETDATE());
    
    SELECT 'User created successfully' AS Result;
END
GO

-- 6. Tạo stored procedure để tìm user theo username
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_FindUserByUsername')
    DROP PROCEDURE sp_FindUserByUsername;
GO

CREATE PROCEDURE sp_FindUserByUsername
    @username NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id,
        username,
        password,
        email,
        role,
        enabled,
        account_non_expired,
        account_non_locked,
        credentials_non_expired,
        created_at,
        updated_at
    FROM users 
    WHERE username = @username;
END
GO

-- 7. Tạo stored procedure để tìm user theo email
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_FindUserByEmail')
    DROP PROCEDURE sp_FindUserByEmail;
GO

CREATE PROCEDURE sp_FindUserByEmail
    @email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id,
        username,
        password,
        email,
        role,
        enabled,
        account_non_expired,
        account_non_locked,
        credentials_non_expired,
        created_at,
        updated_at
    FROM users 
    WHERE email = @email;
END
GO

-- =============================================
-- PHẦN 3: TẠO TRIGGERS
-- =============================================

-- 8. Tạo trigger để tự động cập nhật updated_at
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_users_updated_at')
    DROP TRIGGER tr_users_updated_at;
GO

CREATE TRIGGER tr_users_updated_at
ON users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE users 
    SET updated_at = GETDATE()
    FROM users u
    INNER JOIN inserted i ON u.id = i.id;
END
GO

-- =============================================
-- PHẦN 4: THÊM DỮ LIỆU MẪU VỚI PASSWORD HASH ĐÚNG
-- =============================================

-- 9. Tạo user admin với password hash đúng (admin123)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin')
BEGIN
    INSERT INTO users (username, password, email, role, enabled, created_at, updated_at)
    VALUES (
        'admin', 
        '$2a$10$VEjAiGztXXmkcmJ.fG9gTO5k.0L8CSvhgNz3auJi4T2GK9QzUWP9.', -- admin123
        'admin@example.com', 
        'ADMIN', 
        1, 
        GETDATE(), 
        GETDATE()
    );
    PRINT 'Admin user created successfully.';
END
ELSE
BEGIN
    -- Cập nhật password hash đúng cho user 'admin' (password: admin123)
    UPDATE users 
    SET password = '$2a$10$VEjAiGztXXmkcmJ.fG9gTO5k.0L8CSvhgNz3auJi4T2GK9QzUWP9.'
    WHERE username = 'admin';
    PRINT 'Updated password for user: admin (password: admin123)';
END

-- 10. Tạo user test với password hash đúng (test123)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'test')
BEGIN
    INSERT INTO users (username, password, email, role, enabled, created_at, updated_at)
    VALUES (
        'test', 
        '$2a$10$eImiTXuWiQKVv7o3G1Lrmu4VNrchDJVGjVz9ToBgbrmxFgeJsMHxu', -- test123
        'test@example.com', 
        'USER', 
        1, 
        GETDATE(), 
        GETDATE()
    );
    PRINT 'Test user created successfully.';
END
ELSE
BEGIN
    -- Cập nhật password hash đúng cho user 'test' (password: test123)
    UPDATE users 
    SET password = '$2a$10$eImiTXuWiQKVv7o3G1Lrmu4VNrchDJVGjVz9ToBgbrmxFgeJsMHxu'
    WHERE username = 'test';
    PRINT 'Updated password for user: test (password: test123)';
END

-- 11. Thêm user newuser123 với password: password123
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'newuser123')
BEGIN
    INSERT INTO users (username, password, email, role, enabled, created_at, updated_at)
    VALUES (
        'newuser123', 
        '$2a$10$YTqw1GX8TLWORdFxyNqEkOgcbcZazpRKWomUIwiJ7MF9/jUYI.hwy', -- password123
        'newuser123@example.com', 
        'USER', 
        1, 
        GETDATE(), 
        GETDATE()
    );
    PRINT 'Created user: newuser123 (password: password123)';
END
ELSE
BEGIN
    -- Nếu user đã tồn tại, cập nhật password
    UPDATE users 
    SET password = '$2a$10$YTqw1GX8TLWORdFxyNqEkOgcbcZazpRKWomUIwiJ7MF9/jUYI.hwy'
    WHERE username = 'newuser123';
    PRINT 'Updated password for existing user: newuser123 (password: password123)';
END

-- 12. Thêm các user test khác với password: password123
DECLARE @users TABLE (username NVARCHAR(50), email NVARCHAR(100));
INSERT INTO @users VALUES 
    ('testuser4', 'testuser4@example.com'),
    ('testuser5', 'testuser5@example.com'),
    ('testuser6', 'testuser6@example.com'),
    ('testuser999', 'testuser999@example.com'),
    ('testuser2025', 'testuser2025@example.com');

DECLARE @username NVARCHAR(50), @email NVARCHAR(100);
DECLARE user_cursor CURSOR FOR SELECT username, email FROM @users;

OPEN user_cursor;
FETCH NEXT FROM user_cursor INTO @username, @email;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE username = @username)
    BEGIN
        INSERT INTO users (username, password, email, role, enabled, created_at, updated_at)
        VALUES (
            @username, 
            '$2a$10$YTqw1GX8TLWORdFxyNqEkOgcbcZazpRKWomUIwiJ7MF9/jUYI.hwy', -- password123
            @email, 
            'USER', 
            1, 
            GETDATE(), 
            GETDATE()
        );
        PRINT 'Created user: ' + @username + ' (password: password123)';
    END
    ELSE
    BEGIN
        UPDATE users 
        SET password = '$2a$10$YTqw1GX8TLWORdFxyNqEkOgcbcZazpRKWomUIwiJ7MF9/jUYI.hwy'
        WHERE username = @username;
        PRINT 'Updated password for existing user: ' + @username + ' (password: password123)';
    END
    
    FETCH NEXT FROM user_cursor INTO @username, @email;
END

CLOSE user_cursor;
DEALLOCATE user_cursor;

-- =============================================
-- PHẦN 5: CẬP NHẬT PASSWORD HASH VỚI BCrypt CHÍNH XÁC
-- =============================================

-- 13. Cập nhật tất cả password với BCrypt hash chính xác nhất
PRINT 'Updating all passwords with correct BCrypt hashes...';

-- Update admin password (admin123) với hash chính xác nhất
UPDATE users 
SET password = '$2a$10$VEjAiGztXXmkcmJ.fG9gTO5k.0L8CSvhgNz3auJi4T2GK9QzUWP9.'
WHERE username = 'admin';
PRINT 'Updated password for admin (admin123)';

-- Update test password (test123) với hash chính xác nhất  
UPDATE users 
SET password = '$2a$10$eImiTXuWiQKVv7o3G1Lrmu4VNrchDJVGjVz9ToBgbrmxFgeJsMHxu'
WHERE username = 'test';
PRINT 'Updated password for test (test123)';

-- Update newuser123 password (password123) với hash chính xác nhất
UPDATE users 
SET password = '$2a$10$YTqw1GX8TLWORdFxyNqEkOgcbcZazpRKWomUIwiJ7MF9/jUYI.hwy'
WHERE username = 'newuser123';
PRINT 'Updated password for newuser123 (password123)';

-- Update tất cả testuser passwords (password123) với hash chính xác nhất
UPDATE users 
SET password = '$2a$10$YTqw1GX8TLWORdFxyNqEkOgcbcZazpRKWomUIwiJ7MF9/jUYI.hwy'
WHERE username IN ('testuser4', 'testuser5', 'testuser6', 'testuser999', 'testuser2025');
PRINT 'Updated passwords for test users (password123)';

-- =============================================
-- PHẦN 6: HIỂN THỊ KẾT QUẢ CUỐI CÙNG
-- =============================================

-- 14. Hiển thị thông tin database và tất cả users
SELECT 
    'FINAL DATABASE SETUP COMPLETED SUCCESSFULLY!' AS Status,
    DB_NAME() AS DatabaseName,
    COUNT(*) AS UserCount
FROM users;

-- Hiển thị tất cả users và thông tin của họ
SELECT 
    id,
    username,
    email,
    role,
    enabled,
    created_at,
    LEFT(password, 20) + '...' as password_preview
FROM users
ORDER BY id;

-- =============================================
-- KẾT LUẬN VÀ THÔNG TIN CUỐI CÙNG
-- =============================================

PRINT '=============================================';
PRINT 'FINAL COMPLETE DATABASE SETUP COMPLETED!';
PRINT '=============================================';
PRINT 'Database: SpringBoot1001';
PRINT 'Tables: users';
PRINT 'Stored Procedures: sp_CreateUser, sp_FindUserByUsername, sp_FindUserByEmail';
PRINT 'Triggers: tr_users_updated_at';
PRINT 'Indexes: IX_users_username, IX_users_email';
PRINT '';
PRINT 'All password hashes updated with correct BCrypt!';
PRINT '';
PRINT 'Test accounts available:';
PRINT '  - admin / admin123 (ADMIN role)';
PRINT '  - test / test123 (USER role)'; 
PRINT '  - newuser123 / password123 (USER role)';
PRINT '  - testuser4 / password123 (USER role)';
PRINT '  - testuser5 / password123 (USER role)';
PRINT '  - testuser6 / password123 (USER role)';
PRINT '  - testuser999 / password123 (USER role)';
PRINT '  - testuser2025 / password123 (USER role)';
PRINT '';
PRINT 'This file combines:';
PRINT '  - complete_database_setup.sql';
PRINT '  - fix_all_passwords.sql';
PRINT '  - fix_bcrypt_passwords.sql';
PRINT '';
PRINT 'All passwords are now correctly hashed with BCrypt!';
PRINT 'Ready for Spring Boot JWT application!';
PRINT '=============================================';
