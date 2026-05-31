# PLAN.md — Plan de construcción del proyecto

> Este documento vive en `/docs/plan.md`. Define el plan de construcción por semanas e hitos concretos. Es **una guía**, no un contrato: las semanas pueden estirarse o comprimirse según vaya saliendo. Lo que no cambia es el orden y las dependencias entre tareas.

---

## Cómo se usa

Cada semana tiene:
- **Objetivo de la semana** (qué tiene que estar funcionando al final).
- **Tareas en orden** (cada tarea = una sesión con Claude Code, salvo que se especifique lo contrario).
- **Criterio de cierre** (cómo sabes que la semana está terminada).
- **Riesgos** (qué puede salir mal y cómo mitigarlo).

Al inicio de cada semana, repasas la sección correspondiente. Al inicio de cada sesión, eliges la siguiente tarea pendiente de la semana actual.

**Si una sesión se complica y se desvía**, no pasa nada. Actualizas `/docs/progress.md` con lo que sí se hizo y la siguiente sesión retoma desde ahí. El plan se ajusta a la realidad, no al revés.

---

## Visión global

| Semana | Foco | Resultado al cierre |
|---|---|---|
| **0** | Setup y validación del protocolo | Repo montado, sesión 1 de validación hecha, cuentas creadas |
| **1** | Capa intermedia y orquestación básica | Supabase con schema + n8n recibiendo webhooks + Twilio sandbox conectado |
| **2** | Modelo LLM con function calling | Agente que conversa y decide tools (sin ejecutarlas todavía) |
| **3** | Tools y conexión con Cal.com | Agente que agenda citas reales en Cal.com |
| **4** | RAG con Pinecone | Agente que responde con info del catálogo de la clínica |
| **5** | Transición a producción | Stack de pago + número Twilio real + recordatorios funcionando |
| **6** | Pulido y portfolio | Demo grabada, README público, ficha de caso, V1 cerrada |

**Total estimado: 7 semanas (semana 0 de setup + 6 semanas de construcción).** Si dedicas 10-15h/semana, encaja. Si dedicas 5h/semana, se va a 12-14 semanas. Si tienes Tradegate, entrevistas u otros frentes en paralelo, ajusta.

---

## Semana 0 — Setup y validación

**Objetivo:** dejar todo preparado para empezar a construir en la semana 1 sin fricción de setup.

### Tareas

**Tarea 0.1 — Crear repo en GitHub y conectar con VS Code local.**
Ya tienes la carpeta local con los 5 archivos (CLAUDE.md, PRODUCT.md y los 3 dentro de `/docs/`). Toca crear el repo público en GitHub, hacer `git init`, primer commit, y push.
Sesión: tú solo (sin Claude Code).
Tiempo estimado: 20-30 min.

**Tarea 0.2 — Crear cuentas en los servicios free tier.**
Supabase, Pinecone, Railway, Cal.com, HubSpot Free, Groq u OpenRouter, HuggingFace. (n8n no necesita cuenta porque va self-hosted en Railway, ya decidido en CLAUDE.md sección 4.5).
Cada cuenta: email + contraseña. Anotar credenciales y API keys en gestor de contraseñas (no en el repo).
Sesión: tú solo.
Tiempo estimado: 60-90 min.

**Tarea 0.3 — Configurar `.gitignore` y verificar que no hay nada sensible en repo.**
Crear `.gitignore` que excluya `.env`, `node_modules`, archivos temporales. Es copiar un template estándar (GitHub te lo ofrece al crear repo, o usar `gitignore.io`).
Sesión: tú solo, sin Claude Code. 15-30 min.

**Tarea 0.4 — Sesión 1 con Claude Code: VALIDACIÓN DEL PROTOCOLO.**
Usar la plantilla literal de la INSTRUCCIÓN MAESTRA de CLAUDE.md. No construir nada, solo validar que el protocolo de aprendizaje funciona.
Sesión: 1 sesión de 30-45 min.

### Criterio de cierre Semana 0

- [ ] Repo público en GitHub con los 5 archivos visibles.
- [ ] Cuentas creadas en los 8 servicios free tier (anotadas en gestor de contraseñas).
- [ ] `.gitignore` configurado y verificado.
- [ ] Sesión 1 de validación ejecutada correctamente: Claude Code ha seguido la check-list, te ha explicado conceptos antes de implementar, has confirmado "entendido", y NO ha implementado nada porque era simulación.

### Riesgos Semana 0

- **Claude Code no respeta el protocolo en la sesión 1.** Si pasa, usar "PARA. Sección 9." y repetir la sesión 1 hasta que funcione. No avanzar a semana 1 hasta que el protocolo esté validado.
- **Una cuenta de servicio requiere verificación y se atasca.** Especialmente HuggingFace y Pinecone a veces piden datos extra. Si una cuenta tarda, sigues con las demás y vuelves a ella.

---

## Semana 1 — Capa intermedia y orquestación básica

**Objetivo:** que cuando entre un mensaje de WhatsApp al sandbox de Twilio, llegue a n8n, n8n registre algo en Supabase y devuelva un mensaje de prueba al usuario.

Esto es el **happy path mínimo**: WhatsApp → n8n → Supabase → respuesta. Sin modelo LLM todavía. Sin RAG. Sin Cal.com.

### Tareas

**Tarea 1.1 — Diseñar y crear el schema inicial de Supabase.**
Tablas: `leads`, `conversations`, `messages`, `events`. Sin `appointments` ni `reminders` todavía (esos van en semana 3).
Conceptos clave: claves primarias y foráneas (Bloque 2 de LEARNING.md), tipos de datos, UUIDs.
Sesión: 1 sesión con Claude Code, 60-90 min.

**Tarea 1.2 — Levantar n8n en Railway.**
Self-hosted gratis con template oficial de Railway. Configurar variables de entorno.
Conceptos clave: deployment, variables de entorno (Bloques 3 y 7).
Sesión: 1 sesión de 45-60 min. Puede ser tú solo si Railway es intuitivo, o con Claude Code.

**Tarea 1.3 — Conectar n8n con Supabase.**
Configurar credentials de Supabase en n8n. Crear un workflow simple que escriba una fila en `leads` cuando se dispara manualmente.
Conceptos clave: credentials en n8n (Bloque 4).
Sesión: 1 sesión con Claude Code, 60-90 min.

**Tarea 1.4 — Configurar Twilio sandbox y conectar webhook con n8n.**
Activar sandbox de Twilio, escanear QR para activar tu WhatsApp personal como tester, configurar webhook apuntando a n8n.
Conceptos clave: webhooks, HTTPS (Bloque 3), Twilio sandbox.
Sesión: 1 sesión de 60-90 min.

**Tarea 1.5 — Workflow happy path mínimo.**
Cuando llega mensaje WhatsApp → n8n recibe webhook → registra lead en Supabase → registra mensaje en `messages` → responde con texto fijo "Recibido, te contactaremos pronto" → registra evento.
Conceptos clave: triggers, expresiones de n8n, manejo de errores.
Sesión: 1-2 sesiones, 90-120 min en total.

### Criterio de cierre Semana 1

- [ ] Schema de Supabase creado con las 4 tablas, relaciones funcionando.
- [ ] n8n corriendo en Railway con URL pública accesible.
- [ ] Mandas mensaje WhatsApp al sandbox → ves la fila aparecer en Supabase en < 5 segundos.
- [ ] Recibes en WhatsApp la respuesta fija "Recibido, te contactaremos pronto".
- [ ] La tabla `events` registra cada paso (lead creado, mensaje recibido, mensaje enviado).

### Riesgos Semana 1

- **Twilio sandbox da problemas con números españoles (+34).** A veces requiere desactivar/reactivar. Si pasa, usar número personal como tester.
- **n8n en Railway free tier se duerme.** Si pasa más de X tiempo sin tráfico, Railway hibernate el contenedor. Solución: cron de pings cada 5 min para mantenerlo despierto.
- **Webhook de Twilio no llega a n8n.** Normalmente es la URL: confundir test URL con production URL (anti-patrón mencionado en LEARNING.md Bloque 4).
- **RLS de Supabase bloquea las inserciones.** Desactivar RLS en las tablas de V1 (no hay multi-clínica todavía).

---

## Semana 2 — Modelo LLM con function calling

**Objetivo:** que el agente conteste con un modelo de verdad (Groq u OpenRouter free) y devuelva el JSON estructurado con `message_text` y `tools` definido en CLAUDE.md 4.4. Las tools todavía no se ejecutan, solo se registran en `events`.

### Tareas

**Tarea 2.1 — Escribir system prompt inicial del agente.**
Definir rol, tono, qué hace, qué tools tiene disponibles, formato de output JSON. Vive en `/agent/prompts.md`.
Conceptos clave: system prompt vs user prompt, prompt engineering (Bloque 5).
Sesión: 1 sesión de 90 min. Esta es importante, dedicarle tiempo.

**Tarea 2.2 — Documentar las tools del agente en `/agent/tools.md`.**
Para cada una de las 6 tools (qualify, check_availability, book_appointment, reschedule_appointment, handoff_to_human, end_conversation): qué hace, params, validación, tipo (con/sin retorno).
Conceptos clave: function calling (Bloque 5).
Sesión: 1 sesión de 60 min.

**Tarea 2.3 — Workflow de llamada al modelo.**
n8n llama a Groq/OpenRouter pasándole system prompt + historial de conversación desde Supabase + último mensaje del lead. Recibe respuesta. Parsea JSON. Si es válido, ejecuta `message_text` (manda WhatsApp) y registra `tools` en `events`. Si JSON inválido, fallback handoff humano.
Conceptos clave: contexto y memoria de conversación, validación JSON, function calling.
Sesión: 2 sesiones, 90-120 min cada una.

**Tarea 2.4 — Pruebas conversacionales.**
Mantener 5-10 conversaciones de prueba con el agente: pregunta por servicios, pide cita, hace preguntas raras. Documentar conversaciones en `/tests/conversations/`. Iterar system prompt según veas problemas.
Conceptos clave: temperature, hallucinations.
Sesión: 1-2 sesiones de iteración, 60-90 min.

### Criterio de cierre Semana 2

- [ ] System prompt + tools documentados.
- [ ] Mandas mensaje WhatsApp → el agente responde con texto generado por modelo (no fijo).
- [ ] El JSON del modelo se parsea correctamente, `message_text` se envía y `tools` se registran en `events`.
- [ ] Tienes 5-10 conversaciones de prueba grabadas mostrando el comportamiento.
- [ ] Si el modelo devuelve JSON malformado, hay fallback que no rompe el sistema.

### Riesgos Semana 2

- **Modelos free de Groq/OpenRouter responden raro o en inglés.** Iterar system prompt. Si tras varios intentos sigue mal, considerar cambiar de modelo (Llama → Mistral o viceversa). Si ningún free funciona bien, plantear cambiar a Claude antes de tiempo (sí, costaría algunos euros antes de semana 5).
- **El modelo no respeta el formato JSON.** Reforzar en system prompt con ejemplos few-shot. Si sigue fallando, usar el parámetro de structured output de la API si está disponible.
- **Conversación crece y supera context window.** Implementar truncado: pasar últimos N mensajes + resumen del resto.

---

## Semana 3 — Tools y conexión con Cal.com

**Objetivo:** que el agente agende citas reales en Cal.com cuando el lead las pide. Implementar el ciclo de tools con retorno (modelo → tool → resultado → modelo).

### Tareas

**Tarea 3.1 — Configurar Cal.com.**
Crear evento "Cita de prueba" con duración 30 min, disponibilidad de prueba (lunes-viernes, 10-18h). Generar API key.
Sesión: tú solo, 30-45 min.

**Tarea 3.2 — Implementar tool `check_availability`.**
n8n hace llamada a Cal.com API consultando huecos disponibles. Devuelve resultado al modelo en una segunda llamada. Modelo genera siguiente turno con los huecos.
Conceptos clave: tools con retorno, bucle anti-loop (Bloque 5 de LEARNING.md), pagination si aplica.
Sesión: 2 sesiones, 90 min cada una.

**Tarea 3.3 — Implementar tool `book_appointment`.**
Crear cita en Cal.com con datos del lead. Registrar en tabla `appointments` de Supabase (crearla si no existe). Devolver confirmación al modelo.
Conceptos clave: integraciones API, persistencia.
Sesión: 1 sesión de 90 min.

**Tarea 3.4 — Implementar tools "sin retorno": `qualify`, `handoff_to_human`, `end_conversation`.**
Estas no requieren segunda llamada al modelo. Se ejecutan y se registran en Supabase. `handoff_to_human` además dispara notificación a email/Slack.
Sesión: 1 sesión de 60 min.

**Tarea 3.5 — Implementar tool `reschedule_appointment`.**
Cancelar cita existente en Cal.com + crear nueva. Actualizar Supabase.
Sesión: 1 sesión de 60-90 min.

**Tarea 3.6 — Pruebas end-to-end con agendado real.**
5-10 conversaciones donde el lead agenda cita, la cita aparece en Cal.com, el lead recibe confirmación.
Sesión: 1-2 sesiones de iteración.

### Criterio de cierre Semana 3

- [ ] Lead pide cita → agente consulta Cal.com → propone huecos → lead confirma → cita creada en Cal.com → confirmación enviada al lead.
- [ ] Las 6 tools están implementadas y testeadas.
- [ ] El bucle anti-loop funciona (máximo 3 ciclos consecutivos sin lead).
- [ ] `handoff_to_human` dispara notificación a tu email.

### Riesgos Semana 3

- **Cal.com API tiene formato distinto al esperado.** Leer docs antes de implementar. Hacer prueba manual con curl/Postman antes de meterlo en n8n.
- **Modelo no usa las tools cuando debería.** Iterar system prompt: ejemplos few-shot mostrando cuándo invocar `check_availability` vs cuándo `respond`.
- **Modelo invoca tools con params incorrectos.** Validación estricta en n8n: si params no cumplen el schema definido en tools.md, devolver al modelo un mensaje de error como contexto para que reintente.

---

## Semana 4 — RAG con Pinecone

**Objetivo:** el agente responde preguntas sobre la clínica usando información real (precios, servicios, horarios, ubicación) recuperada de Pinecone, no inventada.

### Tareas

**Tarea 4.1 — Preparar base de conocimiento de la clínica.**
Documento markdown en `/agent/knowledge-base/clinica.md` con: servicios, precios, profesionales, horarios, ubicación, FAQs.
Para V1, usar una clínica ficticia plausible (no Anvil, no un cliente real). Anotar como "clínica de demo".
Sesión: tú solo, 30-45 min.

**Tarea 4.2 — Configurar Pinecone.**
Crear índice con dimensiones correctas según embeddings de HuggingFace que vayas a usar. Configurar namespace = "clinica-demo".
Conceptos clave: vector database, namespaces, dimensiones (Bloque 6).
Sesión: 1 sesión, 60 min.

**Tarea 4.3 — Implementar pipeline de indexación.**
Workflow de n8n que: lee `clinica.md` → chunkea por sección → llama a HuggingFace API para generar embeddings → guarda vectores con metadata en Pinecone.
Conceptos clave: chunking, embeddings, indexación.
Sesión: 1-2 sesiones, 90-120 min total.

**Tarea 4.4 — Integrar RAG en el flujo del agente.**
Antes de cada llamada al modelo, n8n consulta Pinecone con el mensaje del lead → recupera top 3-5 chunks similares → inyecta en el prompt como contexto adicional.
Conceptos clave: RAG, top_k, similitud semántica.
Sesión: 1 sesión de 90-120 min.

**Tarea 4.5 — Pruebas conversacionales con RAG activo.**
5-10 conversaciones probando preguntas específicas sobre la clínica. Verificar que las respuestas usan info real del knowledge base, no inventan.
Sesión: 1-2 sesiones de iteración.

### Criterio de cierre Semana 4

- [ ] Knowledge base de clínica de demo creado.
- [ ] Pinecone indexado con embeddings del catálogo.
- [ ] Lead pregunta "¿cuánto cuesta la limpieza?" → agente responde con precio correcto del knowledge base.
- [ ] Lead pregunta algo que NO está en el knowledge base → agente reconoce que no sabe y deriva a humano (no inventa).

### Riesgos Semana 4

- **Embeddings de HuggingFace devuelven dimensiones inesperadas.** Verificar dimensiones del modelo antes de crear índice Pinecone.
- **Chunks demasiado grandes o pequeños degradan resultados.** Iterar estrategia de chunking. Empezar por chunks de párrafo o sección, no de tamaño fijo.
- **Modelo sigue alucinando aunque tenga el contexto correcto.** Reforzar en system prompt: "si la información que necesitas no está en el contexto proporcionado, responde que necesitas confirmar con un humano y dispara `handoff_to_human`".
- **top_k muy bajo no encuentra info relevante.** Empezar con top_k=5 e ir ajustando.

---

## Semana 5 — Transición a producción

**Objetivo:** sistema funcionando con stack de pago (Claude API + OpenAI embeddings + número Twilio real) + recordatorios automáticos implementados.

### Tareas

**Tarea 5.1 — DÍA 1: solicitar número Twilio real en cuenta Anvil verificada.**
Esto se hace el lunes de la semana 5 sin falta, porque tarda 2-5 días laborables.
Sesión: tú solo, 30 min.

**Tarea 5.2 — Crear cuentas Anthropic y OpenAI con credits.**
Mientras esperas Twilio, prepara las cuentas de pago. Anthropic API + OpenAI API. Cargar 10€ de crédito inicial en cada una como pre-carga (no es gasto, es saldo disponible). El gasto real esperado durante semanas 5-6 es ~10-15€ totales; el resto del saldo queda para clínicas reales en producción.
Sesión: tú solo, 30 min.

**Tarea 5.3 — Cambiar configuración del modelo: Groq → Claude.**
En n8n, cambiar endpoint y API key. Probar conversación de prueba.
Conceptos clave: variables de entorno en producción.
Sesión: 1 sesión, 45-60 min.

**Tarea 5.4 — Reindexar Pinecone con OpenAI embeddings.**
Crear nuevo índice en Pinecone con dimensiones correctas para OpenAI (1536). Reindexar todo el knowledge base. Apuntar el flujo del agente al nuevo índice.
Conceptos clave: reindexación, dimensiones incompatibles.
Sesión: 1 sesión, 60 min.

**Tarea 5.5 — Implementar recordatorios automáticos.**
Cuando se crea una cita, n8n programa dos workflows: uno para 24h antes, otro para 1h antes. Cada uno manda mensaje al lead. Si el lead responde "no puedo", reabrir conversación y reagendar.
Conceptos clave: scheduling persistente (no Wait en memoria), cron.
Sesión: 1-2 sesiones, 90-120 min total.

**Tarea 5.6 — Activar número Twilio real.**
Cuando llegue la activación de Twilio, configurar webhooks en Twilio Console → URL de n8n en Railway. Verificar entregabilidad con tu propio WhatsApp primero. Después con 2-3 amigos.
Conceptos clave: transición Twilio sandbox → real.
Sesión: 1 sesión, 60-90 min.

**Tarea 5.7 — Configurar alertas de gasto y errores.**
En Anthropic y OpenAI, configurar alerta de gasto diario (ej: 2€/día). En n8n, workflow que detecte fallos críticos y mande email.
Conceptos clave: alertas, monitoring.
Sesión: 1 sesión, 45-60 min.

### Criterio de cierre Semana 5

- [ ] Número Twilio real activo y mandando mensajes desde el dominio Anvil.
- [ ] Modelo en producción = Claude Sonnet. Calidad de respuestas notablemente mejor que con Groq.
- [ ] Pinecone reindexado con OpenAI embeddings.
- [ ] Cita agendada → recordatorios disparan a 24h y 1h antes correctamente (probar con cita de prueba).
- [ ] Alertas configuradas y probadas (forzar un error y verificar que llega notificación).
- [ ] Coste acumulado durante construcción: < 20€.

### Riesgos Semana 5

- **Activación de Twilio tarda más de 5 días.** Si pasa una semana sin activación, contactar soporte Twilio. Para no bloquear V1, grabar demo final con sandbox y reemplazar después.
- **Calidad de Claude muy distinta a Groq, prompts mal afinados.** Iterar. Lo bueno: con Claude, los prompts suelen requerir MENOS detalle, no más.
- **Reindexación de embeddings se queda colgada.** Reindexar en lotes pequeños, no todo de golpe.
- **Recordatorios no disparan a la hora exacta.** Verificar zona horaria de Supabase y n8n. Coordinar con la zona horaria de la clínica (Europe/Madrid).

---

## Semana 6 — Pulido y portfolio

**Objetivo:** todo lo que necesitas para que este caso sea defendible en LinkedIn, GitHub y entrevistas.

### Tareas

**Tarea 6.1 — Probar V1 end-to-end 5-10 veces.**
Hacer 5-10 conversaciones completas: lead pregunta → cualifica → agenda → recibe recordatorios → cita real en Cal.com → datos en Supabase y HubSpot.
Documentar conversaciones en `/tests/conversations/`. Cualquier bug que aparezca, arreglar.
Sesión: 2-3 sesiones de testing intensivo.

**Tarea 6.2 — Sacar métricas iniciales.**
Consultar Supabase para sacar las métricas definidas en PRODUCT.md sección 5: tiempo de primera respuesta, % cualificación, % agendamiento, etc.
Exportar a Sheets para tener gráficas presentables.
Sesión: 1 sesión, 60 min.

**Tarea 6.3 — Grabar demo en Loom.**
Vídeo de 2-3 min: contexto del problema (clínica que necesita captación 24/7), demo en vivo de una conversación end-to-end, mostrar datos en Supabase, mostrar cita en Cal.com, cerrar con métricas.
Sesión: 1-2 sesiones (probablemente harán falta varios takes).

**Tarea 6.4 — Escribir README público del repo.**
Estructura: problema, solución, arquitectura, stack, instrucciones de despliegue mínimas, video demo embedded, métricas.
Sin presumir, sin minimizar.
Sesión: 1-2 sesiones, 90 min.

**Tarea 6.5 — Crear ficha de caso para LinkedIn y/o web personal.**
Formato definido en las instrucciones del proyecto: problema, qué construí, cómo lo abordé (decisión técnica), resultado, stack. Sin adjetivos vacíos.
Sesión: 1 sesión, 60 min.

**Tarea 6.6 — Preparar defensa en entrevista.**
Lista de 10 preguntas típicas + respuestas preparadas (sin sonar a guion). Especial atención a: "¿cómo se relaciona esto con Anvil?", "¿por qué este stack?", "¿qué descartaste?", "¿qué harías diferente con más tiempo?".
Sesión: 1 sesión, 60-90 min, con ayuda de Claude para simular entrevista.

### Criterio de cierre Semana 6 (= V1 cerrada)

- [ ] 5-10 conversaciones end-to-end documentadas funcionando.
- [ ] Métricas extraídas y presentables.
- [ ] Video demo de 2-3 min público en Loom/YouTube no listado.
- [ ] README del repo publicado en GitHub.
- [ ] Ficha de caso lista para publicar en LinkedIn.
- [ ] Respuestas preparadas para preguntas de entrevista.
- [ ] **Caso de portfolio cerrado.**

### Riesgos Semana 6

- **Aparece un bug grande durante testing intensivo.** Decidir: ¿se arregla y se retrasa V1, o se documenta como limitación conocida y se publica V1? Depende del impacto. Bug que rompe el happy path → arreglar. Bug que solo aparece en edge cases raros → documentar y publicar.
- **Demo sale mal en grabación.** Normal. 3-5 takes. Si tras 5 sigue mal, replantear el guion del demo.
- **README sale demasiado largo.** Recortar hasta < 1.000 palabras o el reclutador no lo lee.

---

## Después de V1

Cuando V1 esté cerrada:

- **Empezar a aplicar a trabajos** usando el caso como base del portfolio. Esto es prioridad.
- **Conseguir 1-2 clínicas piloto** usando el sistema. Pueden ser de Anvil o nuevas. Recoger métricas reales (primera clínica pagando = caso de portfolio se multiplica por 3 de valor).
- **NO empezar V2** hasta tener al menos 1 clínica real con 30 días de uso. Sin datos reales, V2 es teoría.
- **Empezar proyecto 2 o 3 del portfolio.** El plan global del portfolio tiene 3 proyectos. V1 del proyecto 1 = uno de los tres listos. Quedan 2.

---

## Regla maestra del plan

**Si una tarea se atasca más de 2 sesiones (~3h totales), parar y replantear.** Probablemente la tarea está mal alcanzada o falta entender algo. En vez de seguir martilleando:

1. Actualiza `/docs/progress.md` con qué se ha intentado.
2. Saca el problema concreto a la conversación con Claude (no Claude Code): "estoy atascado en X, esto es lo que he intentado, dime si replanteo o sigo".
3. Vuelve a Claude Code con el problema más concreto y/o subdividido.

**No avances a la siguiente semana sin cumplir el criterio de cierre de la actual.** Las semanas dependen unas de otras. Saltarse algo lo paga la semana siguiente con intereses.
