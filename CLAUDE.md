# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此代码库中工作时提供指导。

## 项目概述

这是一个名为 **CashFlow** - 个人财务记账管理助手 的个人财务管理应用程序。项目目前包含：

1. 一份详细的多平台财务管理系统的产品需求文档（PRD），中文版本
2. 一个展示核心功能的 HTML 原型

## Current Implementation

### HTML 原型 (001.产品PRD(产品经理)\个人财务记账管理产品HTML版.html)
- **技术栈**：纯 HTML + CSS + JavaScript（无框架）
- **数据存储**：localStorage 持久化存储
- **响应式设计**：移动优先的 CSS Grid 和 Flexbox 方案
- **已实现的核心功能**：
  - 收入/支出记录表单
  - 带删除功能的交易列表
  - 月度余额计算
  - 基于分类的支出跟踪与可视化进度条
  - 基础统计（月度交易数、平均支出、主要分类）
  - 日期格式化（今天/昨天/天数前）
  - 用户反馈的 Toast 提示

### Key Architecture Patterns

#### 数据模型
```javascript
transaction = {
  id: Date.now(),           // 唯一标识符
  type: 'income'|'expense', // 交易类型
  amount: number,          // 交易金额
  category: string,        // 分类（餐饮、交通、购物等）
  description: string,     // 交易描述
  date: string,            // YYYY-MM-DD 格式
  notes: string,          // 可选备注
  timestamp: string        // 创建时间的 ISO 格式
}
```

#### 存储模式
- 所有数据以 JSON 格式存储在 localStorage 中
- 每笔交易后自动持久化
- 从空存储优雅地初始化

#### UI 模式
- 使用 CSS 自定义属性进行主题化
- 适应移动设备的响应式网格布局
- 基于组件的 CSS 类（.card、.transaction-item 等）
- 无外部依赖或 CDN 依赖

## 开发指南

### 运行应用程序
1. 直接在网页浏览器中打开 `001.产品PRD(产品经理)\个人财务记账管理产品HTML版.html`
2. 无需构建过程或服务器 - 静态 HTML 文件
3. 初始加载后可离线使用

### 功能开发
- 遵循现有的 CSS 自定义属性模式进行主题化
- 保持 localStorage 用于数据持久化
- 确保移动优先的响应式设计
- 使用语义化的 HTML5 元素
- 保持 JavaScript 函数式风格，避免基于类的模式

### 代码风格
- CSS：使用自定义属性（--primary-color、--danger-color 等）
- JavaScript：使用 ES6+ 特性，避免 jQuery 风格
- HTML：使用具有适当可访问性属性的语义化元素
- 保持关注点分离（HTML 结构、CSS 表现、JS 行为）

### 测试注意事项
- 在 Chrome、Safari 和 Firefox 中测试
- 验证在各种屏幕尺寸上的移动响应性
- 测试不同浏览器的 localStorage 行为
- 检查表单验证和错误处理

## 未来开发路线图

基于 PRD，项目计划通过以下阶段发展：

### 第一阶段：Web 增强版（当前）
- ✅ 基础 HTML 原型
- 🔄 云端数据同步
- 🔄 用户认证系统
- 🔄 多用户共享账户

### 第二阶段：移动应用（计划中）
- iOS 应用（Swift + SwiftUI）
- Android 应用（Kotlin + Jetpack Compose）
- 推送通知
- 条形码扫描快速记账

### 第三阶段：微信小程序
- 小程序开发
- 社交分享功能
- 微信支付集成

### 第四阶段：高级功能
- AI 驱动的财务洞察
- 投资跟踪
- 家庭财务管理
- 高级报告和 PDF 导出

## 数据迁移注意事项
- 当前的 localStorage 格式简单且可扩展
- 未来迁移到后端时应保留所有交易字段
- 实现认证时考虑添加用户 ID 字段
- 为用户安全计划数据导入/导出功能

## 可访问性和性能
- 当前实现具有基本的移动响应性
- 未来迭代应添加 ARIA 标签和键盘导航
- 性能已优化为简洁性 - 无大型库
- 由于无外部依赖，加载时间最小化