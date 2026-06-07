-- Schema inicial — Semana 1
-- Tablas mínimas para el happy path: recibir mensaje → guardar → responder
-- Fecha: 2026-06-03

-- ============================================================
-- TABLA: leads
-- Cada persona que entra al sistema como lead potencial.
-- phone es UNIQUE porque una misma persona no debe tener dos leads activos.
-- No usamos phone como PK (ver CLAUDE.md sección 6.2): usamos UUID.
-- ============================================================
CREATE TABLE leads (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  phone       TEXT        NOT NULL UNIQUE,
  name        TEXT,
  status      TEXT        NOT NULL DEFAULT 'new',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLA: messages
-- Cada mensaje individual, entrante (inbound) o saliente (outbound).
-- lead_id es nullable en V1: en el happy path mínimo guardamos el mensaje
-- incluso antes de tener el lead creado. Se rellena en sesión 2.
-- twilio_sid es el ID único que Twilio le da a cada mensaje.
-- ============================================================
CREATE TABLE messages (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id     UUID        REFERENCES leads(id),
  direction   TEXT        NOT NULL CHECK (direction IN ('inbound', 'outbound')),
  body        TEXT        NOT NULL,
  twilio_sid  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLA: events
-- Log de todo lo que ocurre en el sistema.
-- Es la fuente de métricas definida en PRODUCT.md sección 5.
-- payload es JSONB: admite cualquier estructura JSON, indexable y consultable.
-- ============================================================
CREATE TABLE events (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  type        TEXT        NOT NULL,
  lead_id     UUID        REFERENCES leads(id),
  payload     JSONB,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Supabase activa RLS por defecto. Con RLS activo y sin políticas,
-- todas las queries devuelven 0 filas o error silencioso.
-- En V1 (una sola clínica, acceso interno vía service_role key) lo desactivamos.
-- En V2 multi-clínica, se activa con políticas por clínica.
-- ============================================================
ALTER TABLE leads    DISABLE ROW LEVEL SECURITY;
ALTER TABLE messages DISABLE ROW LEVEL SECURITY;
ALTER TABLE events   DISABLE ROW LEVEL SECURITY;

-- ============================================================
-- GRANTS
-- Crear tablas via SQL Editor no añade grants automáticamente.
-- service_role bypasea RLS pero igualmente necesita GRANT a nivel de tabla.
-- Sin esto: 403 Forbidden al insertar desde n8n aunque la key sea correcta.
-- ============================================================
GRANT ALL ON TABLE leads    TO service_role;
GRANT ALL ON TABLE messages TO service_role;
GRANT ALL ON TABLE events   TO service_role;
