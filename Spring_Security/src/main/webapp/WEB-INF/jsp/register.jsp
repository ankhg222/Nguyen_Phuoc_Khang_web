<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Demo 4 (JSP)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">Demo 4 - Spring Security (JSP)</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/">Trang Chủ</a>
                <a class="nav-link" href="/hello">Hello</a>
                <a class="nav-link" href="/login">Đăng Nhập</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h2 class="text-center">Đăng Ký Tài Khoản - Demo 4 (JSP)</h2>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                        
                        <form action="/register" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập:</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Họ và tên:</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-success">Đăng Ký</button>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center">
                            <p>Đã có tài khoản? <a href="/login">Đăng nhập ngay</a></p>
                            <a href="/" class="btn btn-secondary">Quay Lại Trang Chủ</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
