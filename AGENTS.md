# Savings Pro — Base44 Dev Notes

## Overview
Single-file vanilla JS SPA (`index.html`) — a savings wallet system. Uses Supabase for Auth + database when configured, falls back to localStorage with seed data when not.

## Architecture
- **Frontend**: `index.html` — all HTML, CSS, and JS in one file. Supabase JS client loaded via CDN.
- **Backend**: Supabase (Auth + Postgres database). Tables: `profiles`, `withdrawals`, `loads`. See `supabase_schema.sql`.
- **Config**: `config.js` (generated at runtime from env vars by `entrypoint.sh` in Docker, or `build.sh` on Vercel).
- **Serving**: `docker-compose.base44.yml` — nginx:alpine with entrypoint.sh that generates config.js from env vars.
- **Fallback**: When Supabase credentials are placeholders, app uses localStorage with seed data (admin: Tan/heyhey, members: juan/demo, maria/demo, pedro/demo).

## Deployment
- **GitHub**: Connected. Code pushed to working branch.
- **Vercel**: `vercel.json` + `build.sh` generate `config.js` at build time from env vars. Set SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY in Vercel project settings.
- **Supabase**: Run `supabase_schema.sql` in Supabase SQL Editor to create tables + RLS policies. Create admin user via app registration then `UPDATE profiles SET role='Admin' WHERE username='Tan'`.

## Secrets (in /run/base44/app.env)
- `SUPABASE_URL` — Supabase project URL
- `SUPABASE_ANON_KEY` — Supabase anon/public key (client-side)
- `SUPABASE_SERVICE_KEY` — Supabase service_role key (admin operations: creating members)
- `CLOUDINARY_CLOUD_NAME` — Cloudinary cloud name (for receipt image uploads, saves Supabase egress)
- `CLOUDINARY_UPLOAD_PRESET` — Cloudinary unsigned upload preset name

## Roles
- **Admin**: Dashboard, Members, Wallet Loads, Withdrawals, Monitoring, Profile. Can load wallets, mark withdrawals paid, add members (uses service key).
- **Member**: Dashboard, Total Withdrawal, My Profile. Can request withdrawals, edit profile/GCash.

## Key Functions
- `initSB()` — checks if Supabase credentials are real; sets `useSB` flag
- `loadData()` — async fetch from Supabase (profiles, withdrawals, loads)
- `checkSession()` — restores Supabase auth session on page load
- `loginAction()` / `registerAction()` — Supabase Auth (email = username + "@savingspro.app")
- `submitLoad()` / `submitWithdrawal()` / `pay()` — async DB mutations
- `addMember()` — uses sbAdmin (service key) to create auth user + profile
- `go(page)` — navigation (signs out on auth pages)

## Verification
1. `docker compose -f docker-compose.base44.yml up -d`
2. Curl `http://localhost:3000/` → 200
3. Without real Supabase credentials: app uses localStorage, login as Tan/heyhey
4. With real Supabase credentials: run supabase_schema.sql, register, set admin role
