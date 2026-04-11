<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新增公佈事項</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card { box-shadow: 0 1px 4px rgba(0,0,0,.08); }
        .form-label { font-weight: 500; }
        .card-header { background-color: #fff; border-bottom: 2px solid #dee2e6; }
        .ck-editor__editable { min-height: 250px; }
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

<div class="container mt-4" style="max-width: 860px;">
    <div class="card">
        <div class="card-header py-3">
            <h6 class="mb-0 fw-semibold">
                <i class="bi bi-plus-circle me-2 text-danger"></i>新增公佈事項
            </h6>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/announcement/add"
                  method="post" enctype="multipart/form-data" id="addForm">

                <!-- Title -->
                <div class="row mb-3">
                    <label for="title" class="col-sm-2 col-form-label">標題</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="title" name="title"
                               placeholder="請輸入標題" required maxlength="255">
                    </div>
                </div>

                <!-- Post Date -->
                <div class="row mb-3">
                    <label for="postDate" class="col-sm-2 col-form-label">張貼日期</label>
                    <div class="col-sm-4">
                        <input type="date" class="form-control" id="postDate" name="postDate" required>
                    </div>
                </div>

                <!-- Expiry Date -->
                <div class="row mb-3">
                    <label for="expiryDate" class="col-sm-2 col-form-label">截止日期</label>
                    <div class="col-sm-4">
                        <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
                    </div>
                </div>

                <!-- Publisher -->
                <div class="row mb-3">
                    <label for="publisher" class="col-sm-2 col-form-label">公佈者</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" id="publisher" name="publisher"
                               value="${announcement.publisher}" required maxlength="100">
                    </div>
                </div>

                <!-- Content (CKEditor) -->
                <div class="row mb-3">
                    <label for="content" class="col-sm-2 col-form-label">公佈內容</label>
                    <div class="col-sm-10">
                        <textarea id="content" name="content" class="form-control" rows="10"></textarea>
                    </div>
                </div>

                <!-- File Upload -->
                <div class="row mb-4">
                    <label for="attachFile" class="col-sm-2 col-form-label">附件</label>
                    <div class="col-sm-10">
                        <input type="file" class="form-control" id="attachFile" name="attachFile">
                        <div class="form-text">選擇要上傳的附件（最大 20MB）</div>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="row">
                    <div class="col-sm-10 offset-sm-2">
                        <button type="submit" class="btn btn-danger me-2">
                            <i class="bi bi-check-lg me-1"></i>儲存
                        </button>
                        <a href="${pageContext.request.contextPath}/announcement/list"
                           class="btn btn-secondary">
                            <i class="bi bi-x-lg me-1"></i>取消
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- CKEditor 4 -->
<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('content', {
        language: 'zh',
        height: 300,
        toolbar: [
            { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline', 'Strike', '-', 'RemoveFormat'] },
            { name: 'paragraph', items: ['NumberedList', 'BulletedList', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight'] },
            { name: 'styles', items: ['Format', 'Font', 'FontSize'] },
            { name: 'colors', items: ['TextColor', 'BGColor'] },
            { name: 'links', items: ['Link', 'Unlink'] },
            { name: 'insert', items: ['Image', 'Table', 'HorizontalRule'] },
            { name: 'tools', items: ['Source'] }
        ]
    });

    // Set today's date as default
    document.getElementById('postDate').valueAsDate = new Date();
</script>
</body>
</html>
