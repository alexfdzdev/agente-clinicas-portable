# progress.md — Estado del proyecto

> Live document. Se actualiza al final de cada sesión.

---

## Sesión 1 — 2026-06-07 — Happy path mínimo Semana 1 ✓ COMPLETADO

### Qué se hizo

- Creado `.gitignore`.
- Creado `supabase/schema.sql` con 3 tablas: `leads`, `messages`, `events`. RLS desactivado. GRANTs a `service_role` añadidos (necesario para acceso desde API).
- Creado `n8n/workflows/whatsapp-receive.json`: workflow de 4 nodos.
- Desplegado y configurado en Railway + Supabase + Twilio sandbox.
- **Happy path verificado end-to-end:** WhatsApp → n8n → Supabase → respuesta fija de vuelta.

### Bugs encontrados y resueltos

- `$env` bloqueado en n8n → solución: credenciales pegadas directamente en el nodo (V1).
- `403 Forbidden` en Supabase → causa: GRANT de tabla faltante. El SQL Editor no añade GRANTs automáticamente al crear tablas. Fix: `GRANT ALL ON TABLE ... TO service_role`. Añadido al schema.sql.
- Body del mensaje llega vacío en Supabase → pendiente de investigar (los campos `Body` y `MessageSid` de Twilio no se están capturando bien en el nodo Code).

### Pendiente sesión 2

1. **Arreglar captura de body:** revisar los nombres exactos de los campos que envía Twilio en el webhook (posiblemente `body` en minúscula en vez de `Body`). Inspeccionar datos raw del webhook en n8n.
2. **Crear lead automáticamente:** upsert en tabla `leads` al recibir mensaje nuevo.
3. **Vincular lead_id al mensaje.**
4. **Primer log en tabla `events`.**

---

## Estado general del proyecto

| Componente | Estado |
|---|---|
| Schema Supabase | ✅ Desplegado y funcionando |
| Workflow n8n | ✅ Activo en Railway |
| Twilio sandbox | ✅ Configurado |
| Happy path end-to-end | ✅ Verificado |
| Body del mensaje WhatsApp | ⚠️ Llega vacío — fix en sesión 2 |
| Modelo LLM | 🔴 No empezado (semana 3) |
| RAG / Pinecone | 🔴 No empezado (semana 4) |
| Adaptador HubSpot | 🔴 No empezado (semana 4-5) |
| Despliegue producción | 🔴 No empezado (semana 5) |
