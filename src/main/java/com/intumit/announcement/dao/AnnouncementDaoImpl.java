package com.intumit.announcement.dao;

import com.intumit.announcement.model.Announcement;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AnnouncementDaoImpl implements AnnouncementDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(Announcement announcement) {
        sessionFactory.getCurrentSession().save(announcement);
    }

    @Override
    public void update(Announcement announcement) {
        sessionFactory.getCurrentSession().merge(announcement);
    }

    @Override
    public void delete(Long id) {
        Announcement announcement = findById(id);
        if (announcement != null) {
            sessionFactory.getCurrentSession().delete(announcement);
        }
    }

    @Override
    public Announcement findById(Long id) {
        return sessionFactory.getCurrentSession().get(Announcement.class, id);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Announcement> findPage(int page, int pageSize) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Announcement ORDER BY postDate DESC, id DESC")
                .setFirstResult((page - 1) * pageSize)
                .setMaxResults(pageSize)
                .list();
    }

    @Override
    public long count() {
        return (long) sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(a) FROM Announcement a")
                .uniqueResult();
    }
}
