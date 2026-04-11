package com.intumit.announcement.service;

import com.intumit.announcement.model.Announcement;

import java.util.List;

public interface AnnouncementService {
    void save(Announcement announcement);
    void update(Announcement announcement);
    void delete(Long id);
    Announcement findById(Long id);
    List<Announcement> findPage(int page, int pageSize);
    long count();
}
