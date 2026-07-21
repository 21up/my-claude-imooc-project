// CashFlow - 工具函数库

// 日期格式化
const formatDate = {
    // 格式化为 YYYY-MM-DD
    toISOString: (date) => {
        const d = new Date(date);
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    },

    // 格式化为相对时间（今天、昨天、X天前）
    relative: (date) => {
        const d = new Date(date);
        const now = new Date();
        const diffTime = Math.abs(now - d);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        if (diffDays === 0) return '今天';
        if (diffDays === 1) return '昨天';
        if (diffDays < 7) return `${diffDays}天前`;
        if (diffDays < 30) return `${Math.floor(diffDays / 7)}周前`;
        if (diffDays < 365) return `${Math.floor(diffDays / 30)}个月前`;
        return `${Math.floor(diffDays / 365)}年前`;
    },

    // 格式化为中文日期
    chinese: (date) => {
        const d = new Date(date);
        const year = d.getFullYear();
        const month = d.getMonth() + 1;
        const day = d.getDate();
        return `${year}年${month}月${day}日`;
    }
};

// 金额格式化
const formatCurrency = {
    // 格式化为货币格式
    format: (amount) => {
        return new Intl.NumberFormat('zh-CN', {
            style: 'currency',
            currency: 'CNY',
            minimumFractionDigits: 2
        }).format(amount);
    },

    // 去除货币格式中的符号
    parse: (str) => {
        return parseFloat(str.replace(/[¥,]/g, ''));
    }
};

// 分类管理
const CATEGORIES = {
    expense: [
        { id: 'food', name: '餐饮', icon: 'restaurant', color: '#F59E0B' },
        { id: 'transport', name: '交通', icon: 'directions_bus', color: '#3B82F6' },
        { id: 'shopping', name: '购物', icon: 'shopping_bag', color: '#EF4444' },
        { id: 'entertainment', name: '娱乐', icon: 'movie', color: '#8B5CF6' },
        { id: 'housing', name: '居住', icon: 'home', color: '#10B981' },
        { id: 'medical', name: '医疗', icon: 'medical_services', color: '#F43F5E' },
        { id: 'education', name: '教育', icon: 'school', color: '#3B82F6' },
        { id: 'other', name: '其他', icon: 'more_horiz', color: '#6B7280' }
    ],
    income: [
        { id: 'salary', name: '工资', icon: 'payments', color: '#10B981' },
        { id: 'bonus', name: '奖金', icon: 'card_giftcard', color: '#F59E0B' },
        { id: 'investment', name: '投资', icon: 'trending_up', color: '#10B981' },
        { id: 'parttime', name: '兼职', icon: 'work', color: '#8B5CF6' },
        { id: 'other', name: '其他', icon: 'more_horiz', color: '#6B7280' }
    ]
};

// 获取分类信息
function getCategory(type, categoryId) {
    const categories = CATEGORIES[type] || [];
    return categories.find(cat => cat.id === categoryId);
}

// 获取所有分类
function getCategories(type = null) {
    if (type) {
        return CATEGORIES[type] || [];
    }
    return { ...CATEGORIES };
}

// 数据持久化
const storage = {
    // 保存交易记录
    saveTransaction: (transaction) => {
        let transactions = storage.getTransactions();
        transactions.unshift(transaction);
        localStorage.setItem('cashflow_transactions', JSON.stringify(transactions));
        return transaction;
    },

    // 获取交易记录
    getTransactions: () => {
        const data = localStorage.getItem('cashflow_transactions');
        return data ? JSON.parse(data) : [];
    },

    // 更新交易记录
    updateTransaction: (id, updates) => {
        let transactions = storage.getTransactions();
        const index = transactions.findIndex(t => t.id === id);
        if (index !== -1) {
            transactions[index] = { ...transactions[index], ...updates };
            localStorage.setItem('cashflow_transactions', JSON.stringify(transactions));
            return transactions[index];
        }
        return null;
    },

    // 删除交易记录
    deleteTransaction: (id) => {
        let transactions = storage.getTransactions();
        transactions = transactions.filter(t => t.id !== id);
        localStorage.setItem('cashflow_transactions', JSON.stringify(transactions));
        return true;
    },

    // 保存预算设置
    saveBudget: (budget) => {
        let budgets = storage.getBudgets();
        const index = budgets.findIndex(b => b.category === budget.category);
        if (index !== -1) {
            budgets[index] = budget;
        } else {
            budgets.push(budget);
        }
        localStorage.setItem('cashflow_budgets', JSON.stringify(budgets));
        return budget;
    },

    // 获取预算设置
    getBudgets: () => {
        const data = localStorage.getItem('cashflow_budgets');
        return data ? JSON.parse(data) : [];
    },

    // 清空所有数据
    clearAll: () => {
        localStorage.removeItem('cashflow_transactions');
        localStorage.removeItem('cashflow_budgets');
        localStorage.removeItem('cashflow_user');
        return true;
    }
};

// 统计计算
const statistics = {
    // 计算总收入
    totalIncome: (transactions, month = null) => {
        const filtered = filterTransactionsByMonth(transactions, month, 'income');
        return filtered.reduce((sum, t) => sum + t.amount, 0);
    },

    // 计算总支出
    totalExpense: (transactions, month = null) => {
        const filtered = filterTransactionsByMonth(transactions, month, 'expense');
        return filtered.reduce((sum, t) => sum + t.amount, 0);
    },

    // 按分类统计
    byCategory: (transactions, type = 'expense', month = null) => {
        const filtered = filterTransactionsByMonth(transactions, month, type);
        const stats = {};

        filtered.forEach(t => {
            if (!stats[t.category]) {
                stats[t.category] = {
                    amount: 0,
                    count: 0,
                    transactions: []
                };
            }
            stats[t.category].amount += t.amount;
            stats[t.category].count++;
            stats[t.category].transactions.push(t);
        });

        return stats;
    },

    // 计算月度余额
    monthlyBalance: (transactions, month = null) => {
        return statistics.totalIncome(transactions, month) - statistics.totalExpense(transactions, month);
    },

    // 计算日均支出
    dailyExpense: (transactions, month = null) => {
        const filtered = filterTransactionsByMonth(transactions, month, 'expense');
        const totalAmount = filtered.reduce((sum, t) => sum + t.amount, 0);
        const daysInMonth = month ? new Date(month + '-01').getDaysInMonth() : new Date().getDate();
        return totalAmount / daysInMonth;
    }
};

// 辅助函数：按月份筛选交易
function filterTransactionsByMonth(transactions, month, type = null) {
    return transactions.filter(t => {
        if (type && t.type !== type) return false;
        if (month) {
            const transactionMonth = t.date.substring(0, 7);
            return transactionMonth === month;
        }
        return true;
    });
}

// 通知系统
const notification = {
    show: (message, type = 'info', duration = 3000) => {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;

        // 添加到页面
        document.body.appendChild(notification);

        // 触发动画
        setTimeout(() => notification.classList.add('show'), 10);

        // 自动消失
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => notification.remove(), 300);
        }, duration);
    },

    success: (message) => notification.show(message, 'success'),
    error: (message) => notification.show(message, 'error'),
    warning: (message) => notification.show(message, 'warning'),
    info: (message) => notification.show(message, 'info')
};

// 表单验证
const validation = {
    // 验证邮箱
    email: (email) => {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    },

    // 验证密码
    password: (password) => {
        return password.length >= 8 && /[A-Za-z]/.test(password) && /[0-9]/.test(password);
    },

    // 验证金额
    amount: (amount) => {
        const num = parseFloat(amount);
        return !isNaN(num) && num > 0;
    },

    // 验证手机号
    phone: (phone) => {
        const regex = /^1[3-9]\d{9}$/;
        return regex.test(phone);
    },

    // 验证用户名
    username: (username) => {
        return /^[a-zA-Z0-9_]{3,20}$/.test(username);
    }
};

// 导出工具
const exportData = {
    // 导出为 CSV
    toCSV: (transactions) => {
        const headers = ['日期', '类型', '金额', '分类', '描述', '备注'];
        const rows = transactions.map(t => [
            t.date,
            t.type === 'income' ? '收入' : '支出',
            t.amount,
            getCategory(t.type, t.category).name,
            t.description,
            t.notes || ''
        ]);

        const csv = [headers, ...rows]
            .map(row => row.map(field => `"${field}"`).join(','))
            .join('\n');

        const blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `cashflow_${formatDate.toISOString(new Date())}.csv`;
        link.click();
    },

    // 导出为 JSON
    toJSON: () => {
        const data = {
            transactions: storage.getTransactions(),
            budgets: storage.getBudgets(),
            exportDate: new Date().toISOString(),
            version: '1.0'
        };

        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `cashflow_backup_${formatDate.toISOString(new Date())}.json`;
        link.click();
    }
};

// 添加 Date 原型方法
Date.prototype.getDaysInMonth = function() {
    return new Date(this.getFullYear(), this.getMonth() + 1, 0).getDate();
};

// 用户认证管理
const auth = {
    // 登录用户
    login: (user) => {
        localStorage.setItem('cashflow_user', JSON.stringify(user));
        return user;
    },

    // 获取当前登录用户
    getCurrentUser: () => {
        const data = localStorage.getItem('cashflow_user');
        return data ? JSON.parse(data) : null;
    },

    // 注销
    logout: () => {
        localStorage.removeItem('cashflow_user');
        return true;
    },

    // 检查是否已登录
    isLoggedIn: () => {
        return !!localStorage.getItem('cashflow_user');
    }
};

// 全局导出
window.CashFlowUtils = {
    formatDate,
    formatCurrency,
    getCategory,
    getCategories,
    storage,
    statistics,
    notification,
    validation,
    exportData,
    ...auth
};