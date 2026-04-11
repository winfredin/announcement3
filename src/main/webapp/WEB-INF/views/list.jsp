<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>瀏覽公告事項</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: #fff;
            border-bottom: 2px solid #dee2e6;
            padding: 12px 20px;
            margin-bottom: 20px;
        }
        .page-header h5 { margin: 0; color: #495057; font-weight: 600; }
        .card { box-shadow: 0 1px 4px rgba(0,0,0,.08); }
        .table th { background-color: #f1f3f5; font-weight: 600; white-space: nowrap; }
        .badge-category {
            background-color: #dc3545;
            color: #fff;
            font-size: 0.8rem;
            padding: 3px 8px;
            border-radius: 3px;
            margin-right: 6px;
        }
        .btn-add { background-color: #dc3545; border-color: #dc3545; color: #fff; }
        .btn-add:hover { background-color: #bb2d3b; border-color: #bb2d3b; color: #fff; }
        .pagination .page-link { color: #495057; }
        .pagination .page-item.active .page-link {
            background-color: #dc3545; border-color: #dc3545;
        }
        .table-hover tbody tr:hover { background-color: #fff8f8; }
    </style>
</head>
<body>

<!-- Top Nav -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/announcement/list">
            <i class="bi bi-megaphone-fill me-2"></i>公告管理系統
        </a>
    </div>
</nav>

<div class="container mt-4">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center py-3">
            <div>
                <span class="badge-category">公告</span>
                <span class="fw-semibold fs-6">瀏覽公告事項</span>
            </div>
            <a href="${pageContext.request.contextPath}/announcement/add" class="btn btn-add btn-sm">
                <i class="bi bi-plus-lg me-1"></i>新增公告
            </a>
        </div>

        <div class="card-body p-0">
            <table class="table table-hover table-bordered mb-0">
                <thead>
                    <tr>
                        <th style="width:45%">標題</th>
                        <th style="width:15%" class="text-center">張貼日期</th>
                        <th style="width:15%" class="text-center">截止日期</th>
                        <th style="width:10%" class="text-center">公佈者</th>
                        <th style="width:8%" class="text-center">修改</th>
                        <th style="width:7%" class="text-center">刪除</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty announcements}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">目前沒有公告資料</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="ann" items="${announcements}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/announcement/edit/${ann.id}"
                                           class="text-decoration-none text-dark fw-semibold">
                                            ${ann.title}
                                        </a>
                                        <c:if test="${not empty ann.fileName}">
                                            <a href="${pageContext.request.contextPath}/announcement/download/${ann.id}"
                                               class="ms-2 text-muted" title="下載附件: ${ann.fileName}">
                                                <i class="bi bi-paperclip"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${ann.postDate}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${ann.expiryDate}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td class="text-center">${ann.publisher}</td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/announcement/edit/${ann.id}"
                                           class="btn btn-sm btn-outline-primary py-0 px-2">
                                            <i class="bi bi-pencil-square"></i> 修改
                                        </a>
                                    </td>
                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/announcement/delete/${ann.id}"
                                              method="post" class="d-inline"
                                              onsubmit="return confirm('確定要刪除「${ann.title}」嗎？')">
                                            <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2">
                                                <i class="bi bi-trash3"></i> 刪除
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="card-footer d-flex justify-content-between align-items-center">
            <small class="text-muted">共 ${total} 筆資料，第 ${currentPage} / ${totalPages} 頁</small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <!-- First Page -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/announcement/list?page=1">首頁</a>
                    </li>
                    <!-- Previous Page -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/announcement/list?page=${currentPage - 1}">上頁</a>
                    </li>

                    <!-- Page Numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/announcement/list?page=${i}">${i}</a>
                            </li>
                        </c:if>
                    </c:forEach>

                    <!-- Next Page -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/announcement/list?page=${currentPage + 1}">下頁</a>
                    </li>
                    <!-- Last Page -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/announcement/list?page=${totalPages}">末頁</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
