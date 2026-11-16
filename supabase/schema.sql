-- Ecoa: tabelas e regras de segurança para login e sincronização.
-- Corre este ficheiro uma vez no SQL Editor do Supabase.

-- Um registo por vídeo da biblioteca de cada utilizador.
create table if not exists public.videos (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  id         text        not null,
  data       jsonb,
  updated_at timestamptz not null default now(),
  deleted    boolean     not null default false,
  primary key (user_id, id),
  -- limite de 2 MB por vídeo (legendas + progresso), para evitar abusos
  constraint videos_data_size check (data is null or pg_column_size(data) < 2000000)
);

-- Cada pessoa só vê e altera os seus próprios vídeos.
alter table public.videos enable row level security;

drop policy if exists "videos: ler os próprios" on public.videos;
drop policy if exists "videos: criar os próprios" on public.videos;
drop policy if exists "videos: alterar os próprios" on public.videos;
drop policy if exists "videos: apagar os próprios" on public.videos;

create policy "videos: ler os próprios" on public.videos
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "videos: criar os próprios" on public.videos
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "videos: alterar os próprios" on public.videos
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "videos: apagar os próprios" on public.videos
  for delete to authenticated using ((select auth.uid()) = user_id);

revoke all on public.videos from anon;
grant select, insert, update, delete on public.videos to authenticated;

-- Permite a cada pessoa apagar a sua conta (e, em cascata, os seus vídeos). Exigido pelo RGPD.
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'Sessão não iniciada';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Sessões, atividade diária, frases para rever e palavras guardadas.
create table if not exists public.records (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  kind       text        not null check (kind in ('session', 'activity', 'card', 'word')),
  id         text        not null,
  data       jsonb,
  updated_at timestamptz not null default now(),
  deleted    boolean     not null default false,
  primary key (user_id, kind, id),
  constraint records_data_size check (data is null or pg_column_size(data) < 200000)
);

alter table public.records enable row level security;

drop policy if exists "records: ler os próprios" on public.records;
drop policy if exists "records: criar os próprios" on public.records;
drop policy if exists "records: alterar os próprios" on public.records;
drop policy if exists "records: apagar os próprios" on public.records;

create policy "records: ler os próprios" on public.records
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "records: criar os próprios" on public.records
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "records: alterar os próprios" on public.records
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "records: apagar os próprios" on public.records
  for delete to authenticated using ((select auth.uid()) = user_id);

revoke all on public.records from anon;
grant select, insert, update, delete on public.records to authenticated;
