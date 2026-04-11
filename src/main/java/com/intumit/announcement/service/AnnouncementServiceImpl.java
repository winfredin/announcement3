package com.intumit.announcement.service;

import com.intumit.announcement.dao.AnnouncementDao;
import com.intumit.announcement.model.Announcement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class AnnouncementServiceImpl implements AnnouncementService {

    @Autowired
    private AnnouncementDao announcementDao;

    @Override
    public void save(Announcement announcement) {
        announcementDao.save(announcement);
    }

    @Override
    public void update(Announcement announcement) {
        announcementDao.update(announcement);
    }

    @Override
    public void delete(Long id) {
        announcementDao.delete(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Announcement findById(Long id) {
        return announcementDao.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Announcement> findPage(int page, int pageSize) {
        return announcementDao.findPage(page, pageSize);
    }

    @Override
    @Transactional(readOnly = true)
    public long count() {
        return announcementDao.count();
    }
}
