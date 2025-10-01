<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Demo 4 (JSP)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">Demo 4 - Spring Security (JSP)</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/">Trang Chủ</a>
                <a class="nav-link" href="/hello">Hello</a>
                <a class="nav-link" href="/register">Đăng Ký</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h2 class="text-center">Đăng Nhập - Demo 4 (JSP)</h2>
                    </div>
                    <div class="card-body">
                        <c:if test="${param.error != null}">
                            <div class="alert alert-danger">
                                Tên đăng nhập hoặc mật khẩu không đúng!
                            </div>
                        </c:if>
                        
                        <c:if test="${param.logout != null}">
                            <div class="alert alert-success">
                                Bạn đã đăng xuất thành công!
                            </div>
                        </c:if>
                        
                        <form action="/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập:</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Đăng Nhập</button>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center mt-3">
                            <p>Chưa có tài khoản? <a href="/register">Đăng ký ngay</a></p>
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="/" class="btn btn-secondary">Quay Lại Trang Chủ</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
