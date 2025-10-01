<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Page - Demo 4 (JSP)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">Demo 4 - Spring Security (JSP)</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/">Trang Chủ</a>
                <a class="nav-link" href="/hello">Hello</a>
                <a class="nav-link" href="/customer">Khách Hàng</a>
                <sec:authorize access="hasRole('ADMIN')">
                    <a class="nav-link" href="/admin">Quản Trị</a>
                </sec:authorize>
                <a class="nav-link" href="/logout">Đăng Xuất</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h2>Danh Sách Khách Hàng - Demo 4 (JSP)</h2>
                        <div>
                            <span class="badge bg-light text-dark me-2"><sec:authentication property="name"/></span>
                            <span class="badge bg-warning text-dark me-2"><sec:authentication property="authorities"/></span>
                            <a href="/logout" class="btn btn-outline-light btn-sm">Đăng Xuất</a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-success">
                            <h4>${message}</h4>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên</th>
                                        <th>Email</th>
                                        <th>Số Điện Thoại</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customers}">
                                        <tr>
                                            <td>${customer.id}</td>
                                            <td>${customer.name}</td>
                                            <td>${customer.email}</td>
                                            <td>${customer.phone}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="text-center mt-4">
                            <a href="/" class="btn btn-secondary me-2">Quay Lại Trang Chủ</a>
                            <sec:authorize access="hasRole('ADMIN')">
                                <a href="/admin" class="btn btn-danger">Trang Quản Trị</a>
                            </sec:authorize>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
