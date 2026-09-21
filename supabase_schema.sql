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
  role      text default 'Member',
  balance   numeric default 0,
  loaded    numeric default 0,
  gcash     text default '',
  status    text default 'Active',
  joined    date default current_date
);

-- Withdrawals table
create table if not exists public.withdrawals (
  id         text primary key,
  user_id    uuid references public.profiles(id) on delete cascade,
  user_name  text,
  amount     numeric,
  gcash      text,
  status     text default 'Pending',
  date       date
);

-- Loads table
create table if not exists public.loads (
  id         text primary key,
  user_id    uuid references public.profiles(id) on delete cascade,
  user_name  text,
  amount     numeric,
  date       date
);

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
$$ language security definer;

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
