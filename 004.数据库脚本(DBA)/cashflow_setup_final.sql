-- CashFlow 个人财务记账管理数据库脚本（最终版）
-- 创建日期：2026-07-21
-- 版本：1.0.1
-- 包含：无外键约束、正确的时间字段、完整测试数据、统一文件、修复字符编码

-- 设置字符编码为utf8mb4
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET collation_connection = utf8mb4_unicode_ci;

-- 删除已存在的数据库
DROP DATABASE IF EXISTS cashflow;

-- 创建数据库
CREATE DATABASE cashflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE cashflow;

-- ===================================================================
-- 用户表（users） - 无外键版本
-- ===================================================================
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名（3-20个字符）',
    email VARCHAR(100) NOT NULL COMMENT '邮箱地址',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码SHA-256哈希值',
    salt VARCHAR(64) NOT NULL COMMENT '密码盐值',
    full_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '真实姓名',
    phone VARCHAR(20) NULL COMMENT '手机号码',
    avatar_url VARCHAR(255) NULL COMMENT '头像URL',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否激活：1-激活，0-未激活',
    is_email_verified TINYINT(1) NOT NULL DEFAULT 0 COMMENT '邮箱是否已验证：1-已验证，0-未验证',
    last_login_at DATETIME NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(45) NULL COMMENT '最后登录IP',
    failed_login_attempts INT NOT NULL DEFAULT 0 COMMENT '登录失败次数',
    account_locked_until DATETIME NULL COMMENT '账户锁定时间',
    preferences JSON NULL COMMENT '用户偏好设置',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ===================================================================
-- 交易分类表（categories）
-- ===================================================================
CREATE TABLE categories (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类ID',
    type ENUM('income', 'expense') NOT NULL COMMENT '类型：income-收入，expense-支出',
    code VARCHAR(50) NOT NULL COMMENT '分类代码',
    name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
    icon VARCHAR(50) NOT NULL COMMENT '图标名称',
    color VARCHAR(20) NOT NULL COMMENT '颜色代码',
    parent_id INT UNSIGNED NULL COMMENT '父分类ID',
    display_order INT NOT NULL DEFAULT 0 COMMENT '显示顺序',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用：1-启用，0-禁用',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_type_code (type, code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易分类表';

-- ===================================================================
-- 交易记录表（transactions） - 无外键版本
-- ===================================================================
CREATE TABLE transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '交易ID',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    type ENUM('income', 'expense') NOT NULL COMMENT '交易类型：income-收入，expense-支出',
    amount DECIMAL(15,2) NOT NULL COMMENT '交易金额',
    category VARCHAR(50) NOT NULL COMMENT '分类代码',
    sub_category VARCHAR(50) NULL COMMENT '子分类代码',
    description VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易描述',
    notes TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注信息',
    transaction_date DATE NOT NULL COMMENT '交易日期',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否删除：1-已删除，0-未删除',
    tags JSON NULL COMMENT '标签列表',
    receipt_url VARCHAR(255) NULL COMMENT '收据/凭证URL',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易记录表';

-- ===================================================================
-- 预算表（budgets） - 无外键版本
-- ===================================================================
CREATE TABLE budgets (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '预算ID',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    category_id INT UNSIGNED NOT NULL COMMENT '分类ID',
    year SMALLINT NOT NULL COMMENT '年份',
    month TINYINT NOT NULL COMMENT '月份（1-12）',
    amount DECIMAL(15,2) NOT NULL COMMENT '预算金额',
    spent_amount DECIMAL(15,2) NOT NULL DEFAULT 0.00 COMMENT '已花费金额',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否生效：1-生效，0-失效',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_category_month (user_id, category_id, year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预算表';

-- ===================================================================
-- 用户设备表（devices） - 无外键版本
-- ===================================================================
CREATE TABLE devices (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '设备ID',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    device_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备名称',
    device_type VARCHAR(50) NOT NULL COMMENT '设备类型（mobile、desktop、tablet）',
    device_model VARCHAR(100) NULL COMMENT '设备型号',
    browser VARCHAR(50) NULL COMMENT '浏览器',
    operating_system VARCHAR(50) NULL COMMENT '操作系统',
    ip_address VARCHAR(45) NULL COMMENT 'IP地址',
    last_active_at DATETIME NULL COMMENT '最后活跃时间',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否活跃：1-活跃，0-不活跃',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户设备表';

-- ===================================================================
-- 用户会话表（sessions） - 无外键版本
-- ===================================================================
CREATE TABLE sessions (
    id VARCHAR(128) NOT NULL COMMENT '会话ID',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    token VARCHAR(512) NOT NULL COMMENT '会话令牌',
    device_id BIGINT UNSIGNED NULL COMMENT '设备ID',
    ip_address VARCHAR(45) NULL COMMENT 'IP地址',
    user_agent VARCHAR(512) NULL COMMENT '用户代理',
    expires_at DATETIME NOT NULL COMMENT '过期时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    last_accessed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后访问时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';

-- ===================================================================
-- 操作日志表（audit_logs） - 无外键版本
-- ===================================================================
CREATE TABLE audit_logs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    user_id BIGINT UNSIGNED NULL COMMENT '用户ID',
    action VARCHAR(100) NOT NULL COMMENT '操作类型',
    resource_type VARCHAR(50) NULL COMMENT '资源类型',
    resource_id BIGINT UNSIGNED NULL COMMENT '资源ID',
    details JSON NULL COMMENT '操作详情',
    ip_address VARCHAR(45) NULL COMMENT 'IP地址',
    user_agent VARCHAR(512) NULL COMMENT '用户代理',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- ===================================================================
-- 数据备份表（backups） - 无外键版本
-- ===================================================================
CREATE TABLE backups (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '备份ID',
    user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    backup_type ENUM('manual', 'auto') NOT NULL COMMENT '备份类型：manual-手动，auto-自动',
    file_size BIGINT UNSIGNED NOT NULL COMMENT '文件大小（字节）',
    file_url VARCHAR(255) NOT NULL COMMENT '备份文件URL',
    backup_hash VARCHAR(64) NULL COMMENT '备份文件SHA-256哈希',
    backup_at DATETIME NOT NULL COMMENT '备份时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据备份表';

-- ===================================================================
-- 插入测试数据
-- ===================================================================

-- 1. 插入交易分类数据
INSERT INTO categories (type, code, name, icon, color, display_order, is_active) VALUES
('income', 'salary', '工资', 'payments', '#10B981', 10, 1),
('income', 'bonus', '奖金', 'emoji_events', '#F59E0B', 20, 1),
('income', 'investment', '投资', 'trending_up', '#8B5CF6', 30, 1),
('income', 'parttime', '兼职', 'work', '#3B82F6', 40, 1),
('income', 'gift', '礼金', 'card_giftcard', '#EC4899', 50, 1),
('income', 'other', '其他', 'more_horiz', '#6B7280', 99, 1),
('expense', 'food', '餐饮', 'restaurant', '#EF4444', 10, 1),
('expense', 'transport', '交通', 'directions_car', '#3B82F6', 20, 1),
('expense', 'shopping', '购物', 'shopping_bag', '#EC4899', 30, 1),
('expense', 'housing', '住房', 'home', '#8B5CF6', 40, 1),
('expense', 'entertainment', '娱乐', 'sports_esports', '#F59E0B', 50, 1),
('expense', 'healthcare', '医疗', 'medical_services', '#10B981', 60, 1),
('expense', 'education', '教育', 'school', '#3B82F6', 70, 1),
('expense', 'utilities', '水电煤', 'bolt', '#F59E0B', 80, 1),
('expense', 'communication', '通讯', 'phone', '#8B5CF6', 90, 1),
('expense', 'clothing', '服装', 'checkroom', '#EC4899', 100, 1),
('expense', 'beauty', '美容', 'spa', '#F59E0B', 110, 1),
('expense', 'fitness', '健身', 'fitness_center', '#10B981', 120, 1),
('expense', 'travel', '旅游', 'flight_takeoff', '#3B82F6', 130, 1),
('expense', 'social', '社交', 'groups', '#EC4899', 140, 1),
('expense', 'charity', '慈善', 'volunteer_activism', '#10B981', 150, 1),
('expense', 'insurance', '保险', 'health_and_safety', '#8B5CF6', 160, 1),
('expense', 'tax', '税费', 'receipt_long', '#6B7280', 170, 1),
('expense', 'repairs', '维修', 'build', '#3B82F6', 180, 1),
('expense', 'other', '其他', 'more_horiz', '#6B7280', 199, 1);

-- 2. 插入用户数据
INSERT INTO users (username, email, password_hash, salt, full_name, is_active, is_email_verified, preferences) VALUES
('testuser', 'test@example.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'example_salt', '测试用户', 1, 1, '{\"theme\": \"light\", \"language\": \"zh-CN\"}'),
('demo_user', 'demo@example.com', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'demo_salt', '演示用户', 1, 1, '{\"theme\": \"dark\", \"language\": \"zh-CN\"}');

-- 3. 插入交易记录数据
INSERT INTO transactions (user_id, type, amount, category, description, notes, transaction_date) VALUES
-- 测试用户的交易
(1, 'income', 15000.00, 'salary', '7月工资', '月薪收入', '2026-07-01'),
(1, 'income', 2000.00, 'bonus', '项目奖金', 'Q2项目完成奖金', '2026-07-05'),
(1, 'income', 500.00, 'parttime', '兼职收入', '周末兼职收入', '2026-07-10'),
(1, 'expense', 3000.00, 'housing', '房租', '7月份房租', '2026-07-01'),
(1, 'expense', 800.00, 'food', '餐饮', '本月餐饮费用', '2026-07-02'),
(1, 'expense', 500.00, 'transport', '交通', '通勤交通费', '2026-07-03'),
(1, 'expense', 1200.00, 'shopping', '购物', '购买衣物和日用品', '2026-07-04'),
(1, 'expense', 300.00, 'entertainment', '娱乐', '看电影、聚餐等', '2026-07-05'),
(1, 'expense', 200.00, 'healthcare', '医疗', '体检费用', '2026-07-06'),
(1, 'expense', 500.00, 'education', '教育', '在线课程费用', '2026-07-07'),
(1, 'expense', 200.00, 'utilities', '水电煤', '水电网费', '2026-07-08'),
(1, 'expense', 150.00, 'communication', '通讯', '手机话费', '2026-07-09'),
(1, 'expense', 400.00, 'fitness', '健身', '健身房会员费', '2026-07-10'),
(1, 'expense', 800.00, 'travel', '旅游', '周末短途游', '2026-07-11'),
(1, 'expense', 200.00, 'social', '社交', '朋友聚会', '2026-07-12'),
(1, 'expense', 100.00, 'other', '其他', '杂项支出', '2026-07-13'),
(1, 'income', 15000.00, 'salary', '6月工资', '月薪收入', '2026-06-01'),
(1, 'income', 3000.00, 'investment', '投资收益', '股票基金收益', '2026-06-15'),
(1, 'expense', 3000.00, 'housing', '房租', '6月份房租', '2026-06-01'),
(1, 'expense', 750.00, 'food', '餐饮', '本月餐饮费用', '2026-06-02'),
(1, 'expense', 450.00, 'transport', '交通', '通勤交通费', '2026-06-03'),
(1, 'expense', 1000.00, 'shopping', '购物', '购买电器', '2026-06-04'),
(1, 'expense', 250.00, 'entertainment', '娱乐', '音乐会门票', '2026-06-05'),
(1, 'expense', 150.00, 'healthcare', '医疗', '药品费用', '2026-06-06'),
(1, 'expense', 600.00, 'education', '教育', '培训课程', '2026-06-07'),
(1, 'expense', 180.00, 'utilities', '水电煤', '水电网费', '2026-06-08'),
(1, 'expense', 130.00, 'communication', '通讯', '手机话费', '2026-06-09'),
(1, 'expense', 300.00, 'clothing', '服装', '夏季服装', '2026-06-10'),
(1, 'expense', 200.00, 'social', '社交', '生日派对', '2026-06-11'),
(1, 'expense', 150.00, 'other', '其他', '杂项支出', '2026-06-12'),

-- 演示用户的交易
(2, 'income', 8000.00, 'salary', '7月工资', '兼职收入', '2026-07-01'),
(2, 'income', 300.00, 'gift', '礼金', '生日红包', '2026-07-08'),
(2, 'expense', 1500.00, 'housing', '房租', '学生宿舍费用', '2026-07-01'),
(2, 'expense', 600.00, 'food', '餐饮', '食堂和外卖', '2026-07-02'),
(2, 'expense', 200.00, 'transport', '交通', '公交地铁月票', '2026-07-03'),
(2, 'expense', 500.00, 'education', '教育', '教材和学习资料', '2026-07-04'),
(2, 'expense', 200.00, 'entertainment', '娱乐', '游戏充值', '2026-07-05'),
(2, 'expense', 150.00, 'utilities', '水电煤', '宿舍水电费', '2026-07-06'),
(2, 'expense', 100.00, 'communication', '通讯', '手机话费', '2026-07-07'),
(2, 'expense', 300.00, 'social', '社交', '同学聚会', '2026-07-08');

-- 4. 插入预算数据
INSERT INTO budgets (user_id, category_id, year, month, amount) VALUES
(1, 7, 2026, 7, 3000.00),   -- 餐饮预算
(1, 8, 2026, 7, 500.00),    -- 交通预算
(1, 9, 2026, 7, 1500.00),   -- 购物预算
(1, 10, 2026, 7, 1000.00),  -- 娱乐预算
(1, 11, 2026, 7, 800.00),   -- 医疗预算
(2, 7, 2026, 7, 800.00),    -- 餐饮预算
(2, 8, 2026, 7, 300.00),    -- 交通预算
(2, 10, 2026, 7, 500.00),   -- 娱乐预算
(2, 12, 2026, 7, 1000.00);  -- 教育预算

-- 5. 插入设备数据
INSERT INTO devices (user_id, device_name, device_type, device_model, browser, operating_system, ip_address, last_active_at) VALUES
(1, 'iPhone 13 Pro', 'mobile', 'iPhone13,3', 'Safari', 'iOS 15.4', '192.168.1.100', NOW()),
(1, 'MacBook Pro', 'desktop', 'MacBookPro17,1', 'Chrome', 'macOS Monterey', '192.168.1.100', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'Xiaomi Mi 11', 'mobile', 'MI 11', 'Chrome', 'Android 12', '192.168.1.101', NOW()),
(2, 'Windows PC', 'desktop', 'HP Pavilion', 'Firefox', 'Windows 11', '192.168.1.101', DATE_SUB(NOW(), INTERVAL 2 HOUR));

-- 6. 插入会话数据
INSERT INTO sessions (id, user_id, token, device_id, ip_address, user_agent, expires_at, last_accessed_at) VALUES
('session_001', 1, 'test_session_token_001', 1, '192.168.1.100', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X)', DATE_ADD(NOW(), INTERVAL 7 DAY), NOW()),
('session_002', 1, 'test_session_token_002', 2, '192.168.1.100', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 HOUR)),
('session_003', 2, 'demo_session_token_003', 3, '192.168.1.101', 'Mozilla/5.0 (Linux; Android 12; MI 11)', DATE_ADD(NOW(), INTERVAL 3 DAY), NOW()),
('session_004', 2, 'demo_session_token_004', 4, '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 6 HOUR));

-- 7. 插入操作日志数据
INSERT INTO audit_logs (user_id, action, resource_type, resource_id, details, ip_address, user_agent) VALUES
(NULL, 'user_register', 'user', 1, '{\"username\": \"testuser\", \"email\": \"test@example.com\"}', '127.0.0.1', 'Web Browser'),
(NULL, 'user_register', 'user', 2, '{\"username\": \"demo_user\", \"email\": \"demo@example.com\"}', '127.0.0.1', 'Web Browser'),
(1, 'user_login', 'user', 1, '{\"method\": \"password\", \"device\": \"iPhone\"}', '192.168.1.100', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X)'),
(1, 'user_login', 'user', 1, '{\"method\": \"password\", \"device\": \"MacBook\"}', '192.168.1.100', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'),
(2, 'user_login', 'user', 2, '{\"method\": \"password\", \"device\": \"Android Phone\"}', '192.168.1.101', 'Mozilla/5.0 (Linux; Android 12; MI 11)'),
(2, 'user_login', 'user', 2, '{\"method\": \"password\", \"device\": \"Windows PC\"}', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
(1, 'create_transaction', 'transaction', 1, '{\"type\": \"income\", \"amount\": 15000, \"category\": \"salary\"}', '192.168.1.100', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X)'),
(1, 'create_transaction', 'transaction', 2, '{\"type\": \"expense\", \"amount\": 3000, \"category\": \"housing\"}', '192.168.1.100', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X)'),
(2, 'create_transaction', 'transaction', 15, '{\"type\": \"expense\", \"amount\": 600, \"category\": \"food\"}', '192.168.1.101', 'Mozilla/5.0 (Linux; Android 12; MI 11)');

-- 8. 插入备份记录
INSERT INTO backups (user_id, backup_type, file_size, file_url, backup_hash, backup_at) VALUES
(1, 'manual', 102400, '/backups/testuser_20260721000001.json', 'backup_hash_123456', NOW()),
(1, 'auto', 51200, '/backups/testuser_auto_20260721000001.json', 'backup_hash_789012', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'manual', 81920, '/backups/demo_user_20260721000001.json', 'backup_hash_345678', NOW()),
(2, 'auto', 40960, '/backups/demo_user_auto_20260721000001.json', 'backup_hash_901234', DATE_SUB(NOW(), INTERVAL 2 DAY));