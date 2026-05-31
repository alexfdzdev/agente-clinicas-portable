# PRODUCT.md — Agente IA Portable para Clínicas

## 1. Qué es esto

Un agente IA conversacional que capta y cualifica leads de clínicas, agenda citas en tiempo real y envía recordatorios automáticos, **sin obligar a la clínica a cambiar de CRM**. Se conecta a cualquier CRM externo mediante una arquitectura de capa intermedia con adaptadores.

Es la versión portable del agente core de Anvil, diseñada para clínicas que ya tienen su propio CRM y no quieren migrar.

**Terminología:** a lo largo de este documento "agente" o "agente IA" se refiere al sistema completo. "Modelo LLM" o "modelo" se refiere a la pieza interna que genera texto. Definiciones completas en `CLAUDE.md` sección 2.

## 2. Para quién es

Clínicas privadas (estética, dental, fisioterapia, salud especializada) que ya cuentan con un CRM propio o de su agencia de marketing y necesitan automatizar la captación de leads sin tirar a la basura su sistema actual.

**Anti-perfil:** clínicas grandes con departamento IT propio que prefieren construir interno, y clínicas muy pequeñas (1 profesional, <20 citas/mes) que no justifican la inversión.

## 3. Qué hace el agente (V1)

### 3.1 Entrada de leads
- Recibe leads desde **formularios de Meta Ads** (Facebook/Instagram Leads).
- Recibe leads desde **formularios de Google Ads**.
- Recibe leads desde **chat web** integrado en la página de la clínica.
- Todos los leads se canalizan a una conversación de **WhatsApp** iniciada por el agente en menos de 5 minutos desde la entrada del lead.

**Requisito legal (responsabilidad de la clínica, documentado por nosotros):** los formularios deben capturar **teléfono móvil** y un **consentimiento explícito de comunicación por WhatsApp** conforme a RGPD. Sin teléfono y sin consentimiento, no se inicia conversación.

### 3.2 Conversación

En cada turno, el agente devuelve siempre un mensaje de texto al lead Y opcionalmente invoca **tools laterales** (consulta calendario, agenda cita, cualifica, deriva a humano). El patrón completo y la lista de tools disponibles está definido en `CLAUDE.md` sección 4.4.

Comportamiento esperado:

- Saluda al lead por su nombre y referencia el motivo de su consulta.
- Resuelve dudas sobre servicios, precios, condiciones, ubicación, profesionales, usando una base de conocimiento de la clínica (RAG sobre Pinecone).
- Cualifica al lead con preguntas conversacionales: tipo de tratamiento, urgencia, franja horaria preferida, primera vez o paciente recurrente.
- Detecta señales de no-fit (lead fuera de zona, lead buscando algo que la clínica no ofrece, lead claramente curioso sin intención) y los marca como `qualified: false` con razón explícita.
- Idioma de toda la conversación con el lead: **español neutro de España**. Idioma de los prompts internos del modelo: **español**. Ver `CLAUDE.md` sección 6.4.

### 3.3 Agendado
- Consulta disponibilidad en **Cal.com** en tiempo real (tool `check_availability`).
- Propone 2-3 huecos compatibles con la preferencia del lead.
- Confirma la cita y la crea en Cal.com con datos del lead (tool `book_appointment`).
- Envía confirmación con detalles (fecha, hora, ubicación, profesional, instrucciones previas si aplica).

### 3.4 Recordatorios
- Envía recordatorio automático **24 horas antes** de la cita.
- Envía recordatorio automático **1 hora antes** de la cita.
- Si el lead responde "no puedo / quiero cambiar", reabre la conversación y reagenda mediante la tool `reschedule_appointment`.

### 3.5 Persistencia
- Cada lead, conversación, cualificación y cita queda registrado en la capa intermedia (Supabase).
- La capa intermedia sincroniza con el CRM externo de la clínica mediante el adaptador correspondiente (HubSpot Free en la demo).

### 3.6 Manejo de fallos

Si un servicio externo cae (Twilio, modelo LLM, Cal.com, Pinecone, Supabase, HubSpot), el agente sigue la política definida en `CLAUDE.md` sección 6.5:

- Servicio crítico caído → mensaje preconfigurado al lead + alerta + estado `error_pendiente_revision`.
- Servicio no crítico caído → modo degradado documentado.

**Nunca fallback silencioso.** Un fallo siempre genera alerta y queda trazado.

## 4. Lo que NO hace (roadmap V2, no construir ahora)

- Seguimientos a leads que no agendaron en la primera conversación.
- Reenganche a leads fríos (más de X semanas sin actividad).
- Upsells y cross-sells post-tratamiento.
- Encuestas de satisfacción post-visita.
- Integración nativa con CRMs distintos al de la demo. El resto vía webhook genérico.
- Multi-idioma. V1 solo español.
- Multi-clínica con configuración independiente. V1 una clínica por instancia.

**Estas funcionalidades se mencionan en el portfolio como "roadmap visible", no como algo construido.**

## 5. Métricas que se miden (clave para portfolio)

El sistema instrumenta desde el día 1 estas métricas. Sin métricas, el caso de portfolio vale la mitad.

| Métrica | Qué mide | Por qué importa |
|---|---|---|
| **Tiempo de primera respuesta** | Segundos desde entrada del lead a primer mensaje | Vende solo: ningún humano contesta en 30 segundos |
| **% de leads que inician conversación** | Leads que responden al primer mensaje | Mide calidad del hook inicial |
| **% de leads cualificados** | Leads que pasan el filtro y son aptos para cita | Mide ahorro de tiempo del equipo humano |
| **% de leads agendados** | Leads que terminan con cita en calendario | Métrica norte del producto |
| **Tiempo medio de la conversación** | Desde primer mensaje a cita agendada | Mide eficiencia |
| **Tasa de no-show** | Citas agendadas que el lead no acude | Mide calidad de cualificación |
| **% de recordatorios efectivos** | Citas con recordatorio enviado que se cumplen | Justifica la feature de recordatorios |

**Cómo se mide:** todo se registra en Supabase con timestamps. Consultas SQL simples + exportación a Sheets para reportes en V1. Dashboard custom solo si llega a V2.

## 6. Stack técnico

El proyecto se construye en **dos fases** que comparten la misma arquitectura. Solo cambian los proveedores en cada capa, no el código de orquestación. Esto es posible porque la arquitectura es proveedor-agnóstica (ver `CLAUDE.md` sección 4.5).

### 6.1 Fase de construcción y aprendizaje (semanas 1-4) — coste 0€

- **Orquestación:** n8n self-hosted en Railway (free tier).
- **Modelo LLM:** Groq u OpenRouter, modelos gratuitos (Llama 3, Mistral).
- **Embeddings:** HuggingFace Sentence Transformers (free).
- **Vector store:** Pinecone (free tier, 1 índice).
- **Canal WhatsApp:** Twilio sandbox.
- **Calendario:** Cal.com (free).
- **Capa intermedia:** Supabase (free tier).
- **Adaptador CRM demo:** HubSpot Free.

### 6.2 Fase de producción y demo (semana 5 en adelante) — coste ~15€ totales hasta demo

Cambian solo los tres componentes que afectan a la calidad final:

- **Modelo LLM:** Claude Sonnet vía API Anthropic.
- **Embeddings:** OpenAI text-embedding-3-small.
- **Canal WhatsApp:** número Twilio real, comprado en cuenta Anvil ya verificada (2-5 días laborables de activación).

El resto del stack se mantiene en free tier.

**Importante:** la transición de Twilio sandbox a número real **no es transparente**. Requiere reconfigurar webhooks. Ver `CLAUDE.md` sección 4.5 y `/docs/costs.md`.

### 6.3 Coste mensual de una clínica real en producción

Cuando una clínica firme y empiece a recibir leads reales:

| Componente | Coste mensual estimado (100 leads/mes) |
|---|---|
| Claude API | 10-15€ |
| OpenAI embeddings | <1€ |
| Twilio (número + mensajes) | 5-10€ |
| Pinecone free | 0€ |
| Supabase free | 0€ |
| Railway / n8n | 0-5€ |
| Cal.com free | 0€ |
| **Total** | **~15-30€/mes por clínica activa** |

Estos costes los asume Anvil dentro de la cuota mensual que se cobra al cliente.

## 7. Decisión técnica clave (defendible en entrevista)

**Arquitectura desacoplada con capa intermedia y adaptadores por CRM.**

El agente nunca habla directamente con el CRM. El modelo LLM habla con n8n. n8n habla con una capa intermedia (Supabase + API) que registra todo. Esa capa tiene adaptadores (uno por CRM) que sincronizan los datos al CRM del cliente.

**Por qué esta decisión:**
- Permite "se integra con cualquier CRM" sin humo: cada nuevo CRM = un adaptador nuevo, no rehacer el agente.
- Aísla el agente de cambios en APIs de CRMs externos (que cambian a menudo).
- Facilita testing: el agente se puede probar sin tocar ningún CRM real.
- **Hace el sistema proveedor-agnóstico**: cambiar Groq por Claude o HuggingFace por OpenAI es cambiar configuración, no rediseñar.

**Trade-off honesto:** añade un componente más (la capa intermedia) que hay que mantener. A cambio gana toda la flexibilidad de integración y proveedor. Para un producto cuya promesa es "se conecta a cualquier CRM", es el trade-off correcto.

## 8. Roadmap de portfolio (entregables)

1. Sistema construido y desplegado en Railway, accesible vía webhook.
2. Demo grabada (Loom 2-3 min) mostrando: lead entra → agente conversa → cita agendada → recordatorio enviado → registro en HubSpot.
3. Repo público en GitHub con README claro (problema, solución, arquitectura, stack, instrucciones de despliegue, video demo).
4. Ficha de caso en web/LinkedIn siguiendo formato: problema, solución, decisión técnica, resultado, stack.
5. Métricas reales de las clínicas piloto o métricas de demo controlada con conversaciones simuladas.

## 9. Criterio de "terminado" para V1

V1 está terminado cuando:
- Un lead puede entrar desde formulario de Meta y terminar con cita agendada en Cal.com sin intervención humana.
- El recordatorio de 24h y 1h se dispara correctamente.
- Los datos quedan registrados en Supabase y replicados en HubSpot.
- La conversación del agente es indistinguible de un humano competente (probado con 5-10 conversaciones reales en stack de producción).
- Está documentado y desplegado en Railway.
- Hay métricas medibles desde Supabase.

Sin estos 6 puntos, no es V1, es WIP.

## 10. Misión paralela del proyecto: aprender

Este proyecto no es solo un caso de portfolio. Es también el vehículo para que **Alex aprenda los fundamentos técnicos** que sostienen este tipo de sistemas.

El objetivo no es convertir a Alex en programador, sino en alguien que:

- **Lee** código y entiende qué hace cada bloque.
- **Razona** sobre arquitecturas, decisiones técnicas y trade-offs.
- **Defiende** sus decisiones en entrevistas técnicas con autoridad real.
- **Detecta** cuándo Claude Code le está proponiendo algo malo, frankenstein o sobredimensionado.

Esta misión está implementada en el protocolo de aprendizaje definido en `CLAUDE.md` sección 9, con el comando de freno de la sección 10 como red de seguridad.

**Si una sesión termina con código funcionando pero Alex no entiende qué hace, esa sesión ha fracasado en la mitad de su propósito.**

El coste de esta misión es tiempo: construir entendiendo cada cosa lleva el doble que construir a ciegas. **Se asume ese coste explícitamente.**
