-- ============================================================
-- MANADA — esquema de base de datos para Supabase
-- Corré todo este archivo en: Supabase → SQL Editor → New query → Run
-- ============================================================

-- Tabla de casos reportados (perros a rescatar)
create table if not exists alerts (
  id text primary key,
  desc text not null,
  urgency text not null default 'media',        -- 'alta' | 'media' | 'baja'
  zone text not null,
  notes text default '',
  contact_name text not null,
  contact_phone text not null,
  lat double precision,
  lng double precision,
  status text not null default 'activo',        -- 'activo' | 'resuelto'
  helpers jsonb not null default '[]',           -- [{id, name}, ...]
  created_at bigint not null
);

-- Tabla de voluntarios
create table if not exists volunteers (
  id text primary key,
  name text not null,
  phone text not null,
  zone text not null,
  radius_km integer not null default 5,
  help_types jsonb not null default '[]',        -- ["rescate","traslado",...]
  lat double precision,
  lng double precision,
  created_at bigint not null
);

-- Tabla de veterinarias sumadas a la red
create table if not exists vets (
  id text primary key,
  name text not null,
  phone text not null,
  zone text not null,
  urgency text not null default '24h',           -- '24h' | 'horario'
  created_at bigint not null
);

-- ============================================================
-- Row Level Security (RLS)
-- Esta app es pública y sin login: cualquiera que abra la web puede
-- leer, publicar y actualizar casos/voluntarios/veterinarias.
-- Es la forma más simple de arrancar. Si más adelante querés
-- restringir quién puede borrar o editar, agregá autenticación
-- de Supabase y cambiá estas policies para chequear auth.uid().
-- ============================================================

alter table alerts enable row level security;
alter table volunteers enable row level security;
alter table vets enable row level security;

create policy "alerts_public_select" on alerts for select using (true);
create policy "alerts_public_insert" on alerts for insert with check (true);
create policy "alerts_public_update" on alerts for update using (true);

create policy "volunteers_public_select" on volunteers for select using (true);
create policy "volunteers_public_insert" on volunteers for insert with check (true);
create policy "volunteers_public_update" on volunteers for update using (true);

create policy "vets_public_select" on vets for select using (true);
create policy "vets_public_insert" on vets for insert with check (true);
create policy "vets_public_update" on vets for update using (true);

-- ============================================================
-- Índices útiles (opcional, mejora performance con muchos registros)
-- ============================================================
create index if not exists alerts_status_idx on alerts(status);
create index if not exists alerts_created_idx on alerts(created_at desc);
