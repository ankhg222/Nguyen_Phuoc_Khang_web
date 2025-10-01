<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Demo 4 (JSP)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">Demo 4 - Spring Security (JSP)</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/">Trang Chủ</a>
                <a class="nav-link" href="/hello">Hello</a>
                <a class="nav-link" href="/jsp/summary">Tổng Kết Demo</a>
                <sec:authorize access="isAuthenticated()">
                    <a class="nav-link" href="/customer">Khách Hàng</a>
                </sec:authorize>
                <sec:authorize access="hasRole('ADMIN')">
                    <a class="nav-link" href="/admin">Quản Trị</a>
                </sec:authorize>
                <sec:authorize access="!isAuthenticated()">
                    <a class="nav-link" href="/register">Đăng Ký</a>
                    <a class="nav-link" href="/login">Đăng Nhập</a>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <a class="nav-link" href="/logout">Đăng Xuất</a>
                </sec:authorize>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="alert alert-info">
                    <h2>${message}</h2>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <h3>Sản Phẩm Nổi Bật</h3>
                <div class="row">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="col-md-4 mb-4">
                                    <div class="card h-100">
                                        <img src="${product.imageUrl != null ? product.imageUrl : '/images/no-image.png'}" 
                                             class="card-img-top" alt="Product Image" style="height: 200px; object-fit: cover;">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title">${product.name}</h5>
                                            <p class="card-text flex-grow-1">${product.description}</p>
                                            <div class="mt-auto">
                                                <p class="text-muted">Giá: <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> VNĐ</p>
                                                <p class="text-muted">Tồn kho: ${product.stock}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning">
                                <p>Chưa có sản phẩm nào trong hệ thống.</p>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="/admin/products/new" class="btn btn-primary">Thêm Sản Phẩm Đầu Tiên</a>
                                </sec:authorize>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4>Giới Thiệu Hệ Thống</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Chức năng:</h5>
                                <ul>
                                    <li>Đăng ký user mới</li>
                                    <li>Đăng nhập/đăng xuất</li>
                                    <li>Phân quyền theo role</li>
                                    <li>Quản lý sản phẩm (ADMIN)</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h5>Demo Versions:</h5>
                                <ul>
                                    <li><strong>Demo 1:</strong> Hardcode users</li>
                                    <li><strong>Demo 2:</strong> Database users</li>
                                    <li><strong>Demo 3:</strong> Thymeleaf UI</li>
                                    <li><strong>Demo 4:</strong> JSP/JSTL UI (Current)</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
