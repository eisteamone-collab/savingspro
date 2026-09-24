-- ──────────────────────────────────────────────
-- Savings Pro — Supabase Schema
-- Run this in: Supabase Dashboard > SQL Editor
-- ──────────────────────────────────────────────

-- Profiles table (extends auth.users)
create table if not exists public.profiles (
  id        uuid default gen_random_uuid() primary key,
  auth_id   uuid references auth.users(id) on delete cascade,
  name      text,
  username  text unique,
  password  text default '',
  role      text default 'Member',
  balance   numeric default 0,
  loaded    numeric default 0,
  gcash     text default '',
  gcash_name text default '',
  mobile    text default '',
  facebook  text default '',
  address   text default '',
  age       text default '',
  email     text default '',
  backup_mobile text default '',
  assigned_withdrawal numeric default 0,
  status    text default 'Active',
  joined    date default current_date
);

-- Add new columns if table already exists (safe to run anytime)
alter table public.profiles add column if not exists age text default '';
alter table public.profiles add column if not exists email text default '';
alter table public.profiles add column if not exists backup_mobile text default '';
alter table public.profiles add column if not exists gcash_name text default '';
alter table public.profiles add column if not exists mobile text default '';
alter table public.profiles add column if not exists facebook text default '';
alter table public.profiles add column if not exists address text default '';
alter table public.profiles add column if not exists assigned_withdrawal numeric default 0;

-- Withdrawals table
create table if not exists public.withdrawals (
  id         text primary key,
  user_id    uuid references public.profiles(id) on delete cascade,
  user_name  text,
  amount     numeric,
  charge     numeric default 0,
  gcash      text,
  status     text default 'Pending',
  date       date
);

-- Add charge column if table already exists (run once)
-- alter table public.withdrawals add column if not exists charge numeric default 0;

-- Loads table
create table if not exists public.loads (
  id         text primary key,
  user_id    uuid references public.profiles(id) on delete cascade,
  user_name  text,
  amount     numeric,
  date       date
);

-- Receipts table (member payment proof images, stored as compressed data URLs)
create table if not exists public.receipts (
  id         text primary key,
  user_id    uuid references public.profiles(id) on delete cascade,
  user_name  text,
  image      text,
  date       timestamptz default now()
);

-- Add receipts RLS (run once)
alter table public.receipts enable row level security;
create policy "read receipts"  on public.receipts for select to authenticated using (true);
create policy "insert receipt" on public.receipts for insert to authenticated with check (true);

-- ── Row Level Security ──
alter table public.profiles    enable row level security;
alter table public.withdrawals enable row level security;
alter table public.loads       enable row level security;

-- Profiles: authenticated users can read all, update own
create policy "read profiles"  on public.profiles  for select to authenticated using (true);
create policy "insert profile" on public.profiles  for insert to authenticated with check (true);
create policy "update profile" on public.profiles  for update to authenticated using (true);

-- Withdrawals: authenticated users can read/insert/update
create policy "read withdrawals"  on public.withdrawals for select to authenticated using (true);
create policy "insert withdrawal" on public.withdrawals for insert to authenticated with check (true);
create policy "update withdrawal" on public.withdrawals for update to authenticated using (true);

-- Loads: authenticated users can read/insert
create policy "read loads" on public.loads for select to authenticated using (true);
create policy "insert load" on public.loads for insert to authenticated with check (true);

-- ── Auto-create profile on signup (bypasses RLS) ──
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (auth_id, name, username, role, balance, loaded, gcash, status, joined)
  values (
    new.id,
    split_part(new.email, '@', 1),
    split_part(new.email, '@', 1),
    'Member',
    0, 0, '', 'Active',
    current_date
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ── Create Admin User ──
-- Option A: Register via the app (username: Tan), then run:
--   update public.profiles set role = 'Admin' where username = 'Tan';
--
-- Option B: Create directly in Supabase Dashboard > Authentication > Users > Add user
--   Email: Tan@savingspro.app  Password: heyhey
--   Then insert the profile:
--   insert into public.profiles (auth_id, name, username, role, status, joined)
--   select id, 'Tan', 'Tan', 'Admin', 'Active', current_date from auth.users where email = 'Tan@savingspro.app';
