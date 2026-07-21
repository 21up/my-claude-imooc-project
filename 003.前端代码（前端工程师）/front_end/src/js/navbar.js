// CashFlow - 导航栏组件
// 统一管理底部导航栏的显示和页面跳转

// 导航配置
const NAVIGATION = {
    home: {
        id: 'home',
        icon: 'grid_view',
        label: '首页',
        path: 'index.html'
    },
    transactions: {
        id: 'transactions',
        icon: 'receipt_long',
        label: '流水',
        path: 'transactions.html'
    },
    analysis: {
        id: 'analysis',
        icon: 'bar_chart',
        label: '分析',
        path: 'analysis.html'
    },
    budget: {
        id: 'budget',
        icon: 'account_balance_wallet',
        label: '预算',
        path: 'budget.html'
    },
    account: {
        id: 'account',
        icon: 'account_circle',
        label: '账户',
        path: 'account.html'
    }
};

// 创建底部导航栏
function createNavBar() {
    const navBar = document.createElement('nav');
    navBar.className = 'nav-bar';
    navBar.setAttribute('role', 'navigation');

    const navContent = document.createElement('div');
    navContent.className = 'nav-bar-content';

    // 导航项
    Object.values(NAVIGATION).forEach(item => {
        const navItem = document.createElement('a');
        navItem.href = item.path;
        navItem.className = 'nav-item';
        navItem.setAttribute('aria-label', item.label);

        const icon = document.createElement('span');
        icon.className = 'material-symbols-outlined';
        icon.textContent = item.icon;

        const label = document.createElement('span');
        label.className = 'text-xs font-medium';
        label.textContent = item.label;

        navItem.appendChild(icon);
        navItem.appendChild(label);
        navContent.appendChild(navItem);
    });

    navBar.appendChild(navContent);
    document.body.appendChild(navBar);

    // 设置当前激活的导航项
    setActiveNavItem();
}

// 设置当前激活的导航项
function setActiveNavItem() {
    const currentPath = window.location.pathname;
    const navItems = document.querySelectorAll('.nav-item');

    navItems.forEach(item => {
        const href = item.getAttribute('href');
        if (href && currentPath.includes(href.split('.')[0])) {
            item.classList.add('active');
        }
    });
}

// 检查用户登录状态
function checkAuth() {
    const isLoggedIn = localStorage.getItem('cashflow_user');
    if (!isLoggedIn && window.location.pathname !== 'login.html' && window.location.pathname !== 'register.html') {
        // 未登录且不在登录/注册页面，跳转到登录页
        window.location.href = 'login.html';
    }
    return !!isLoggedIn;
}

// 用户登录
function login(userData) {
    localStorage.setItem('cashflow_user', JSON.stringify(userData));
    localStorage.setItem('cashflow_last_login', new Date().toISOString());
    showNotification('登录成功', 'success');
}

// 用户登出
function logout() {
    localStorage.removeItem('cashflow_user');
    localStorage.removeItem('cashflow_last_login');
    window.location.href = 'login.html';
}

// 获取当前用户信息
function getCurrentUser() {
    const userData = localStorage.getItem('cashflow_user');
    return userData ? JSON.parse(userData) : null;
}

// 页面初始化
document.addEventListener('DOMContentLoaded', function() {
    // 创建导航栏（除了登录和注册页面）
    const isLoginPage = window.location.pathname.includes('login.html');
    const isRegisterPage = window.location.pathname.includes('register.html');

    if (!isLoginPage && !isRegisterPage) {
        createNavBar();

        // 延迟检查认证状态，让页面先加载
        setTimeout(() => {
            checkAuth();
        }, 100);
    }

    // 添加导航项点击事件
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function(e) {
            const href = this.getAttribute('href');

            // 如果未登录，跳转到登录页面
            if (!checkAuth() && !href.includes('login.html')) {
                e.preventDefault();
                window.location.href = 'login.html';
            }
        });
    });
});