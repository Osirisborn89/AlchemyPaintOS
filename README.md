# ⚔️ AlchemyPaintOS

**A Warhammer 40K Painting Reference System**

![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)
![Version](https://img.shields.io/badge/Version-v1.0.2-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Recipes](https://img.shields.io/badge/Recipes-401-gold)
![Factions](https://img.shields.io/badge/Factions-40-teal)

> An interactive dashboard to find painting recipes for Warhammer 40K armies using only paints you own.

---

## 📸 Features

✨ **401 Painting Recipes** — Complete paint-by-paint instructions for every faction  
🎨 **40 Faction Lore** — Grimdark descriptions and painting guidance  
⚡ **Lightning Fast** — Search any recipe in 35ms  
🔍 **Full-Text Search** — Find recipes by name, color, or technique  
📊 **Inventory Integration** — Filter recipes by paints you actually own  
🎯 **Step-by-Step Instructions** — 1,741 detailed painting steps  
🌐 **Zero Dependencies** — Pure HTML/CSS/JavaScript (no npm installs)  
📱 **Responsive Design** — Works on mobile, tablet, and desktop  
🚀 **Production Ready** — 100% data integrity, zero placeholders  

---

📖 Usage
Landing Page (index.html)
Search Recipes — Type paint name, color, or technique

Filter by Faction — Choose any of 40 factions from dropdown

View Details — Click any recipe to see full step-by-step instructions

Navigate to Lore — Click yellow LORE button for faction background

Lore Page (lore.html)
Browse Factions — Grimdark descriptions for all 40 factions

Learn Painting Tips — Faction-specific guidance

Return Home — Click green HOME button to go back to recipes

📁 Project Structure
text
AlchemyPaintOS/
├── 📄 index.html                 # Recipe dashboard (landing page)
├── 📄 lore.html                  # Faction lore encyclopedia
├── 🐍 server.py                  # Local Python dev server
├── 📄 README.md                  # This file
│
├── 📂 src/                       # Source code
│   ├── 📂 Data/                 # ⭐ Canonical data source (TRUTH)
│   │   ├── recipes.csv          # 401 recipes
│   │   ├── recipe_steps.csv     # 1,741 steps
│   │   └── inventory_export.csv # 315+ paints
│   ├── 📂 lore/                 # 40+ faction markdown files
│   ├── 📂 js/
│   │   └── data-loader.js
│   └── 📂 styles/
│       └── design-system.css
│
├── 📂 docs/                      # Documentation
│   ├── README.md
│   ├── HANDOVER.md
│   ├── ROADMAP.md
│   ├── CHANGELOG.md
│   └── ...
│
└── 📄 status-dashboard.html      # v1.0.2 status report

📅 Development Roadmap
Phase 1: MVP (COMPLETE ✅)
✅ v1.0.0 — Landing page + recipe dashboard

✅ v1.0.1 — Recipe descriptions refined

✅ v1.0.2 — Header UI enhanced

Phase 1.3: Core Features (Planned Jan 12-22)
🔄 v1.1.0 — Advanced filtering

🔄 v1.2.0 — Inventory calculator & shopping list

🔄 v1.3.0 — PDF export & print-friendly

🔄 v1.4.0 — User preferences & favorites

Phase 2: Backend (Planned Feb-Mar)
📋 v2.0.0 — Node.js REST API

📋 v2.1.0 — PostgreSQL database

Phase 3: Mobile (Planned Apr-Jun)
📋 v3.0.0 — React Native mobile app

🛠️ Technology Stack
Frontend — HTML5 + CSS3 + Vanilla JavaScript

Backend — Python (dev server)

Data — CSV (portable, editable in Excel/LibreOffice)

Design — CSS Variables (dark theme, responsive)

📊 Current Status
Version: v1.0.2
Status: Production Ready ✅
Last Updated: January 10, 2026

Quick Stats
📦 401 painting recipes

🎨 40 faction descriptions

✏️ 1,741 step-by-step instructions

🖌️ 315+ paints in inventory

⚡ 92+ Lighthouse score

📖 Documentation
HANDOVER.md — Session handover

ROADMAP.md — Development roadmap

CHANGELOG.md — Version history

STATUS.md — Visual status dashboard

📜 License
MIT License — See LICENSE file for details

For the Emperor! ⚔️🌟

Made with 🖤 for Warhammer 40K painters

```
