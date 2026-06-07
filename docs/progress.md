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

## Sesión 2 — 2026-06-07 — Pipeline completo: lead + mensaje + evento ✓ COMPLETADO

### Qué se hizo

- **Fix body vacío:** el payload de Twilio llega anidado bajo `body` en n8n. Corregido `$input.item.json['Body']` → `$input.item.json.body['Body']` en el nodo Code.
- **Descubierto workflow duplicado:** había dos workflows "whatsapp-receive" en n8n. El activo (`N0oslmsefxKuL4hL`) era diferente al que teníamos en el repo. Todos los cambios se aplicaron al activo correcto.
- **Upsert lead:** nuevo nodo HTTP que hace POST a `/rest/v1/leads?on_conflict=phone` con `Prefer: resolution=merge-duplicates,return=representation`. Crea el lead si no existe, devuelve el existente si ya está. No duplica.
- **lead_id vinculado al mensaje:** el nodo "Guardar mensaje" ahora referencia `$node["Upsert lead"].json.id` para enlazar cada mensaje con su lead.
- **Log en events:** nuevo nodo "Log evento" que registra `{ type: "message_received", lead_id, payload }` en la tabla `events` en cada mensaje recibido.
- **Flujo final verificado end-to-end:** WhatsApp → parsear → upsert lead → guardar mensaje con lead_id → log evento → responder.

### Bugs encontrados y resueltos

- `$env` bloqueado para nodos nuevos añadidos vía API → solución: hardcodear URL y service key igual que el nodo original.
- `duplicate key value violates unique constraint 'leads_phone_key'` → causa: faltaba `?on_conflict=phone` en la URL del upsert para que Supabase supiera qué columna usar como referencia de conflicto.
- `json[0].id` en vez de `json.id` → n8n desenvuelve automáticamente el array de Supabase; el primer elemento ya es el objeto directamente.

### Pendiente sesión 3

1. **System prompt del agente:** escribir el prompt base en `/agent/prompts.md`.
2. **Integrar modelo LLM (Groq/OpenRouter):** nuevo workflow o extensión del actual que llame al modelo y devuelva respuesta real en lugar del texto fijo de Twilio.
3. **Pasar historial de conversación** al modelo en cada turno (leer mensajes anteriores de Supabase).

---

## Estado general del proyecto

| Componente | Estado |
|---|---|
| Schema Supabase | ✅ Desplegado y funcionando |
| Workflow n8n | ✅ Activo en Railway |
| Twilio sandbox | ✅ Configurado |
| Happy path end-to-end | ✅ Verificado |
| Body del mensaje WhatsApp | ✅ Capturado correctamente |
| Pipeline lead + mensaje + evento | ✅ Funcionando end-to-end |
| Modelo LLM | 🔴 No empezado (semana 3) |
| RAG / Pinecone | 🔴 No empezado (semana 4) |
| Adaptador HubSpot | 🔴 No empezado (semana 4-5) |
| Despliegue producción | 🔴 No empezado (semana 5) |
