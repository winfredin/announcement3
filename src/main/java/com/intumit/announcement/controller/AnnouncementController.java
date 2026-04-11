package com.intumit.announcement.controller;

import com.intumit.announcement.model.Announcement;
import com.intumit.announcement.service.AnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/announcement")
public class AnnouncementController {

    private static final int PAGE_SIZE = 10;

    @Autowired
    private AnnouncementService announcementService;

    /** Bind date strings (yyyy-MM-dd) to java.util.Date in all form submissions */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
    }

    // -----------------------------------------------------------------------
    // LIST
    // -----------------------------------------------------------------------

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page, Model model) {
        long total = announcementService.count();
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        List<Announcement> announcements = announcementService.findPage(page, PAGE_SIZE);

        model.addAttribute("announcements", announcements);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("total", total);
        return "list";
    }

    // -----------------------------------------------------------------------
    // ADD
    // -----------------------------------------------------------------------

    @GetMapping("/add")
    public String showAddForm(Model model) {
        Announcement announcement = new Announcement();
        announcement.setPublisher("Administrator");
        model.addAttribute("announcement", announcement);
        return "add";
    }

    @PostMapping("/add")
    public String add(@ModelAttribute Announcement announcement,
                      @RequestParam("attachFile") MultipartFile file,
                      HttpServletRequest request) throws IOException {

        handleFileUpload(file, announcement, request);
        announcementService.save(announcement);
        return "redirect:/announcement/list";
    }

    // -----------------------------------------------------------------------
    // EDIT
    // -----------------------------------------------------------------------

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Announcement announcement = announcementService.findById(id);
        model.addAttribute("announcement", announcement);
        return "edit";
    }

    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Long id,
                       @ModelAttribute Announcement announcement,
                       @RequestParam("attachFile") MultipartFile file,
                       HttpServletRequest request) throws IOException {

        announcement.setId(id);

        if (!file.isEmpty()) {
            handleFileUpload(file, announcement, request);
        } else {
            // Preserve existing attachment info
            Announcement existing = announcementService.findById(id);
            announcement.setFileName(existing.getFileName());
            announcement.setFilePath(existing.getFilePath());
        }

        announcementService.update(announcement);
        return "redirect:/announcement/list";
    }

    // -----------------------------------------------------------------------
    // DELETE
    // -----------------------------------------------------------------------

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        announcementService.delete(id);
        return "redirect:/announcement/list";
    }

    // -----------------------------------------------------------------------
    // FILE DOWNLOAD
    // -----------------------------------------------------------------------

    @GetMapping("/download/{id}")
    public void download(@PathVariable Long id,
                         javax.servlet.http.HttpServletResponse response,
                         HttpServletRequest request) throws IOException {
        Announcement announcement = announcementService.findById(id);
        if (announcement == null || announcement.getFileName() == null) return;

        String filePath = request.getServletContext().getRealPath("/uploads/")
                + announcement.getFileName();
        File file = new File(filePath);
        if (!file.exists()) return;

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + announcement.getFileName() + "\"");
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
    // ROOT redirect
    // -----------------------------------------------------------------------

    @GetMapping("/")
    public String root() {
        return "redirect:/announcement/list";
    }

    // -----------------------------------------------------------------------
    // Helper
    // -----------------------------------------------------------------------

    private void handleFileUpload(MultipartFile file, Announcement announcement,
                                  HttpServletRequest request) throws IOException {
        if (file == null || file.isEmpty()) return;

        String uploadDir = request.getServletContext().getRealPath("/uploads");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String ext = (originalName != null && originalName.contains("."))
                ? originalName.substring(originalName.lastIndexOf("."))
                : "";
        String uniqueName = UUID.randomUUID().toString() + ext;

        File dest = new File(uploadDir + File.separator + uniqueName);
        file.transferTo(dest);

        announcement.setFileName(originalName);
        announcement.setFilePath("/uploads/" + uniqueName);
    }
}
