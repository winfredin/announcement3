package com.intumit.announcement.controller;

import com.intumit.announcement.model.Announcement;
import com.intumit.announcement.service.AnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/api/announcements")
public class AnnouncementController {

    private static final int PAGE_SIZE = 10;
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Autowired
    private AnnouncementService announcementService;

    // -----------------------------------------------------------------------
    // GET /api/announcements?page=1
    // -----------------------------------------------------------------------
    @GetMapping
    public ResponseEntity<Map<String, Object>> list(
            @RequestParam(defaultValue = "1") int page) {

        long total = announcementService.count();
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        List<Announcement> announcements = announcementService.findPage(page, PAGE_SIZE);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("announcements", announcements);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);
        result.put("total", total);
        return ResponseEntity.ok(result);
    }

    // -----------------------------------------------------------------------
    // GET /api/announcements/{id}
    // -----------------------------------------------------------------------
    @GetMapping("/{id}")
    public ResponseEntity<Announcement> getById(@PathVariable Long id) {
        Announcement ann = announcementService.findById(id);
        if (ann == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(ann);
    }

    // -----------------------------------------------------------------------
    // POST /api/announcements  (multipart/form-data)
    // -----------------------------------------------------------------------
    @PostMapping
    public ResponseEntity<Announcement> create(
            @RequestParam String title,
            @RequestParam String publisher,
            @RequestParam String postDate,
            @RequestParam String expiryDate,
            @RequestParam(required = false) String content,
            @RequestParam(value = "attachFile", required = false) MultipartFile file,
            HttpServletRequest request) throws IOException, ParseException {

        Announcement ann = new Announcement();
        ann.setTitle(title);
        ann.setPublisher(publisher);
        ann.setPostDate(sdf.parse(postDate));
        ann.setExpiryDate(sdf.parse(expiryDate));
        ann.setContent(content);
        handleFileUpload(file, ann, request);

        announcementService.save(ann);
        return ResponseEntity.ok(ann);
    }

    // -----------------------------------------------------------------------
    // PUT /api/announcements/{id}  (multipart/form-data)
    // -----------------------------------------------------------------------
    @PutMapping("/{id}")
    public ResponseEntity<Announcement> update(
            @PathVariable Long id,
            @RequestParam String title,
            @RequestParam String publisher,
            @RequestParam String postDate,
            @RequestParam String expiryDate,
            @RequestParam(required = false) String content,
            @RequestParam(value = "attachFile", required = false) MultipartFile file,
            HttpServletRequest request) throws IOException, ParseException {

        Announcement ann = announcementService.findById(id);
        if (ann == null) return ResponseEntity.notFound().build();

        ann.setTitle(title);
        ann.setPublisher(publisher);
        ann.setPostDate(sdf.parse(postDate));
        ann.setExpiryDate(sdf.parse(expiryDate));
        ann.setContent(content);

        if (file != null && !file.isEmpty()) {
            handleFileUpload(file, ann, request);
        }

        announcementService.update(ann);
        return ResponseEntity.ok(ann);
    }

    // -----------------------------------------------------------------------
    // DELETE /api/announcements/{id}
    // -----------------------------------------------------------------------
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> delete(@PathVariable Long id) {
        announcementService.delete(id);
        Map<String, String> result = new HashMap<>();
        result.put("message", "刪除成功");
        return ResponseEntity.ok(result);
    }

    // -----------------------------------------------------------------------
    // GET /api/announcements/{id}/download
    // -----------------------------------------------------------------------
    @GetMapping("/{id}/download")
    public void download(@PathVariable Long id,
                         HttpServletRequest request,
                         HttpServletResponse response) throws IOException {
        Announcement ann = announcementService.findById(id);
        if (ann == null || ann.getFileName() == null) {
            response.sendError(404);
            return;
        }

        String filePath = request.getServletContext().getRealPath("/uploads/") + ann.getFileName();
        File file = new File(filePath);
        if (!file.exists()) {
            response.sendError(404);
            return;
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + ann.getFileName() + "\"");
        response.setContentLengthLong(file.length());

        try (java.io.FileInputStream fis = new java.io.FileInputStream(file);
             java.io.OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }

    // -----------------------------------------------------------------------
    // Helper
    // -----------------------------------------------------------------------
    private void handleFileUpload(MultipartFile file, Announcement ann,
                                  HttpServletRequest request) throws IOException {
        if (file == null || file.isEmpty()) return;

        String uploadDir = request.getServletContext().getRealPath("/uploads");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String ext = (originalName != null && originalName.contains("."))
                ? originalName.substring(originalName.lastIndexOf(".")) : "";
        String uniqueName = UUID.randomUUID().toString() + ext;

        file.transferTo(new File(uploadDir + File.separator + uniqueName));
        ann.setFileName(originalName);
        ann.setFilePath("/uploads/" + uniqueName);
    }
}
