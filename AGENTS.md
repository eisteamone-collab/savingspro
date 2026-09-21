# Savings Pro — Base44 Dev Notes

## What this is
A single-file static web app (`index.html`) — vanilla HTML/CSS/JS, no build step, no backend, no dependencies. A "Savings Pro" savings-wallet demo with landing page, member/admin login, dashboard, withdrawals, and wallet loads. All state lives in `localStorage`.

## How it runs here
Served by `nginx:alpine` via `docker-compose.base44.yml`, bind-mounting the repo to `/usr/share/nginx/html` and exposing host port 3000. No live-reload server needed — edits to `index.html` appear on browser refresh (call `reload_preview` after edits).

## No secrets / no external services
No credentials required. All data is client-side in `localStorage`.

## Verification
- `curl -s localhost:3000 | grep -q "Savings Pro"` confirms the page is served.
- Login as admin: username `Tan`, password `heyhey`.
- Login as member: username `juan`/`maria`/`pedro`, password `demo`.
