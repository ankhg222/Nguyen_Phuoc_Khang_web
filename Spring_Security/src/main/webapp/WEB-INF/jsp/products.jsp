<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - JSP Version</title>
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
        .welcome-card {
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
        .btn-create {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
        }
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        .btn-edit {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            border: none;
            color: white;
        }
        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }
        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
            border: none;
            color: white;
        }
        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
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
        .price {
            font-weight: 600;
            color: #28a745;
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
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/jsp">
                <i class="fas fa-shield-alt"></i> Spring Security Demo - JSP Version
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
        <!-- Welcome Card -->
        <div class="welcome-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-3">
                        <i class="fas fa-boxes text-primary"></i> 
                        Quản Lý Sản Phẩm - JSP Version
                    </h1>
                    <p class="text-muted mb-0">
                        Hệ thống quản lý sản phẩm với Spring Security - Demo 4: JSP/JSTL
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <sec:authorize access="hasAnyAuthority('CREATOR', 'ADMIN')">
                        <a href="/new" class="btn btn-create btn-action">
                            <i class="fas fa-plus"></i> Tạo Sản Phẩm Mới
                        </a>
                    </sec:authorize>
                </div>
            </div>
        </div>

        <!-- Products Table -->
        <div class="table-container">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-tag"></i> Tên Sản Phẩm</th>
                            <th><i class="fas fa-industry"></i> Thương Hiệu</th>
                            <th><i class="fas fa-globe"></i> Xuất Xứ</th>
                            <th><i class="fas fa-dollar-sign"></i> Giá</th>
                            <sec:authorize access="hasAnyAuthority('ADMIN', 'EDITOR')">
                                <th><i class="fas fa-cogs"></i> Thao Tác</th>
                            </sec:authorize>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="product">
                            <tr>
                                <td class="fw-bold">${product.id}</td>
                                <td>${product.name}</td>
                                <td>${product.brand}</td>
                                <td>${product.madein}</td>
                                <td class="price">
                                    <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ
                                </td>
                                <sec:authorize access="hasAnyAuthority('ADMIN', 'EDITOR')">
                                    <td>
                                        <a href="/edit/${product.id}" class="btn btn-edit btn-action">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                        <sec:authorize access="hasAuthority('ADMIN')">
                                            <a href="/delete/${product.id}" class="btn btn-delete btn-action"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
                                                <i class="fas fa-trash"></i> Xóa
                                            </a>
                                        </sec:authorize>
                                    </td>
                                </sec:authorize>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Empty State -->
        <c:if test="${empty products}">
            <div class="text-center py-5">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">Chưa có sản phẩm nào</h4>
                <p class="text-muted">Hãy tạo sản phẩm đầu tiên của bạn!</p>
                <sec:authorize access="hasAnyAuthority('CREATOR', 'ADMIN')">
                    <a href="/new" class="btn btn-create btn-action">
                        <i class="fas fa-plus"></i> Tạo Sản Phẩm Đầu Tiên
                    </a>
                </sec:authorize>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
