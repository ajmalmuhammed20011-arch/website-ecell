-- E-Cell SBCE schema. Run in the Supabase SQL editor.
create extension if not exists pgcrypto;
create table if not exists public.members (
 id uuid primary key default gen_random_uuid(), full_name text not null check(char_length(full_name) between 2 and 100), email text not null unique check(char_length(email)<=254),
 phone text check(phone is null or char_length(phone)<=25), department text check(department is null or char_length(department)<=100), year text check(year is null or char_length(year)<=30),
 why_join text check(why_join is null or char_length(why_join)<=1000), created_at timestamptz not null default now());
create table if not exists public.ideas (
 id uuid primary key default gen_random_uuid(), name text not null check(char_length(name) between 2 and 100), email text not null check(char_length(email)<=254),
 idea_title text not null check(char_length(idea_title) between 3 and 160), description text not null check(char_length(description) between 20 and 3000),
 stage text check(stage is null or stage in ('Just an idea','Exploring','Already building')), created_at timestamptz not null default now());
create table if not exists public.messages (
 id uuid primary key default gen_random_uuid(), name text not null check(char_length(name) between 2 and 100), email text not null check(char_length(email)<=254),
 message text not null check(char_length(message) between 10 and 2000), created_at timestamptz not null default now());
create table if not exists public.site_stats(key text primary key,value bigint not null default 0 check(value>=0));
insert into public.site_stats(key,value) values('visits',0) on conflict(key) do nothing;
insert into public.site_stats(key,value) values('members',0) on conflict(key) do nothing;
create table if not exists public.team_members (
 id text primary key, name text not null, position text not null, team text not null check(team in ('Leadership','Program Coordination','Marketing','Design','Documentation')),
 image_url text, instagram text, linkedin text, bio text, sort_order int not null default 0);
create table if not exists public.events (
 id uuid primary key default gen_random_uuid(), slug text unique not null, title text not null, date date, venue text, category text, description text, speaker text,
 status text not null check(status in ('upcoming','completed')), cover_image text, photos text[] not null default '{}', highlights text[] not null default '{}');
create table if not exists public.gallery(id uuid primary key default gen_random_uuid(),image text not null,category text not null,event_slug text,date date);
create table if not exists public.opportunities(id uuid primary key default gen_random_uuid(),title text not null,description text not null,apply_url text,published boolean not null default false);
create table if not exists public.admin_users(email text primary key);
alter table public.members enable row level security;
alter table public.ideas enable row level security;
alter table public.messages enable row level security;
alter table public.team_members enable row level security;
alter table public.events enable row level security;
alter table public.gallery enable row level security;
alter table public.opportunities enable row level security;
alter table public.site_stats enable row level security;
alter table public.admin_users enable row level security;
drop policy if exists "public aggregate stats read" on public.site_stats;
create policy "public aggregate stats read" on public.site_stats for select to anon,authenticated using(key in ('members','visits'));
drop policy if exists "public member applications insert" on public.members;
create policy "public member applications insert" on public.members for insert to anon,authenticated with check(true);
drop policy if exists "public idea submissions insert" on public.ideas;
create policy "public idea submissions insert" on public.ideas for insert to anon,authenticated with check(true);
drop policy if exists "public contact messages insert" on public.messages;
create policy "public contact messages insert" on public.messages for insert to anon,authenticated with check(true);
drop policy if exists "public team read" on public.team_members;
create policy "public team read" on public.team_members for select to anon,authenticated using(true);
drop policy if exists "public events read" on public.events;
create policy "public events read" on public.events for select to anon,authenticated using(true);
drop policy if exists "public gallery read" on public.gallery;
create policy "public gallery read" on public.gallery for select to anon,authenticated using(true);
drop policy if exists "public published opportunities read" on public.opportunities;
create policy "public published opportunities read" on public.opportunities for select to anon,authenticated using(published=true);
create or replace function public.is_ecell_admin() returns boolean language sql stable security definer set search_path=''
as $$ select exists(select 1 from public.admin_users a where lower(a.email)=lower(coalesce(auth.jwt()->>'email',''))); $$;
revoke all on function public.is_ecell_admin() from public;
grant execute on function public.is_ecell_admin() to authenticated;
drop policy if exists "admin member submissions read" on public.members;
create policy "admin member submissions read" on public.members for select to authenticated using(public.is_ecell_admin());
drop policy if exists "admin idea submissions read" on public.ideas;
create policy "admin idea submissions read" on public.ideas for select to authenticated using(public.is_ecell_admin());
drop policy if exists "admin contact messages read" on public.messages;
create policy "admin contact messages read" on public.messages for select to authenticated using(public.is_ecell_admin());
drop policy if exists "admin team insert" on public.team_members;
create policy "admin team insert" on public.team_members for insert to authenticated with check(public.is_ecell_admin());
drop policy if exists "admin team update" on public.team_members;
create policy "admin team update" on public.team_members for update to authenticated using(public.is_ecell_admin()) with check(public.is_ecell_admin());
drop policy if exists "admin team delete" on public.team_members;
create policy "admin team delete" on public.team_members for delete to authenticated using(public.is_ecell_admin());
drop policy if exists "admin events insert" on public.events;
create policy "admin events insert" on public.events for insert to authenticated with check(public.is_ecell_admin());
drop policy if exists "admin events update" on public.events;
create policy "admin events update" on public.events for update to authenticated using(public.is_ecell_admin()) with check(public.is_ecell_admin());
drop policy if exists "admin events delete" on public.events;
create policy "admin events delete" on public.events for delete to authenticated using(public.is_ecell_admin());
drop policy if exists "admin gallery insert" on public.gallery;
create policy "admin gallery insert" on public.gallery for insert to authenticated with check(public.is_ecell_admin());
drop policy if exists "admin gallery update" on public.gallery;
create policy "admin gallery update" on public.gallery for update to authenticated using(public.is_ecell_admin()) with check(public.is_ecell_admin());
drop policy if exists "admin gallery delete" on public.gallery;
create policy "admin gallery delete" on public.gallery for delete to authenticated using(public.is_ecell_admin());
drop policy if exists "admin opportunities insert" on public.opportunities;
create policy "admin opportunities insert" on public.opportunities for insert to authenticated with check(public.is_ecell_admin());
drop policy if exists "admin opportunities update" on public.opportunities;
create policy "admin opportunities update" on public.opportunities for update to authenticated using(public.is_ecell_admin()) with check(public.is_ecell_admin());
drop policy if exists "admin opportunities delete" on public.opportunities;
create policy "admin opportunities delete" on public.opportunities for delete to authenticated using(public.is_ecell_admin());
-- No public SELECT policies on member, idea, or message submissions.
create or replace function public.member_count() returns bigint language sql stable security definer set search_path=''
as $$ select count(*)::bigint from public.members; $$;
revoke all on function public.member_count() from public;
grant execute on function public.member_count() to anon,authenticated;
create or replace function public.increment_visit() returns bigint language sql security definer set search_path=''
as $$ update public.site_stats set value=value+1 where key='visits' returning value; $$;
revoke all on function public.increment_visit() from public;
grant execute on function public.increment_visit() to anon,authenticated;
create or replace function public.get_visit_count() returns bigint language sql stable security definer set search_path=''
as $$ select value from public.site_stats where key='visits'; $$;
revoke all on function public.get_visit_count() from public;
grant execute on function public.get_visit_count() to anon,authenticated;
create or replace function public.sync_member_count() returns trigger language plpgsql security definer set search_path=''
as $$ begin update public.site_stats set value=(select count(*) from public.members) where key='members'; return null; end; $$;
drop trigger if exists members_sync_public_count on public.members;
create trigger members_sync_public_count after insert or delete on public.members for each statement execute function public.sync_member_count();
insert into public.site_stats(key,value) values('members',(select count(*) from public.members)) on conflict(key) do update set value=excluded.value;
-- Safe content can be subscribed to without exposing member records or emails.
do $$ begin
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='events') then execute 'alter publication supabase_realtime add table public.events'; end if;
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='team_members') then execute 'alter publication supabase_realtime add table public.team_members'; end if;
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='site_stats') then execute 'alter publication supabase_realtime add table public.site_stats'; end if;
end $$;
