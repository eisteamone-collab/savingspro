# Savings Pro — Base44 Dev Notes

## Overview
Single-file vanilla JS SPA (`index.html`) — a savings wallet system. No build step, no dependencies. Served by nginx in Docker.

## Architecture
- **Frontend**: `index.html` — all HTML, CSS, and JS in one file. State managed via a global `state` object, persisted to `localStorage`.
- **No backend**: All data (users, withdrawals, loads) lives in `localStorage`. Seeded with demo data on first load.
- **Serving**: `docker-compose.base44.yml` mounts `index.html` into `nginx:alpine` on port 3000.

## Roles
- **Admin** (username: `Tan`, password: `heyhey`): Dashboard, Members, Wallet Loads, Withdrawals, Monitoring, Profile. Can load wallets, mark withdrawals paid, add members.
- **Member**: Dashboard, Total Withdrawal, My Profile. Can request withdrawals, view earnings, edit profile/GCash.

## Key Functions
- `go(page)` — navigation (resets auth for Landing/Login/Register)
- `loadModal()` / `withdrawModal()` — modal dialogs for admin loads / member withdrawals
- `submitLoad()` / `submitWithdrawal()` / `pay()` — core actions
- `save()` / `load()` — localStorage persistence

## Verification
1. `docker compose -f docker-compose.base44.yml up -d`
2. Curl `http://localhost:3000/` → 200
3. Login as admin (Tan/heyhey) → see admin dashboard with 6 nav items
4. Login as member (juan/demo) → see member dashboard with 3 nav items
