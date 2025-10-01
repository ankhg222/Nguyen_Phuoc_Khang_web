# Spring Security 6 Demo Project

Đây là đồ án Spring Security 6 với Spring Boot 3, bao gồm 4 demo từ cơ bản đến nâng cao.

## Cấu trúc Project

### Demo 1 - Spring Security cơ bản (Hardcode User)
- **Mục tiêu**: Làm quen với cấu hình Spring Security 6, kiểm thử phân quyền bằng user cố định
- **Tính năng**:
  - Hardcode 2 user trong bộ nhớ (admin, user)
  - Phân quyền: `/hello` → `.permitAll()`, `/customer` → `.authenticated()`
  - Form login với redirect

### Demo 2 - Spring Security với Database
- **Mục tiêu**: Thay vì hardcode user, dùng database để lưu thông tin người dùng và phân quyền
- **Tính năng**:
  - Entity UserInfo, Role với JPA
  - UserDetailsService lấy user từ DB
  - PasswordEncoder (BCrypt)
  - Phân quyền dựa trên role (ROLE_ADMIN, ROLE_USER)

### Demo 3 - Spring Security 6 + Thymeleaf
- **Mục tiêu**: Xây dựng ứng dụng web hoàn chỉnh, dùng Thymeleaf + Spring Security 6
- **Tính năng**:
  - Entity Product cho CRUD
  - AuthController: đăng ký, đăng nhập
  - ProductController: CRUD sản phẩm (chỉ ADMIN)
  - Giao diện Thymeleaf với sec:authorize
  - Trang 403 (access denied)

### Demo 4 - Spring Security với JSP/JSTL
- **Mục tiêu**: Thay Thymeleaf bằng JSP/JSTL
- **Tính năng**:
  - Cấu hình JSP trong Spring Boot
  - Sử dụng JSTL tags để hiển thị UI theo role
  - Controller và cấu hình Security giữ nguyên

## Cài đặt và Chạy

### Yêu cầu hệ thống
- Java 21+
- Maven 3.6+
- MySQL 8.0+ (cho Demo 2, 3, 4)

### Cấu hình Database (Demo 2, 3, 4)

1. Tạo database:
```sql
CREATE DATABASE springb3_security6;
CREATE USER 'security_su'@'localhost' IDENTIFIED BY '1234567@a$';
GRANT ALL PRIVILEGES ON springb3_security6.* TO 'security_su'@'localhost';
FLUSH PRIVILEGES;
```

2. Cấu hình trong `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/springb3_security6
spring.datasource.username=security_su
spring.datasource.password=1234567@a$
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### Chạy ứng dụng

```bash
mvn clean compile
mvn spring-boot:run
```

Ứng dụng sẽ chạy trên `http://localhost:8080`

## Thông tin đăng nhập

### User có sẵn (tự động tạo khi khởi động):
- **admin** / admin123 (ROLE_ADMIN)
- **user** / user123 (ROLE_USER)  
- **demo** / demo123 (ROLE_USER)

### URL endpoints:

#### Demo 1 (Hardcode):
- `/hello` - Không cần login
- `/customer` - Cần login
- `/login` - Form đăng nhập

#### Demo 2 (Database):
- Tất cả như Demo 1
- `/admin` - Chỉ ADMIN
- `/admin/add-user` - Thêm user mới (ADMIN)

#### Demo 3 (Thymeleaf):
- `/` - Trang chủ với sản phẩm
- `/register` - Đăng ký user mới
- `/admin/products` - Quản lý sản phẩm (ADMIN)
- `/admin/products/new` - Thêm sản phẩm (ADMIN)
- `/admin/products/edit/{id}` - Sửa sản phẩm (ADMIN)
- `/403` - Trang access denied

#### Demo 4 (JSP):
- `/jsp` - Trang chủ JSP
- `/jsp/login` - Đăng nhập JSP
- `/jsp/register` - Đăng ký JSP
- `/jsp/customer` - Danh sách khách hàng JSP

## Tính năng chính

### Authentication (Xác thực)
- Form login với Spring Security
- PasswordEncoder (BCrypt)
- UserDetailsService từ database
- Đăng ký user mới

### Authorization (Phân quyền)
- Phân quyền URL: `.permitAll()`, `.authenticated()`, `.hasRole()`
- Phân quyền view: `sec:authorize` (Thymeleaf), `<sec:authorize>` (JSP)
- 2 role cơ bản: ROLE_USER, ROLE_ADMIN

### Giao diện
- **Thymeleaf**: Template engine chính với Spring Security integration
- **JSP/JSTL**: Alternative view technology
- Bootstrap 5 cho UI responsive
- Menu động theo role của user

### Database
- JPA/Hibernate với MySQL
- Entity: UserInfo, Role, Product
- Repository pattern
- Auto-create sample data

## Cấu trúc thư mục

```
src/
├── main/
│   ├── java/vn/iot/
│   │   ├── config/          # SecurityConfig, DataInitializer
│   │   ├── controller/      # Controllers cho các demo
│   │   ├── entity/         # JPA Entities
│   │   ├── repository/     # JPA Repositories
│   │   ├── security/       # UserDetails implementation
│   │   ├── service/        # Business logic services
│   │   └── model/          # Simple models (Demo 1)
│   ├── resources/
│   │   ├── templates/      # Thymeleaf templates
│   │   └── application.properties
│   └── webapp/WEB-INF/jsp/ # JSP files (Demo 4)
└── test/
```

## Demo Flow

1. **Demo 1**: Hardcode users → Test login/logout
2. **Demo 2**: Database users → Test phân quyền ADMIN/USER
3. **Demo 3**: Full web app → Test đăng ký, CRUD products
4. **Demo 4**: JSP version → So sánh với Thymeleaf

## Troubleshooting

### Lỗi database connection:
- Kiểm tra MySQL đang chạy
- Kiểm tra username/password trong application.properties
- Kiểm tra database đã được tạo

### Lỗi compile:
- Kiểm tra Java version (21+)
- Chạy `mvn clean compile` trước khi run

### Lỗi 403 Access Denied:
- Kiểm tra user có đúng role không
- Kiểm tra URL mapping trong SecurityConfig

## Tác giả

Đồ án Spring Security 6 - Demo từ cơ bản đến nâng cao
