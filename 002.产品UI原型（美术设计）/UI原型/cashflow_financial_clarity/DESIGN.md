---
name: CashFlow Financial Clarity
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#434653'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#737784'
  outline-variant: '#c3c6d5'
  surface-tint: '#1d59c1'
  primary: '#003c90'
  on-primary: '#ffffff'
  primary-container: '#0f52ba'
  on-primary-container: '#bcceff'
  inverse-primary: '#b0c6ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#870011'
  on-tertiary: '#ffffff'
  tertiary-container: '#b0111e'
  on-tertiary-container: '#ffbfba'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d9e2ff'
  primary-fixed-dim: '#b0c6ff'
  on-primary-fixed: '#001945'
  on-primary-fixed-variant: '#00419c'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdad7'
  tertiary-fixed-dim: '#ffb3ad'
  on-tertiary-fixed: '#410004'
  on-tertiary-fixed-variant: '#930013'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
  income-emerald: '#10B981'
  expense-rose: '#EF4444'
  background-light: '#F8FAFC'
  surface-dark: '#0F172A'
  accent-blue: '#3B82F6'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
  data-mono:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 48px
  container-max-width: 1280px
---

## Brand & Style

The design system for this personal finance management platform is built on the pillars of **security, efficiency, and clarity**. It targets a demographic of professionals and students who require a tool that feels as reliable as a banking institution but as intuitive and accessible as a modern productivity app.

The chosen aesthetic is **Corporate Minimalism**. This style leverages generous whitespace to reduce cognitive load, high-quality typography to ensure financial data is legible at a glance, and a card-based architecture that organizes complex information into digestible modules. To evoke a sense of modern precision, the system uses subtle depth through soft ambient shadows rather than heavy borders, creating a layered, professional interface that feels "light" despite the density of financial data.

**Key Brand Traits:**
- **Secure:** Solid colors and structured layouts reinforce stability.
- **Efficient:** Quick-action patterns and high-density data views for power users.
- **User-Friendly:** Approachable language paired with clear visual metaphors for income and expenses.

## Colors

The color strategy is functional and semantic, designed to provide immediate feedback on financial health.

- **Primary (Trustworthy Blue):** Used for navigation, primary buttons, and brand reinforcement. It communicates stability and professionalism.
- **Income (Emerald Green):** A vibrant, positive green reserved strictly for positive cash flow, growth indicators, and "Add Income" actions.
- **Expenses (Soft Red/Rose):** A clear but non-alarming red used for outflows, budget alerts, and "Add Expense" actions.
- **Neutral (Slate/Gray):** A sophisticated palette of grays handles text hierarchy and background surfaces. 

**Dark Mode Support:** In dark mode, the background shifts to a deep navy-slate (`#0F172A`), and the semantic greens and reds are slightly desaturated to maintain accessibility and prevent eye strain while preserving their functional meaning.

## Typography

Typography is the core of the financial experience. We use a trio of fonts to balance character with utility:

1.  **Hanken Grotesk (Headlines):** A sharp, contemporary sans-serif that gives the product a modern "fintech" edge.
2.  **Inter (Body):** The industry standard for readability. Used for all UI labels, descriptions, and long-form content.
3.  **JetBrains Mono (Financial Data):** Tabular figures are essential for comparing prices and dates. This monospaced font is used for transaction amounts and account balances to ensure numbers align perfectly in lists and tables.

**Scale and Hierarchy:**
Use `display-lg` for dashboard balance overviews. Use `label-caps` for small metadata like "Transaction Date" or "Category." All financial figures should utilize the `data-mono` style for maximum clarity.

## Layout & Spacing

The design system utilizes a **12-column fluid grid** for desktop and a **4-column grid** for mobile. 

- **The Card System:** Information is grouped into cards. On desktop, these cards span multiple columns (e.g., the main chart spans 8 columns, while the recent transactions list spans 4).
- **Rhythm:** We follow a 4px base unit. Component padding should generally be `16px` (4 units) or `24px` (6 units) to maintain a spacious, breathable feel.
- **Responsiveness:** On mobile devices, sidebars collapse into bottom navigation or a hamburger menu. Cards stack vertically, and horizontal margins shrink from 48px to 16px to maximize screen real estate for data tables.

## Elevation & Depth

Depth is used sparingly to indicate interactivity and hierarchy. The system relies on **Ambient Shadows** and **Tonal Layering**:

- **Level 0 (Background):** The base canvas (`#F8FAFC`). No shadow.
- **Level 1 (Default Card):** Used for standard data containers. A very soft, diffused shadow (0px 4px 12px rgba(0,0,0,0.05)) helps the card lift slightly from the background.
- **Level 2 (Active/Hover):** When a user hovers over a transaction or interactive card, the shadow tightens and deepens slightly to indicate "pick-up."
- **Level 3 (Modals/Popovers):** Used for "Add Transaction" forms. These utilize a high-blur shadow and a 20% black backdrop overlay to focus the user's attention.

In **Dark Mode**, elevation is communicated via "Tonal Elevation"—higher-level surfaces are slightly lighter shades of navy/gray rather than using pure black shadows.

## Shapes

The shape language is **Rounded (Level 2)**, striking a balance between the friendliness of a consumer app and the structure of a professional tool.

- **Standard Elements:** Buttons, input fields, and small cards use a `0.5rem` (8px) corner radius.
- **Large Containers:** Main dashboard cards and modals use `rounded-lg` (16px) to feel more prominent and modern.
- **Interactive Indicators:** Small badges (e.g., "Category" tags) use a full pill-shape (`rounded-xl` or 100px) to distinguish them from actionable buttons.

## Components

### Buttons
- **Primary:** Solid Primary Blue with white text. High emphasis.
- **Success/Income:** Solid Emerald Green.
- **Danger/Expense:** Solid Rose Red.
- **Secondary:** Ghost style with a subtle 1px border of the Neutral color.

### Input Fields
Inputs should be large and accessible. Use a subtle `1px` border that turns Primary Blue on focus. Labels should always be visible above the field using `body-sm` weight 600.

### Cards
Cards are the primary container. They must include a consistent `24px` internal padding. Titles within cards should use `title-md`.

### Chips & Tags
Use for transaction categories (e.g., "Food", "Rent"). These use a low-opacity background of the category's color with high-contrast text.

### Data Lists (Transactions)
Each row should have a subtle hover state. The amount column should always use the `data-mono` typography and be right-aligned for easy scanning.

### Progress Bars (Budgeting)
Use a background of Neutral-light. The fill color should transition from Emerald (under 70% budget) to Amber (70-90%) to Rose (over 90%).