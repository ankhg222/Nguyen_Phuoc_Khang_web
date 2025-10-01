<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Quản Trị - JSP Version</title>
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
        .admin-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            padding: 1.5rem;
        }
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            font-weight: 600;
            padding: 1rem;
        }
        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: #f8f9fa;
        }
        .btn-action {
            border-radius: 8px;
            padding: 0.5rem 1rem;
            margin: 0 0.25rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary-action {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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
        .role-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
        }
        .role-admin {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
            color: white;
        }
        .role-user {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
        }
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/jsp">
                <i class="fas fa-shield-alt"></i> Spring Security Demo - Admin Panel
            </a>
            <div class="navbar-nav ms-auto">
                <sec:authorize access="isAuthenticated()">
                    <div class="d-flex align-items-center">
                        <span class="text-white me-3">
                            <i class="fas fa-user"></i> 
                            <sec:authentication property="name" />
                            <sec:authentication property="principal.authorities" var="authorities" />
                            <c:forEach items="${authorities}" var="authority">
                                <span class="role-badge role-admin ms-2">${authority.authority}</span>
                            </c:forEach>
                        </span>
                        <form action="/logout" method="post" class="d-inline">
                            <button type="submit" class="btn btn-logout btn-action">
                                <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                            </button>
                        </form>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <!-- Admin Header -->
        <div class="admin-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-3">
                        <i class="fas fa-crown text-warning"></i> 
                        Trang Quản Trị - JSP Version
                    </h1>
                    <p class="text-muted mb-0">
                        Quản lý người dùng và sản phẩm trong hệ thống Spring Security Demo
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="/jsp" class="btn btn-primary-action btn-action">
                        <i class="fas fa-home"></i> Về Trang Chủ
                    </a>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="stats-card">
                    <div class="stats-number">${users.size()}</div>
                    <div>Tổng Số Người Dùng</div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stats-card">
                    <div class="stats-number">${products.size()}</div>
                    <div>Tổng Số Sản Phẩm</div>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="table-container">
            <div class="admin-card">
                <h3><i class="fas fa-users text-primary"></i> Danh Sách Người Dùng</h3>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-user"></i> Tên</th>
                            <th><i class="fas fa-at"></i> Username</th>
                            <th><i class="fas fa-envelope"></i> Email</th>
                            <th><i class="fas fa-shield-alt"></i> Vai Trò</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td class="fw-bold">${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.roles == 'ROLE_ADMIN'}">
                                            <span class="role-badge role-admin">ADMIN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-badge role-user">USER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Products Table -->
        <div class="table-container">
            <div class="admin-card">
                <h3><i class="fas fa-boxes text-success"></i> Danh Sách Sản Phẩm</h3>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-tag"></i> Tên Sản Phẩm</th>
                            <th><i class="fas fa-industry"></i> Thương Hiệu</th>
                            <th><i class="fas fa-globe"></i> Xuất Xứ</th>
                            <th><i class="fas fa-dollar-sign"></i> Giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="product">
                            <tr>
                                <td class="fw-bold">${product.id}</td>
                                <td>${product.name}</td>
                                <td>${product.brand}</td>
                                <td>${product.madein}</td>
                                <td class="text-success fw-bold">
                                    <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
