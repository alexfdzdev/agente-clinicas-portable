# ⚠️ INSTRUCCIÓN MAESTRA — LEER ANTES QUE NADA

Este es un proyecto de aprendizaje además de construcción.

## Paso 0: cómo arrancar cada sesión

Claude Code lee este archivo (`CLAUDE.md`) automáticamente al iniciar sesión, pero **NO lee automáticamente `PRODUCT.md` ni `/docs/progress.md`**. Por eso, **el primer mensaje de Alex en cada sesión debe usar esta plantilla**:

```
@PRODUCT.md @docs/progress.md @docs/learning.md

Léete estos tres archivos. Después dime qué hicimos la última sesión 
según progress.md y qué toca hoy. No avances hasta que confirme.
```

Sin esos `@`, Claude Code opera solo con CLAUDE.md y el protocolo de aprendizaje no se puede ejecutar correctamente.

## Pasos canónicos de cada sesión

**En cada sesión, antes de escribir o modificar una sola línea de código, ejecutas estos pasos en este orden:**

1. **Lee los archivos referenciados** por Alex con `@` (PRODUCT.md, progress.md, learning.md y cualquier otro que pase).

2. **Confirma la tarea.** Escribe: "Esta sesión vamos a hacer: [tarea concreta]. ¿Lo confirmo?". Espera "sí" de Alex.

3. **Explica el enfoque.** Escribe en lenguaje de negocio (no técnico) qué se va a construir, qué problema resuelve y cómo encaja con el resto del sistema. 2-4 frases.

4. **Lista herramientas y conceptos nuevos.** Si en esta sesión aparece algo técnico que no se ha visto antes en el proyecto (una librería, un patrón, una sintaxis, un concepto), nómbralo y explícalo. Una entrada por concepto, con el formato definido en la sección 9.3.

5. **Pide confirmación explícita.** Pregunta: "¿Entendido? ¿Avanzo a implementar?". Espera confirmación literal de Alex.

6. **Implementa.** Solo después de "sí" en el paso 5.

7. **Documenta al cerrar.** Al final de la sesión, antes de despedirte, actualiza `/docs/progress.md` y `/docs/learning.md` siguiendo el formato de la sección 9.

**Si te saltas cualquiera de los pasos 1-6, Alex tiene autorización para decir "PARA. Sección 9." y vuelves al paso correspondiente sin protestar ni justificarte.** Ver sección 10.

**No interpretes esta instrucción como "filosofía".** Es protocolo. Se ejecuta literal.

## La primera sesión es especial

**La sesión 1 no es de construcción, es de validación del protocolo.**

Primera instrucción de Alex a Claude Code el primer día:

```
@PRODUCT.md @docs/costs.md

Léete CLAUDE.md completo, PRODUCT.md y costs.md. Confírmame con tus 
palabras qué dice la sección 9 y la sección 10 de CLAUDE.md. Después 
simula que vamos a hacer la tarea "crear el schema inicial de Supabase" 
siguiendo paso a paso la check-list de la sección 9.3, pero NO implementes 
nada. Solo demuéstrame que entiendes el flujo.
```

Si Claude Code ejecuta esa simulación correctamente, el protocolo funciona y se puede empezar a construir en la sesión 2. Si se salta pasos o improvisa, se corrige antes de tocar código real.

---

# CLAUDE.md — Reglas del Proyecto

> Este archivo va en la raíz del repo. Claude Code lo lee automáticamente en cada sesión. Define la arquitectura, las convenciones y las reglas que cualquier código de este proyecto debe respetar. **Si una propuesta de código contradice este documento, hay que parar y discutirlo, no implementarla.**

---

## 1. Resumen del proyecto

Agente IA portable para clínicas que capta leads desde Meta/Google/Web, conversa por WhatsApp (Twilio), cualifica, agenda en Cal.com y envía recordatorios. Se integra con CRMs externos mediante adaptadores. Lectura completa del producto en `PRODUCT.md`.

## 2. Terminología (vinculante)

A lo largo de todo el proyecto, código y documentación, usar **siempre** estos términos:

| Término | Qué significa |
|---|---|
| **Agente IA** o **el agente** | El sistema completo visto desde fuera: lo que ve y con quien interactúa el lead. Incluye orquestador + modelo + RAG + capa intermedia. |
| **Modelo LLM** o **el modelo** | La pieza interna que genera texto: Claude Sonnet en producción, Groq/OpenRouter en aprendizaje. |
| **Lead** | Persona que ha dejado sus datos y aún no es paciente. |
| **Paciente** | Persona que ya ha tenido al menos una cita real. |
| **Conversación** | Hilo completo de mensajes entre un lead y el agente, con identificador único. |
| **Cita** | Reserva concreta en el calendario, con fecha, hora, servicio y profesional. |
| **Capa intermedia** | Supabase + sus tablas, donde vive el estado canónico del sistema. |
| **Adaptador** | Componente que sincroniza la capa intermedia con un CRM externo concreto (ej. HubSpot). |
| **Turno** | Una iteración del bucle: el lead envía un mensaje → el modelo genera `message_text` + tools → n8n ejecuta → se espera nuevo mensaje del lead (o nueva llamada al modelo si una tool devolvió resultado, ver 4.4). |

**No usar sinónimos.** No "bot", no "asistente", no "chatbot". El agente es el agente.

## 3. Filosofía de construcción

- **Simple antes que sofisticado.** Si una solución estándar funciona, no inventes una propia.
- **Modular antes que acoplado.** Cada componente hace una cosa y la hace bien. Si un componente conoce demasiado de otro, separar.
- **Documentado antes que ingenioso.** El próximo que lea esto (Alex en 2 semanas, o un entrevistador) tiene que entenderlo sin esfuerzo.
- **Funcional antes que completo.** Primero el happy path end-to-end. Después los edge cases.
- **Aprender antes que entregar.** Si Alex no entiende algo, no se construye encima. Ver sección 9.

## 4. Arquitectura

### 4.1 Componentes

```
┌─────────────────┐
│   CANALES       │  Meta Lead Ads · Google Forms · Web Chat
│   DE ENTRADA    │
└────────┬────────┘
         │ webhook
         ▼
┌─────────────────┐
│   ORQUESTADOR   │  n8n self-hosted (Railway)
│   (n8n)         │  Recibe leads, dispara conversaciones, programa recordatorios
└────────┬────────┘
         │
    ┌────┼────┬──────────────┬───────────────┐
    ▼    ▼    ▼              ▼               ▼
┌──────┐ ┌──────┐ ┌─────────────┐ ┌──────────────┐
│Twilio│ │ Cal  │ │  MODELO LLM │ │ CAPA INTER.  │
│ WApp │ │ .com │ │   + RAG     │ │  (Supabase)  │
│ API  │ │ API  │ │             │ │              │
└──────┘ └──────┘ └──────┬──────┘ └──────┬───────┘
                         │               │
                         ▼               ▼
                  ┌──────────────┐ ┌──────────────┐
                  │  PINECONE    │ │  ADAPTADOR   │
                  │  (RAG, base  │ │  HubSpot     │
                  │  conoc.)     │ │  (V1 demo)   │
                  └──────────────┘ └──────────────┘
```

### 4.2 Responsabilidades

| Componente | Responsabilidad única |
|---|---|
| **n8n** | Orquestación: recibe webhooks, dispara workflows, gestiona delays/recordatorios, ejecuta tools que el modelo solicita. NO contiene lógica de negocio compleja, NO genera respuestas. |
| **Modelo LLM + RAG** | Genera respuestas en lenguaje natural. Consulta Pinecone para info de la clínica. Decide qué tools laterales invocar (ver 4.4). NO toca el calendario ni el CRM directamente. |
| **Twilio WhatsApp** | Envío y recepción de mensajes. Punto. |
| **Cal.com API** | Lectura de disponibilidad y creación de citas. Punto. |
| **Pinecone** | Almacenamiento de embeddings de la base de conocimiento de la clínica. |
| **Supabase (capa intermedia)** | Registra leads, conversaciones, citas, estados. **Única fuente de verdad** del sistema. |
| **Adaptador HubSpot** | Sincroniza datos desde Supabase hacia HubSpot. NO se llama desde el modelo, se llama desde n8n cuando hay cambios en Supabase. |

**Regla de oro:** ningún componente conoce a más de 2 vecinos. Si n8n llama directamente a HubSpot saltándose Supabase, es un anti-patrón. Si el modelo toca Cal.com directamente, anti-patrón.

### 4.3 Flujo de datos canónico

1. Lead entra → webhook a n8n.
2. n8n registra lead en Supabase.
3. n8n dispara mensaje de WhatsApp inicial al lead vía Twilio.
4. Lead responde → webhook de Twilio a n8n.
5. n8n pasa contexto al modelo (LLM + RAG sobre Pinecone).
6. Modelo devuelve `message_text` + opcionalmente tools (ver 4.4).
7. n8n envía el `message_text` al lead vía Twilio y ejecuta las tools.
8. **Si alguna tool es "con retorno"** (check_availability, book_appointment, reschedule_appointment): n8n recoge el resultado y hace una nueva llamada al modelo pasándoselo como contexto. Vuelve al paso 6. Salvaguarda: máximo 3 ciclos consecutivos sin intervención del lead (ver 4.4).
9. n8n actualiza estado en Supabase.
10. Adaptador HubSpot lee cambios en Supabase y sincroniza al CRM.
11. Si se agendó cita, n8n programa los recordatorios (24h y 1h antes).

**Cualquier desviación de este flujo se discute, no se implementa.**

### 4.4 Output del modelo (patrón function calling)

Cada vez que el modelo procesa un turno, devuelve **siempre un objeto** con esta forma:

```json
{
  "message_text": "Lo que el agente le dice al lead. Siempre presente, nunca vacío.",
  "tools": [
    { "type": "tool_name", "params": { ... } },
    ...
  ]
}
```

**`message_text`** es obligatorio en todos los turnos. Es lo que el lead recibe por WhatsApp inmediatamente. No puede ser vacío. Si el modelo necesita "tiempo para procesar", lo dice ("dame un momento que te miro la disponibilidad").

**`tools`** es un array opcional. Puede estar vacío si el turno solo requiere conversación. Puede contener una o varias tools si el turno requiere acciones laterales. n8n envía el `message_text` al lead vía Twilio y ejecuta las tools simultáneamente. Cuando una tool sea "con retorno" (ver clasificación abajo), n8n hace una nueva llamada al modelo con el resultado.

### Tools disponibles (set cerrado)

Las tools se clasifican en dos tipos según si necesitan devolver resultado al modelo o no:

**Tools sin retorno (fire-and-forget):** n8n las ejecuta y registra el resultado en Supabase. No requieren nueva llamada al modelo. El siguiente turno empieza cuando el lead responde.

**Tools con retorno:** n8n las ejecuta, obtiene un resultado que el modelo necesita para continuar (ej: huecos disponibles, confirmación de cita), y hace una **segunda llamada inmediata al modelo** pasándole el resultado como contexto. El modelo genera entonces un nuevo turno (con nuevo `message_text` y opcionalmente más tools). Este ciclo puede encadenarse hasta que el modelo decida no invocar más tools con retorno y se quede esperando al lead.

| Tool (`type`) | Tipo | Qué hace | Parámetros (`params`) |
|---|---|---|---|
| `qualify` | Sin retorno | Marca al lead como cualificado o no cualificado | `qualified: true/false`, `reason` |
| `check_availability` | **Con retorno** | Pide a Cal.com los huecos disponibles. Devuelve lista de huecos | `date_range`, `service_type` |
| `book_appointment` | **Con retorno** | Crea cita en Cal.com. Devuelve confirmación con ID y datos finales | `datetime`, `service`, `lead_data` |
| `reschedule_appointment` | **Con retorno** | Cancela y crea nueva. Devuelve confirmación | `appointment_id`, `new_datetime` |
| `handoff_to_human` | Sin retorno | Marca la conversación para revisión humana y notifica | `reason`, `urgency` |
| `end_conversation` | Sin retorno | Cierra la conversación (lead no-fit, lead inactivo, etc.) | `reason` |

Si el modelo intenta usar una tool fuera de esta lista, n8n la rechaza, registra el evento como `unknown_tool` y notifica a canal de alertas. La conversación continúa con el `message_text` que sí venía.

Cada tool está documentada en `/agent/tools.md` con su esquema JSON exacto (qué params son obligatorios, qué validación tiene cada uno, qué devuelve si es con retorno).

### Salvaguarda anti-bucle

Para evitar bucles infinitos de "modelo invoca tool con retorno → resultado → modelo invoca otra tool con retorno → ...", n8n limita a **3 llamadas consecutivas al modelo** sin intervención del lead. Si se supera, n8n fuerza un `handoff_to_human` y notifica.

### Ejemplos de turno

**Ejemplo 1: lead pregunta por servicios.**
```json
{
  "message_text": "Hacemos limpieza dental por 45€, ortodoncia invisible desde 1.800€ y blanqueamiento por 250€. ¿Cuál te interesa?",
  "tools": []
}
```
Solo conversación, sin tools.

**Ejemplo 2: lead pide cita para mañana.**
```json
{
  "message_text": "Perfecto, déjame mirar qué huecos tenemos mañana.",
  "tools": [
    { "type": "check_availability", "params": { "date_range": "2026-06-01", "service_type": "limpieza_dental" } }
  ]
}
```
El agente responde inmediatamente Y dispara la consulta a Cal.com. Cuando n8n reciba el resultado, hará una nueva llamada al modelo con la disponibilidad y el modelo generará el siguiente turno con los huecos concretos.

**Ejemplo 3: lead confirma y agenda.**
```json
{
  "message_text": "Genial, te he agendado para mañana a las 17:00 con la Dra. García. Te llegará confirmación por WhatsApp.",
  "tools": [
    { "type": "book_appointment", "params": { "datetime": "2026-06-01T17:00", "service": "limpieza_dental", "lead_data": {...} } },
    { "type": "qualify", "params": { "qualified": true, "reason": "Primera cita agendada con éxito" } }
  ]
}
```
Una respuesta + dos tools en paralelo.

### 4.5 Proveedores intercambiables

La arquitectura es proveedor-agnóstica en tres puntos:

| Capa | Fase aprendizaje (gratis) | Fase producción |
|---|---|---|
| **Modelo LLM** | Groq / OpenRouter (modelos free) | Claude Sonnet API |
| **Embeddings** | HuggingFace Sentence Transformers | OpenAI text-embedding-3-small |
| **Twilio WhatsApp** | Sandbox compartido | Número real en cuenta Anvil verificada |

Cambiar de fase = cambiar configuración + API keys + reindexar Pinecone. **No cambiar arquitectura ni workflows de n8n.** Si el cambio requiere tocar la lógica del agente, está mal arquitecturado.

**Aviso sobre Twilio:** la transición del sandbox al número real **no es transparente**. El sandbox usa "join [palabra]" para que un usuario se active, y los webhooks apuntan al endpoint compartido de Twilio. El número real usa webhooks dedicados configurados a tu URL de n8n. La transición requiere reconfigurar webhooks en Twilio Console y actualizar el endpoint en n8n. Documentado en `/docs/deployment.md`.

## 5. Estructura del repositorio

```
/agente-clinicas-portable/
├── CLAUDE.md                  ← este archivo
├── PRODUCT.md                 ← qué hace el sistema
├── README.md                  ← para el portfolio público
├── /docs
│   ├── architecture.md        ← decisiones técnicas detalladas
│   ├── deployment.md          ← cómo desplegar paso a paso
│   ├── adapters.md            ← cómo añadir un adaptador de CRM nuevo
│   ├── costs.md               ← stack actual y homólogos de pago
│   ├── learning.md            ← log de aprendizaje (ver sección 9)
│   └── progress.md            ← qué se ha hecho, qué falta (live document)
├── /n8n
│   └── /workflows             ← exports de workflows de n8n en JSON
├── /agent
│   ├── prompts.md             ← prompts del agente (system prompt, ejemplos)
│   ├── tools.md               ← tools del agente con esquema JSON
│   └── knowledge-base/        ← documentos de la clínica para el RAG
├── /supabase
│   ├── schema.sql             ← schema de tablas
│   └── migrations/            ← cambios de schema versionados
├── /adapters
│   └── /hubspot
│       ├── README.md
│       └── workflow.json      ← workflow de n8n que sincroniza
└── /tests
    └── conversations/         ← conversaciones de prueba en formato markdown
```

**Regla:** archivos pequeños y enfocados. Si un workflow de n8n hace más de una responsabilidad lógica (no más de un número arbitrario de nodos), dividir. Si un documento markdown supera las 300 líneas, dividir.

## 6. Convenciones

### 6.1 Nombres
- Workflows de n8n: `[componente]-[acción]`. Ej: `whatsapp-receive`, `agent-respond`, `calendar-book`.
- Tablas en Supabase: snake_case, plural. Ej: `leads`, `conversations`, `appointments`, `reminders`, `events`.
- Variables en JS/JSON: camelCase.

### 6.2 Identificadores
- Cada lead tiene `lead_id` (UUID) generado en Supabase. **No usar el teléfono como identificador**, porque puede cambiar y porque un mismo teléfono puede ser dos leads distintos en momentos distintos.
- Cada conversación tiene `conversation_id`. Cada cita tiene `appointment_id`.

### 6.3 Logging
- Todos los eventos relevantes (lead recibido, mensaje enviado, cita creada, error) se loggean en una tabla `events` en Supabase con timestamp, tipo, payload.
- Esto es la base para las métricas del PRODUCT.md sección 5.

### 6.4 Idioma de prompts y mensajes
- **Todos los prompts del modelo LLM se escriben en español.** El system prompt, las instrucciones, los ejemplos few-shot. Los modelos generan mejor en el idioma del prompt y nuestros leads son hispanohablantes.
- Los mensajes de salida al lead siempre en español neutro de España.
- Los nombres de variables, archivos, tablas, workflows: en inglés (estándar técnico).
- Comentarios en código: español durante la fase de aprendizaje. Revisar al cerrar V1 si se mantiene español o se migra a inglés.

### 6.5 Errores y fallos de servicios externos
- Cualquier fallo en una llamada externa (Cal.com, HubSpot, Twilio, modelo LLM, Pinecone, Supabase) se reintenta 3 veces con backoff exponencial.
- Si tras 3 reintentos sigue fallando:
  - **Servicio crítico caído (Twilio, Supabase, modelo LLM):** el agente envía al lead un mensaje preconfigurado tipo "Estamos teniendo dificultades técnicas, un compañero te contactará en breve" y notifica a canal de alertas (email/Slack). Estado del lead: `error_pendiente_revision`.
  - **Servicio no crítico caído (Pinecone, HubSpot adaptador):** el sistema sigue funcionando en modo degradado. Pinecone caído → modelo responde sin contexto RAG, marcando la respuesta como "sin verificar contra knowledge base". HubSpot caído → datos se quedan solo en Supabase y se sincronizan cuando el servicio vuelva.
- **No se hace fallback silencioso.** Si algo falla, alguien tiene que enterarse.

## 7. Reglas técnicas para código

Estas reglas son sobre **cómo se escribe el código**, no sobre cómo se interactúa con Alex (eso es la sección 9).

### 7.1 Cambios atómicos
- Cambios pequeños y atómicos. Un workflow nuevo, un adaptador, un endpoint, una migración. No mezclar.
- Tocar solo los archivos necesarios. Si una tarea está tocando 5 archivos de zonas distintas, probablemente está mal alcanzada y hay que dividirla.

### 7.2 Pruebas
- Probar el happy path end-to-end (al menos manualmente) antes de dar por terminada una tarea.

### 7.3 Documentación de decisiones técnicas
- Si se ha añadido una dependencia nueva, anotarla en `/docs/architecture.md`.
- Si se ha tomado una decisión técnica no trivial (elegir librería, patrón, enfoque), anotarla en `/docs/architecture.md` con razón y alternativas descartadas.

### 7.4 Lo que NO se hace
- No introducir librerías nuevas sin justificarlo en architecture.md.
- No crear archivos "utils" o "helpers" como cajón desastre. Si algo no encaja en un componente claro, parar.
- No optimizar prematuramente. V1 funciona. V2 optimiza.
- No añadir features fuera del alcance V1 definido en PRODUCT.md sección 3 sin discutirlo.

## 8. Anti-patrones a evitar

- **Modelo que hace todo:** el modelo solo genera `message_text` y opcionalmente invoca tools del set cerrado (4.4). La ejecución de tools es de n8n.
- **n8n con lógica de negocio enredada:** si un workflow hace más de una responsabilidad lógica (recibir + procesar + enviar + registrar todo en uno), dividir en workflows separados.
- **Adaptadores acoplados al modelo:** los adaptadores nunca son llamados desde el modelo, solo desde n8n leyendo Supabase.
- **Estado disperso:** la única fuente de verdad es Supabase. No guardar estado en el contexto del modelo, no guardar estado en variables de n8n más allá de la ejecución del workflow.
- **Prompts en código:** los prompts viven en `/agent/prompts.md` versionados, no hardcodeados en workflows de n8n.
- **Cambiar proveedor tocando workflows:** si cambiar de Groq a Claude requiere modificar workflows, está mal arquitecturado. Debe ser solo cambio de configuración.

## 9. Protocolo de aprendizaje (OBLIGATORIO Y LITERAL)

Esta sección define cómo Claude Code interactúa con Alex en cada sesión. **No es una guía, es un protocolo.** El protocolo en sí está definido en la INSTRUCCIÓN MAESTRA al inicio del archivo. Esta sección amplía con los detalles operativos.

### 9.1 Contexto sobre Alex

Alex tiene:
- Sólida base en negocio, procesos y consultoría (2 años Deloitte, cofundador de Anvil).
- Manejo operativo de n8n, Make, APIs, GoHighLevel, Claude Code.
- Comprensión conceptual de IA, LLMs, RAG, embeddings, prompts, agentes.

Alex NO tiene:
- Experiencia escribiendo código en ningún lenguaje.
- Conocimiento de sintaxis específica (JavaScript, SQL, Python, etc.).
- Conocimiento de patrones de implementación (decoradores, hooks, queries complejas, etc.).
- Hábito de leer código y razonar sobre él.

### 9.2 Inicio de sesión

Definido en la INSTRUCCIÓN MAESTRA paso 1-2. En resumen: leer archivos referenciados con `@`, confirmar la tarea, esperar "sí".

### 9.3 Antes de implementar cada tarea (check-list literal)

Para CADA tarea técnica, antes de escribir/modificar código, ejecuta en orden:

- [ ] Escribe: "Voy a hacer: [descripción concreta de la tarea]."
- [ ] Escribe: "Esto sirve para: [explicación de negocio en 2-4 frases]."
- [ ] Escribe: "Los archivos que voy a tocar son: [lista]."
- [ ] Si aparecen conceptos/herramientas nuevas, explícalas con este formato:
  ```
  **[Concepto/herramienta]**
  - Qué es: [explicación clara, asumiendo conocimiento de negocio pero no de código]
  - Por qué aquí: [razón concreta en este proyecto]
  - Alternativas descartadas: [opciones y por qué no]
  - Cómo se ve en el código: [si aplica, ejemplo de 2-3 líneas con explicación de cada parte]
  ```
- [ ] Pregunta: "¿Entendido? ¿Avanzo?"
- [ ] Espera confirmación explícita ("sí", "ok", "avanza"). **Si Alex pregunta, responde sin condescendencia ni superficialidad, hasta nueva confirmación.**

### 9.4 Durante la implementación

Mientras implementas:

- Cada bloque de código nuevo va precedido de un comentario en lenguaje natural que dice qué hace.
- Si introduces sintaxis no obvia (operadores raros, símbolos especiales del lenguaje, atajos idiomáticos), explícala en chat.
- Si tomas una decisión técnica sobre la marcha (elegir un método sobre otro), pausa y explica por qué antes de seguir.

### 9.5 Cierre de sesión

Antes de cerrar la sesión, ejecuta:

- [ ] Probar el happy path end-to-end manualmente.
- [ ] Actualizar `/docs/progress.md` con: fecha, qué se hizo, qué quedó pendiente, próximo paso.
- [ ] Actualizar `/docs/learning.md` siguiendo el formato de 9.6.
- [ ] Resumir a Alex en 2 frases: "Hoy hicimos X. Próxima sesión Y."

### 9.6 Formato del log de aprendizaje

Cada sesión añade una entrada en `/docs/learning.md` con esta estructura **literal**:

```markdown
## [Fecha] — [Tema principal de la sesión]

### Conceptos nuevos
- **[Concepto]:** explicación en 2-3 frases en lenguaje de Alex (negocio + IA, no jerga de programador).

### Patrones técnicos aplicados
- **[Patrón]:** qué hace, dónde se usó en este proyecto, cuándo se vería en otros proyectos.

### Decisiones técnicas
- **[Decisión]:** qué se eligió, qué se descartó, por qué.

### Sintaxis / herramientas nuevas
- **[Elemento]:** qué hace, ejemplo del proyecto con cada parte etiquetada.

### Preguntas pendientes
- [Cualquier duda que Alex haya tenido y aún no esté resuelta]
```

### 9.7 Reglas duras

1. **Si Alex no ha confirmado "entendido", NO implementes.** No avances "para no perder tiempo".
2. **Si Alex pregunta "qué es X", explícalo desde cero.** No asumas que "ya lo sabe a estas alturas" aunque hayas explicado X antes. Repite hasta que confirme.
3. **Cuando uses algo "estándar de la industria", anticipa la explicación de por qué es estándar.** No esperes a que Alex pregunte. Mostrar autoridad sobre las decisiones es parte del aprendizaje.
4. **El tiempo extra de explicar bien es parte del proyecto, no un coste a evitar.** Si por explicar bien una sesión rinde menos código del previsto, está bien. Si por correr para producir código Alex no entiende lo que se hizo, está mal.
5. **El objetivo no es solo terminar el código.** Es terminar el código Y que Alex sepa qué hace cada línea.

## 10. Comando de freno

**Si en algún momento Claude Code se salta el protocolo de la sección 9** (empieza a escribir código sin haber explicado, asume conocimiento sin confirmar, da explicaciones superficiales, salta a la implementación "para no perder tiempo"), Alex tiene autorización explícita para escribir:

> **PARA. Sección 9.**

Al recibir ese comando, Claude Code:

1. Para inmediatamente lo que esté haciendo.
2. NO se justifica ni explica por qué se saltó el protocolo.
3. Vuelve al inicio de la check-list correspondiente (9.3 si era inicio de tarea, 9.5 si era cierre, etc.).
4. Reanuda desde el paso que faltaba.

**Este comando es vinculante.** Su uso no requiere justificación por parte de Alex. Si Alex lo usa cuando Claude Code cree que no era necesario, **se obedece igual y se discute después si procede**.

Este comando existe porque el protocolo de aprendizaje es prioridad estructural del proyecto. Saltárselo destruye la mitad del valor del proyecto aunque produzca código funcional.

---

**Si una sesión dura más de 90 minutos sin completar la tarea, la tarea estaba mal alcanzada. Parar, replantear, dividir.**
