-- ============================================================
-- Announcement System - Database Initialization Script
-- MySQL 8.x
-- ============================================================

CREATE DATABASE IF NOT EXISTS announcement_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE announcement_db;

CREATE TABLE IF NOT EXISTS announcement (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    title       VARCHAR(255) NOT NULL COMMENT '標題',
    publisher   VARCHAR(100) NOT NULL COMMENT '公佈者',
    post_date   DATE         NOT NULL COMMENT '張貼日期',
    expiry_date DATE         NOT NULL COMMENT '截止日期',
    content     TEXT                  COMMENT '公佈內容',
    file_name   VARCHAR(255)          COMMENT '原始檔名',
    file_path   VARCHAR(500)          COMMENT '存放路徑',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT '建立時間',
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                      ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample data
INSERT INTO announcement (title, publisher, post_date, expiry_date, content) VALUES
('歡迎使用公告管理系統', 'Administrator', '2026-04-01', '2026-12-31',
 '<p>Hello，歡迎使用公告管理系統！</p><p>您可以在此新增、修改、刪除公告。</p>'),
('系統維護通知', 'Administrator', '2026-04-05', '2026-04-15',
 '<p>系統將於 2026/04/10（五）22:00~24:00 進行例行維護，期間服務暫停。</p>'),
('人事公告：端午節假期安排', 'Administrator', '2026-04-08', '2026-06-01',
 '<p>端午節（6/1）放假一天，前後工作天照常上班。</p>');
