<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spring Security Demo - Tổng Kết 4 Demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .navbar-brand {
            font-weight: 600;
            font-size: 1.5rem;
        }
        .main-container {
            margin-top: 2rem;
        }
        .demo-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            padding: 2rem;
            transition: transform 0.3s ease;
        }
        .demo-card:hover {
            transform: translateY(-5px);
        }
        .demo-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .demo-header h1 {
            color: #333;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .demo-header p {
            color: #666;
            font-size: 1.1rem;
        }
        .demo-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .demo-1 { color: #28a745; }
        .demo-2 { color: #007bff; }
        .demo-3 { color: #ffc107; }
        .demo-4 { color: #dc3545; }
        .btn-demo {
            border-radius: 10px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            margin: 0.5rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-demo-1 {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
        }
        .btn-demo-1:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
        }
        .btn-demo-2 {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            border: none;
            color: white;
        }
        .btn-demo-2:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 123, 255, 0.4);
            color: white;
        }
        .btn-demo-3 {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            border: none;
            color: white;
        }
        .btn-demo-3:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
            color: white;
        }
        .btn-demo-4 {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
            border: none;
            color: white;
        }
        .btn-demo-4:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
            color: white;
        }
        .btn-logout {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            color: white;
        }
        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        .feature-list {
            list-style: none;
            padding: 0;
        }
        .feature-list li {
            padding: 0.5rem 0;
            border-bottom: 1px solid #f8f9fa;
        }
        .feature-list li:last-child {
            border-bottom: none;
        }
        .feature-list li i {
            color: #28a745;
            margin-right: 0.5rem;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-weight: 500;
        }
        .status-completed {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-shield-alt"></i> Spring Security Demo
            </a>
            <div class="navbar-nav ms-auto">
                <sec:authorize access="isAuthenticated()">
                    <div class="d-flex align-items-center">
                        <span class="text-white me-3">
                            <i class="fas fa-user"></i> 
                            <sec:authentication property="name" />
                        </span>
                        <form action="/logout" method="post" class="d-inline">
                            <button type="submit" class="btn btn-logout btn-demo">
                                <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                            </button>
                        </form>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <!-- Header -->
        <div class="demo-header">
            <h1><i class="fas fa-graduation-cap text-primary"></i> Spring Security Demo Project</h1>
            <p>Đồ án Spring Security 6 với Spring Boot 3 - Hoàn thành đầy đủ 4 Demo</p>
        </div>

        <!-- Demo 1 -->
        <div class="demo-card">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <i class="fas fa-code demo-icon demo-1"></i>
                </div>
                <div class="col-md-6">
                    <h3 class="mb-3">
                        <span class="status-badge status-completed">HOÀN THÀNH</span>
                        Demo 1: Spring Security Cơ Bản
                    </h3>
                    <p class="text-muted mb-3">Hardcode users trong bộ nhớ, cấu hình phân quyền cơ bản</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-check"></i> Hardcode users (admin, user)</li>
                        <li><i class="fas fa-check"></i> Phân quyền URL cơ bản</li>
                        <li><i class="fas fa-check"></i> Form login với redirect</li>
                        <li><i class="fas fa-check"></i> Endpoints: /hello, /customer</li>
                    </ul>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/hello" class="btn btn-demo-1 btn-demo">
                        <i class="fas fa-play"></i> Test Demo 1
                    </a>
                </div>
            </div>
        </div>

        <!-- Demo 2 -->
        <div class="demo-card">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <i class="fas fa-database demo-icon demo-2"></i>
                </div>
                <div class="col-md-6">
                    <h3 class="mb-3">
                        <span class="status-badge status-completed">HOÀN THÀNH</span>
                        Demo 2: Spring Security với Database
                    </h3>
                    <p class="text-muted mb-3">Sử dụng database để lưu thông tin người dùng và phân quyền</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-check"></i> Entity UserInfo với JPA</li>
                        <li><i class="fas fa-check"></i> UserDetailsService từ database</li>
                        <li><i class="fas fa-check"></i> PasswordEncoder (BCrypt)</li>
                        <li><i class="fas fa-check"></i> Phân quyền dựa trên role</li>
                    </ul>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/customer/all" class="btn btn-demo-2 btn-demo">
                        <i class="fas fa-play"></i> Test Demo 2
                    </a>
                </div>
            </div>
        </div>

        <!-- Demo 3 -->
        <div class="demo-card">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <i class="fas fa-leaf demo-icon demo-3"></i>
                </div>
                <div class="col-md-6">
                    <h3 class="mb-3">
                        <span class="status-badge status-completed">HOÀN THÀNH</span>
                        Demo 3: Spring Security với Thymeleaf
                    </h3>
                    <p class="text-muted mb-3">Ứng dụng web hoàn chỉnh với Thymeleaf và Spring Security</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-check"></i> Entity Product cho CRUD</li>
                        <li><i class="fas fa-check"></i> AuthController đăng ký/đăng nhập</li>
                        <li><i class="fas fa-check"></i> ProductController CRUD sản phẩm</li>
                        <li><i class="fas fa-check"></i> Thymeleaf với sec:authorize</li>
                    </ul>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/" class="btn btn-demo-3 btn-demo">
                        <i class="fas fa-play"></i> Test Demo 3
                    </a>
                </div>
            </div>
        </div>

        <!-- Demo 4 -->
        <div class="demo-card">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <i class="fas fa-file-code demo-icon demo-4"></i>
                </div>
                <div class="col-md-6">
                    <h3 class="mb-3">
                        <span class="status-badge status-completed">HOÀN THÀNH</span>
                        Demo 4: Spring Security với JSP/JSTL
                    </h3>
                    <p class="text-muted mb-3">Thay Thymeleaf bằng JSP/JSTL để hiển thị UI</p>
                    <ul class="feature-list">
                        <li><i class="fas fa-check"></i> Cấu hình JSP trong Spring Boot</li>
                        <li><i class="fas fa-check"></i> JSP templates với JSTL</li>
                        <li><i class="fas fa-check"></i> JspController cho JSP routes</li>
                        <li><i class="fas fa-check"></i> Security integration với JSP</li>
                    </ul>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/jsp" class="btn btn-demo-4 btn-demo">
                        <i class="fas fa-play"></i> Test Demo 4
                    </a>
                </div>
            </div>
        </div>

        <!-- Summary -->
        <div class="demo-card text-center">
            <h3 class="mb-3">
                <i class="fas fa-trophy text-warning"></i> Tổng Kết
            </h3>
            <p class="text-muted mb-4">
                Đồ án đã hoàn thành đầy đủ 4 demo theo yêu cầu, từ cơ bản đến nâng cao.
                Tất cả các tính năng Spring Security 6 đều được triển khai và test thành công.
            </p>
            <div class="row">
                <div class="col-md-3">
                    <div class="text-center">
                        <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                        <h5>Demo 1</h5>
                        <small class="text-muted">Hardcode Users</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                        <h5>Demo 2</h5>
                        <small class="text-muted">Database Users</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                        <h5>Demo 3</h5>
                        <small class="text-muted">Thymeleaf UI</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                        <h5>Demo 4</h5>
                        <small class="text-muted">JSP/JSTL UI</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
