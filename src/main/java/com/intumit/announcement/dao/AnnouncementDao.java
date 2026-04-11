package com.intumit.announcement.dao;

import com.intumit.announcement.model.Announcement;

import java.util.List;

public interface AnnouncementDao {
    void save(Announcement announcement);
    void update(Announcement announcement);
    void delete(Long id);
    Announcement findById(Long id);
    List<Announcement> findPage(int page, int pageSize);
    long count();
}
