# LEARNING.md — Mapa de aprendizaje del proyecto

> Este documento vive en `/docs/learning.md`. Es el mapa de conceptos técnicos que vas a tocar en este proyecto, ordenados por cuándo aparecerán.
>
> **Aviso de honestidad:** este mapa es más completo que un curriculum genérico de programación porque está pensado para ESTE proyecto concreto. Pero **no es exhaustivo al 100%**. Es matemáticamente imposible que lo sea. Para cubrir los imprevistos, cada bloque tiene una sección **"🚨 Errores típicos y red flags"** con los problemas más frecuentes que aparecen en ese tipo de tarea. Y si aún así surge algo no anticipado, usas el comando "PARA. Sección 9." y Claude Code te lo explica en el momento.

---

## Cómo se usa

**Parte A: Curriculum del proyecto.** Bloques organizados por semana/componente. Lo lees al principio para tener mapa mental.

**Parte B: Sesiones.** Vacía. Se llena con cada sesión en formato definido en `CLAUDE.md` sección 9.6.

Antes de cada sesión, repasas el bloque que toca esa semana. Al final de cada sesión, Claude Code añade entrada a la Parte B.

## Marcadores de estado

- 🔴 No tocado
- 🟡 Visto, no dominado
- 🟢 Dominado: lo entiendes, lo sabrías explicar, lo defiendes en entrevista

⭐ = crítico para V1. ⭐⭐ = crítico Y será preguntado en entrevistas.

---

# Parte A: Curriculum

## Bloque 1 — Fundamentos de repositorio y formatos (semana 1)

🔴 **Git y repositorio**
Qué es: control de versiones, historial de cambios, posibilidad de volver atrás.
Por qué aquí: cada cambio se commitea con mensaje claro. Es lo que ven reclutadores en tu GitHub.
Qué saber al final: hacer commits con mensajes claros, entender qué es una rama básica, saber que existe push/pull.

🔴 **`.gitignore`**
Qué es: archivo que dice a Git qué NO subir al repositorio (archivos `.env`, credenciales, archivos temporales).
Por qué aquí: tus API keys NUNCA pueden acabar en GitHub. El `.gitignore` es la primera barrera.
Qué saber al final: configurar `.gitignore` para que no suba `.env`, `node_modules/`, archivos de Claude Code que no deban publicarse.

🔴 **JSON** ⭐
Qué es: formato de texto para estructurar datos. Es lo que las APIs hablan entre sí.
Por qué aquí: el modelo LLM devuelve JSON. Twilio, Cal.com, HubSpot reciben y devuelven JSON. Los webhooks transportan JSON.
Qué saber al final: leer un JSON, distinguir objetos `{}` y arrays `[]`, identificar claves y valores.

🔴 **Markdown**
Qué es: formato de texto plano con marcas mínimas (títulos, listas, código).
Por qué aquí: toda la documentación del proyecto y tu README de GitHub están en markdown.
Qué saber al final: lo dominas intuitivamente, en una sesión te lo formalizamos.

🔴 **HTTP status codes**
Qué es: códigos de 3 dígitos que devuelve un servidor. 200 = OK, 400 = error del cliente, 401 = no autorizado, 404 = no encontrado, 429 = rate limited, 500 = error del servidor.
Por qué aquí: vas a ver muchos en logs y debugs cuando algo falla. Saber qué significan cada uno te ahorra horas de debug.
Qué saber al final: distinguir errores tuyos (4xx) de errores del servicio externo (5xx).

🔴 **Terminal / línea de comandos**
Qué es: forma de interactuar con el ordenador escribiendo comandos en lugar de clicar.
Por qué aquí: para hacer commits de Git, para algunos comandos puntuales, para mirar logs.
Qué saber al final: navegar carpetas (`cd`), listar (`ls` o `dir`), ejecutar comandos básicos. No necesitas dominio, solo no asustarte cuando veas una terminal.

🔴 **Encoding (UTF-8) y caracteres especiales**
Qué es: forma en que el ordenador guarda letras. UTF-8 es el estándar y soporta acentos, eñes, emojis.
Por qué aquí: tus mensajes en español tienen acentos y eñes. WhatsApp tiene emojis. Si el encoding está mal, "España" aparece como "EspaÃ±a".
Qué saber al final: saber que UTF-8 es lo correcto, identificar cuándo hay problema de encoding mirando un texto raro.

### 🚨 Errores típicos del Bloque 1

- **Subir `.env` a GitHub por accidente.** Si pasa: rotar todas las API keys inmediatamente (porque están comprometidas), añadir al `.gitignore`, hacer commit que las elimine, considerar usar `git-filter-branch` o BFG si la exposición fue larga.
- **Crear archivo con extensión incorrecta** (ej: `CLAUDE.md.txt` en Windows). Verificar siempre que la extensión sea la que crees.
- **Commits gigantes que mezclan cosas distintas**. Un commit = un cambio lógico, no "cambios del día".

---

## Bloque 2 — Capa intermedia: bases de datos y Supabase (semana 1)

🔴 **Bases de datos relacionales** ⭐
Qué es: forma de guardar datos en tablas con filas y columnas con reglas estrictas. Mucho más rápida y robusta que una hoja de Excel.
Por qué aquí: Supabase es BD relacional. Es la única fuente de verdad del sistema.
Qué saber al final: entender tabla, fila, columna. Saber que las tablas se relacionan entre sí.

🔴 **Schema y migraciones** ⭐
Qué es: el schema es la estructura de la BD (tablas, columnas, tipos). Las migraciones son cambios versionados del schema.
Por qué aquí: en sesión 2-3 vas a crear el schema inicial con `leads`, `conversations`, `appointments`, `events`.
Qué saber al final: leer un schema y entender qué tablas hay y cómo se relacionan.

🔴 **Tipos de datos**
Qué es: cada columna tiene un tipo: texto (`TEXT`), número (`INTEGER`), fecha (`TIMESTAMP`), JSON (`JSONB`), UUID, booleano (`BOOLEAN`).
Por qué aquí: al diseñar el schema decides el tipo de cada columna. Mal elegido = problemas más adelante.
Qué saber al final: elegir el tipo correcto para cada columna sin pensarlo dos veces (teléfono → TEXT, no INTEGER; fecha → TIMESTAMP, no TEXT).

🔴 **Claves primarias (PK) y foráneas (FK)**
Qué es: PK identifica única cada fila. FK es referencia desde una tabla a la PK de otra.
Por qué aquí: relacionas un lead con sus conversaciones y citas.
Qué saber al final: identificar PK y FK en un schema, entender por qué no se usa el teléfono como ID.

🔴 **UUID**
Qué es: identificador único universal tipo `f47ac10b-58cc-4372-a567-0e02b2c3d479`.
Por qué aquí: cada lead, conversación y cita tiene UUID. Más robusto que un número incremental.
Qué saber al final: entender por qué UUID y no `1, 2, 3...` (no se adivina, no se duplica entre sistemas).

🔴 **NULL vs vacío vs default**
Qué es: NULL = "no hay valor", string vacío `""` = "hay valor y es vacío", default = "si no se especifica, usa este".
Por qué aquí: confundir los tres es fuente clásica de bugs (ej: query `WHERE field = ''` no encuentra filas con NULL).
Qué saber al final: distinguir los tres, decidir cuándo usar cada uno al diseñar columnas.

🔴 **Índices** (mención, no profundización)
Qué es: estructura que acelera búsquedas en columnas concretas. Si buscas mucho por `phone_number`, pones índice ahí.
Por qué aquí: en V1 probablemente no toques índices, pero hay que saber que existen. Supabase los crea automáticamente para PK y FK.
Qué saber al final: saber que existen, entender que aceleran búsquedas, no necesitas crearlos manualmente en V1.

🔴 **SQL básico** ⭐
Qué es: lenguaje para consultar BD. `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `WHERE`, `JOIN`.
Por qué aquí: vas a leer queries para sacar métricas. No vas a escribirlas desde cero, pero sí leerlas.
Qué saber al final: leer un `SELECT ... FROM ... WHERE ...` y entender qué hace. Reconocer JOIN.

🔴 **Row Level Security (RLS) en Supabase**
Qué es: política de seguridad por fila. Permite decir "este usuario solo ve sus propias filas".
Por qué aquí: en V1 con una clínica probablemente RLS no es crítico, pero Supabase lo activa por defecto y puede bloquearte las queries si no lo configuras.
Qué saber al final: saber que existe, saber desactivarlo en tablas internas de V1, saber que en V2 multi-clínica será obligatorio.

🔴 **Supabase como producto** ⭐
Qué es: PostgreSQL + auth + API REST automática + dashboard.
Por qué aquí: free tier generoso, dashboard cómodo, API REST plug-and-play con n8n.
Qué saber al final: navegar dashboard, ver tablas, ejecutar queries, leer logs.

### 🚨 Errores típicos del Bloque 2

- **Diseñar schema sin pensar y arrepentirse 2 semanas después.** Pasar 30 minutos pensando el schema inicial ahorra horas de migraciones complejas.
- **Activar RLS y luego no entender por qué las queries devuelven 0 filas.** Si la query es correcta y devuelve vacío, sospecha de RLS primero.
- **Borrar fila con FKs apuntando a ella y romper integridad.** O usar `ON DELETE CASCADE` cuando se diseña la FK, o borrar con cuidado.
- **Tratar NULL como `false` o como `""`.** No es lo mismo. `NULL == NULL` devuelve NULL, no `true`. Usar `IS NULL`.
- **Guardar fechas como TEXT.** Siempre TIMESTAMP. Filtrar por fechas guardadas como texto es un dolor.
- **Olvidar el namespace al usar Supabase.** Si el cliente tiene auth activado, las llamadas necesitan token, no solo URL.

---

## Bloque 3 — Comunicación entre sistemas: APIs y webhooks (semana 2)

🔴 **API REST** ⭐
Qué es: forma estándar de que dos sistemas se comuniquen. Uno pregunta, otro responde. URL + método (GET, POST...) + cuerpo JSON.
Por qué aquí: todo se comunica por APIs REST. n8n llama a Cal.com, al modelo, al CRM.
Qué saber al final: entender qué pasa cuando un sistema llama a otro. Distinguir GET (pedir) de POST (enviar). Leer un endpoint.

🔴 **HTTP methods (GET, POST, PUT, PATCH, DELETE)**
Qué es: GET = pedir info, POST = crear, PUT = reemplazar entero, PATCH = modificar parte, DELETE = borrar.
Por qué aquí: cada llamada a API usa uno. Usar el incorrecto = error 405 o resultado raro.
Qué saber al final: saber cuál usar para cada acción sin dudar.

🔴 **Webhooks** ⭐
Qué es: lo contrario a una API que tú llamas. Otro sistema te llama a ti cuando ocurre algo. Tú expones una URL.
Por qué aquí: Twilio dispara webhook a n8n cuando llega WhatsApp. Meta dispara webhook con leads. Cal.com puede disparar al confirmar cita.
Qué saber al final: entender la diferencia. Saber configurar webhook en Twilio y n8n.

🔴 **Headers HTTP**
Qué es: metadata que va con cada request. Los más comunes: `Authorization` (la API key), `Content-Type` (qué tipo de cuerpo va).
Por qué aquí: olvidar `Authorization` = 401. Olvidar `Content-Type: application/json` en POST con JSON = 400.
Qué saber al final: añadir headers correctos en cada llamada API.

🔴 **API keys y secretos** ⭐
Qué es: "contraseña" que identifica que eres tú. Cada servicio te da una.
Por qué aquí: vas a tener API keys de Twilio, Cal.com, modelo, OpenAI, HubSpot, Pinecone, Supabase.
Qué saber al final: NUNCA en código, SIEMPRE en variables de entorno. Si se filtra, rotar inmediatamente.

🔴 **Variables de entorno**
Qué es: variables que viven fuera del código (en `.env` o config del servidor) para guardar secretos.
Por qué aquí: todas las API keys del proyecto.
Qué saber al final: por qué existe la separación, cómo se configuran en n8n y Railway.

🔴 **Rate limiting**
Qué es: límite de llamadas por minuto/hora que un servicio te permite. Si te pasas, devuelven 429.
Por qué aquí: Twilio, OpenAI, Anthropic, Cal.com tienen rate limits. Un bug puede dispararlos.
Qué saber al final: identificar 429 en logs, saber que hay que esperar antes de reintentar (backoff exponencial).

🔴 **Pagination en responses**
Qué es: cuando una API devuelve muchos resultados, los parte en páginas. Devuelve "los primeros 100" + cursor para los siguientes.
Por qué aquí: si consultas "todas las citas del mes" en Cal.com, vienen paginadas. Hay que iterar.
Qué saber al final: reconocer una respuesta paginada, saber cómo pedir la siguiente página.

🔴 **HTTPS y URLs públicas**
Qué es: protocolo seguro. Los webhooks SIEMPRE requieren HTTPS (Twilio, Meta no aceptan HTTP).
Por qué aquí: el webhook de n8n en Railway tiene URL HTTPS automática. Para desarrollo local hay que usar ngrok o similar.
Qué saber al final: saber por qué HTTPS, qué hacer en desarrollo local.

🔴 **ngrok o túneles para testing local**
Qué es: herramienta que expone tu servidor local con URL pública HTTPS temporal.
Por qué aquí: para probar webhooks de Twilio mientras desarrollas en local sin desplegar a Railway.
Qué saber al final: levantar ngrok, configurar URL temporal en Twilio, entender que es temporal y que cambia cada vez.

### 🚨 Errores típicos del Bloque 3

- **Hardcodear API key en código.** Si haces commit, está expuesta para siempre en el historial de Git. Solución: rotar key inmediatamente.
- **Olvidar `Content-Type: application/json` en POSTs.** El servidor recibe el cuerpo pero no sabe parsearlo. Error 400.
- **Webhook que tarda > 10 segundos en responder.** Twilio reintenta automáticamente. Resultado: mismo mensaje procesado N veces.
- **Confundir test URL con production URL de Twilio.** Mandar mensaje real desde la URL test, o viceversa.
- **No manejar 429 rate limit.** El servicio te bloquea durante minutos/horas. Hay que esperar y reintentar.
- **Llamar a API en bucle por bug y comerse el rate limit o el coste.** Siempre poner alerta de gasto/llamadas en producción.
- **No firmar/validar webhooks de Twilio.** Cualquiera puede mandar fake requests a tu URL. Twilio firma sus webhooks con header, hay que validar.

---

## Bloque 4 — Orquestación con n8n (semana 2)

🔴 **n8n como producto** ⭐
Qué es: herramienta visual de automatización. Encadenas nodos en un workflow, cada uno hace una cosa.
Por qué aquí: stack declarado. Toda la orquestación vive en n8n.
Qué saber al final: navegar n8n, crear workflows, encadenar nodos, debuggear.

🔴 **Triggers** ⭐
Qué es: nodos especiales que inician un workflow. Webhook trigger, schedule trigger, manual trigger.
Por qué aquí: cada workflow empieza con un trigger.
Qué saber al final: distinguir tipos y saber cuál usar.

🔴 **Expresiones de n8n** ⭐
Qué es: forma de hacer referencias dinámicas entre nodos. Sintaxis `{{ $json.field }}` o `{{ $node["NombreNodo"].json.field }}`.
Por qué aquí: cada nodo recibe datos del anterior, hay que extraerlos con expresiones.
Qué saber al final: leer y escribir expresiones básicas sin pánico.

🔴 **Item vs binary data en n8n**
Qué es: n8n distingue items (datos JSON) de binarios (archivos, audio, imágenes). Se manejan distinto.
Por qué aquí: si llega audio por WhatsApp para transcripción, viene como binario.
Qué saber al final: reconocer cuándo trabajas con uno u otro.

🔴 **Sub-workflows y modularidad**
Qué es: dividir un workflow grande en workflows más pequeños que se llaman entre sí.
Por qué aquí: cuando un workflow crece demasiado (> 1 responsabilidad), dividir en sub-workflows. Definido en CLAUDE.md sección 8.
Qué saber al final: saber cuándo dividir, cómo conectar dos workflows.

🔴 **Credentials en n8n**
Qué es: forma segura de guardar API keys dentro de n8n para que los nodos las usen sin hardcodear.
Por qué aquí: cada integración (Twilio, Cal.com, OpenAI, Supabase, Pinecone) tiene sus credentials configuradas una vez en n8n.
Qué saber al final: configurar credentials desde la UI, asociarlas a un nodo.

🔴 **HTTP Request node**
Qué es: nodo genérico para llamar a cualquier API REST que n8n no tenga nativa.
Por qué aquí: APIs como Cal.com puede no tener nodo nativo, se usa HTTP Request.
Qué saber al final: configurar URL, método, headers, body de una llamada manual.

🔴 **Code node (JavaScript)**
Qué es: nodo donde escribes JavaScript para lógica custom que no se puede hacer con nodos existentes.
Por qué aquí: para parsear respuestas complejas del modelo, manipular datos, validaciones específicas.
Qué saber al final: leer un bloque de JS dentro de un Code node y entender qué hace. No necesitas escribirlo desde cero.

🔴 **Delays y scheduling** ⭐
Qué es: hacer que un workflow espere antes de seguir. Nodo Wait (minutos/horas/días).
Por qué aquí: recordatorios de cita disparan 24h y 1h antes.
Qué saber al final: entender que para esperas largas (días) no se usa Wait en memoria, sino marca en BD + cron.

🔴 **Manejo de errores y retries**
Qué es: cuando una llamada falla, reintentar con backoff exponencial.
Por qué aquí: política en CLAUDE.md 6.5.
Qué saber al final: configurar retries en nodos, identificar fallos críticos vs no críticos.

🔴 **Webhooks de n8n: test URL vs production URL**
Qué es: cada webhook trigger tiene dos URLs distintas. La test solo funciona cuando el workflow está en modo "Listen for Test Event". La production funciona siempre que el workflow esté activo.
Por qué aquí: confundir las dos es el error #1 de principiantes en n8n.
Qué saber al final: distinguir las dos URLs siempre.

### 🚨 Errores típicos del Bloque 4

- **Olvidar activar el workflow.** El test URL funciona, lo despliegas, en producción no recibe webhooks. Workflow tiene que estar en estado "Active".
- **Confundir test URL con production URL.** Ya mencionado. Causa horas de debug.
- **No guardar workflow antes de cerrar pestaña.** n8n no autoguarda agresivamente. Pierdes el trabajo.
- **Expresión mal escrita y nodo siguiente recibe `undefined`.** Verificar siempre con el "test step" antes de seguir.
- **Workflow que falla a medio camino y deja Supabase con estado inconsistente.** Usar try/catch a nivel workflow, marcar estados intermedios.
- **No diferenciar `$json` (datos del nodo anterior) vs `$node["X"].json` (datos de un nodo específico).** Causa de bugs sutiles.
- **Credentials configuradas en un workspace y workflow exportado a otro.** Al importar hay que reconfigurar credentials.

---

## Bloque 5 — El modelo LLM y function calling (semana 3) ⭐⭐

🔴 **System prompt vs user prompt** ⭐
Qué es: system prompt = instrucción permanente que define rol y comportamiento. User prompt = lo que cambia cada turno.
Por qué aquí: tu system prompt define el agente. Vive en `/agent/prompts.md`.
Qué saber al final: diferenciar, escribir system prompt claro y conciso.

🔴 **Tokens y context window** ⭐
Qué es: el modelo no procesa caracteres, procesa tokens (~1 token = 4 caracteres en inglés, en español algo más). El context window es el máximo de tokens que puede manejar a la vez (Claude Sonnet: 200k).
Por qué aquí: si pasas conversación entera muy larga + RAG context + system prompt, puedes superar el límite. Y los tokens cuestan dinero.
Qué saber al final: estimar tokens de un texto, saber cuándo hay que truncar contexto.

🔴 **Temperature y otros parámetros**
Qué es: temperature controla la "creatividad" del modelo (0 = determinista, 1 = creativo). Top_p, max_tokens, etc. son otros.
Por qué aquí: para un agente conversacional con clínicas, temperature baja-media (0.3-0.5) es lo apropiado. Demasiado alta = respuestas inventadas. Demasiado baja = robótico.
Qué saber al final: elegir temperature según caso de uso.

🔴 **Modelos disponibles y elección**
Qué es: Claude Opus / Sonnet / Haiku, GPT-4o / 4o-mini, Llama 3, etc. Cada uno tiene precio, velocidad y calidad distintos.
Por qué aquí: tu decisión arquitectónica de Sonnet en producción es defendible. Saber por qué no Haiku (más barato pero peor calidad) ni Opus (mejor calidad pero 5x más caro).
Qué saber al final: defender la elección de Sonnet en entrevista con criterios de coste/calidad/velocidad.

🔴 **Costes del modelo: input vs output tokens**
Qué es: los modelos cobran distinto por tokens de entrada (lo que tú envías) y de salida (lo que el modelo genera). Output es 4-5x más caro.
Por qué aquí: si el system prompt + RAG context + conversación es muy largo, los input tokens se acumulan en cada llamada.
Qué saber al final: estimar coste de una conversación típica.

🔴 **Function calling / tool use** ⭐⭐
Qué es: patrón donde el modelo devuelve JSON estructurado con mensaje al usuario Y opcionalmente tools a invocar. Detallado en CLAUDE.md 4.4.
Por qué aquí: decisión arquitectónica clave del proyecto.
Qué saber al final: explicar el patrón en 2 minutos. Distinguir tools sin retorno de tools con retorno. Defender por qué este patrón.

🔴 **Validación de output JSON** ⭐
Qué es: el modelo a veces devuelve JSON malformado o tools inválidas. n8n valida.
Por qué aquí: definido en CLAUDE.md 4.4 (`unknown_tool`).
Qué saber al final: entender por qué siempre se valida, qué pasa si falta un campo.

🔴 **Bucle anti-loop**
Qué es: límite de llamadas consecutivas al modelo cuando hay tools con retorno (máx 3 sin intervención del lead).
Por qué aquí: definido en CLAUDE.md 4.4.
Qué saber al final: entender por qué existe y qué pasaría sin ella.

🔴 **Contexto y memoria de conversación** ⭐
Qué es: el modelo no recuerda nada entre llamadas. Cada llamada lleva el historial completo desde Supabase.
Por qué aquí: conversaciones duran horas o días.
Qué saber al final: explicar "el modelo no tiene memoria, la memoria vive en Supabase".

🔴 **Hallucinations**
Qué es: cuando el modelo inventa información que no tiene (precios que no existen, servicios falsos).
Por qué aquí: con clínicas reales, una hallucination es desastre (cita inventada, precio incorrecto).
Qué saber al final: mitigaciones: RAG bien hecho, system prompt que diga "si no sabes, di que no sabes", verificación de output.

🔴 **Streaming vs no-streaming**
Qué es: streaming = el modelo devuelve texto a medida que lo genera (como en ChatGPT). No-streaming = devuelve todo de golpe.
Por qué aquí: en este proyecto NO usamos streaming (WhatsApp no lo soporta nativamente y n8n procesa la respuesta entera antes de enviar).
Qué saber al final: saber que existe, saber por qué no aquí.

### 🚨 Errores típicos del Bloque 5

- **Conversación crece sin límite y supera context window.** Hay que truncar histórico cuando se acerca al límite, manteniendo últimos N mensajes + resumen del resto.
- **Modelo devuelve JSON malformado y rompe n8n.** Siempre `try/catch` al parsear. Si falla, fallback a "respuesta tipo handoff humano".
- **Modelo inventa una tool que no existe.** Validar contra set cerrado. Si la tool no está, ignorar tool y enviar solo `message_text`.
- **System prompt demasiado largo o contradictorio.** Mantener corto, claro, con ejemplos few-shot si hace falta.
- **Olvidar pasar el historial de conversación en cada llamada.** El modelo "no recuerda" lo que pasó hace 5 mensajes si no se lo pasas.
- **Hallucination de precio o servicio.** Mitigación: RAG bien hecho + en system prompt "si la info no está en el contexto, di que necesitas confirmar con humano".
- **Bug en código hace bucle infinito de llamadas al modelo.** Coste se dispara. Salvaguarda anti-loop + alerta de gasto diario.
- **Temperature demasiado alta para caso de uso serio.** Respuestas inconsistentes entre conversaciones similares.

---

## Bloque 6 — RAG y embeddings (semana 4) ⭐⭐

🔴 **Embeddings** ⭐
Qué es: representación numérica (vector) de un texto. Textos con significado similar tienen vectores cercanos.
Por qué aquí: convertimos la base de conocimiento de la clínica en embeddings para búsqueda semántica.
Qué saber al final: explicar embeddings sin usar la palabra. Saber que se hace una vez al indexar y cada vez al recuperar.

🔴 **Vector database** ⭐
Qué es: BD especializada en guardar y buscar embeddings rápido. Pinecone es la más conocida.
Por qué aquí: Pinecone almacena embeddings del catálogo. Cuando el lead pregunta algo, busca embeddings similares.
Qué saber al final: explicar por qué BD vectorial es distinta de relacional. Saber qué es índice y namespace en Pinecone.

🔴 **Chunking de documentos**
Qué es: cortar documentos largos en trozos (chunks) antes de vectorizar. Un PDF de 50 páginas no se vectoriza entero, se trocea.
Por qué aquí: el catálogo de la clínica tiene servicios, descripciones, precios, FAQs. Hay que decidir cómo trocearlo.
Qué saber al final: estrategias de chunking (por párrafo, por sección, tamaño fijo con overlap), decidir cuál usar aquí.

🔴 **Similitud semántica vs búsqueda por keywords**
Qué es: keyword busca palabras exactas. Semántica busca por significado. "Cuánto vale la limpieza" encuentra "Higiene bucal profesional - 45€".
Por qué aquí: clínicas tienen vocabulario propio, leads usan coloquial.
Qué saber al final: explicar la diferencia con ejemplo.

🔴 **RAG: Retrieval Augmented Generation** ⭐⭐
Qué es: antes de llamar al modelo, buscar info relevante en BD vectorial e inyectarla en el prompt como contexto.
Por qué aquí: el modelo no sabe precios ni servicios. RAG le pasa contexto en cada llamada.
Qué saber al final: explicar RAG en 2 minutos. Distinguir RAG de fine-tuning. Saber cuándo cada uno.

🔴 **top_k y umbral de similitud**
Qué es: top_k = cuántos resultados similares devolver (típico: 3-5). Umbral = filtrar resultados con similitud por debajo de cierto valor.
Por qué aquí: top_k bajo = puede que no encuentre info relevante. top_k alto = mete ruido en el prompt.
Qué saber al final: empezar con top_k = 3-5, ajustar con datos reales.

🔴 **Metadata filtering**
Qué es: además de buscar por similitud, filtrar por metadata (ej: solo servicios de "estética facial", no de "estética corporal").
Por qué aquí: cuando una clínica tiene varias secciones, el filtro evita resultados cruzados.
Qué saber al final: entender que cada vector se guarda con metadata estructurada, no solo el texto.

🔴 **Namespaces de Pinecone**
Qué es: forma de separar lógicamente índices dentro del mismo índice físico. Cada clínica = su namespace.
Por qué aquí: cuando V2 tenga multi-clínica, cada una en su namespace. En V1 con una clínica también se configura así para preparar.
Qué saber al final: configurar namespace, entender separación lógica.

🔴 **Indexación y reindexación**
Qué es: indexar = vectorizar documentos y guardarlos. Reindexar = volver a hacerlo (al cambiar proveedor de embeddings o actualizar base).
Por qué aquí: en semana 5 pasas de HuggingFace embeddings a OpenAI. Reindexas todo (dimensiones distintas).
Qué saber al final: entender el coste (céntimos para una clínica) y por qué es necesario al cambiar modelo.

🔴 **Dimensiones de embeddings**
Qué es: número de números (dimensions) que componen el vector. HuggingFace típicamente 384. OpenAI text-embedding-3-small: 1536.
Por qué aquí: NO son intercambiables. Si Pinecone tiene índice de 384 dim y le metes uno de 1536, peta.
Qué saber al final: saber que las dimensiones tienen que coincidir, recrear índice al cambiar.

### 🚨 Errores típicos del Bloque 6

- **Chunks demasiado grandes**: el modelo recibe contexto enorme y la similitud se diluye.
- **Chunks demasiado pequeños**: pierdes contexto. "El precio es 45€" sin saber de qué servicio.
- **Mezclar embeddings de distintos modelos en el mismo índice.** Resultados aleatorios. Reindexar todo desde cero.
- **No usar namespace y mezclar datos.** Si añades segunda clínica sin namespace, sus servicios aparecen en respuestas de la primera.
- **top_k = 1.** Si el primer resultado no es relevante, el agente responde basándose en algo irrelevante.
- **Indexar texto sin limpiar.** Encabezados, formato, basura HTML metida en embeddings hace que la similitud sea ruidosa.
- **No actualizar índice cuando cambia el catálogo.** Cliente añade servicio nuevo, el agente sigue diciendo que no lo tienen.
- **Embeddings caros en bucle por bug.** Aunque OpenAI embeddings es barato, indexar en bucle por error escala. Alerta.

---

## Bloque 7 — Despliegue y producción (semana 5)

🔴 **Hosting y despliegue**
Qué es: poner código en servidor siempre encendido. Railway lo hace fácil.
Por qué aquí: n8n self-hosted en Railway. Al desplegar, Railway lo arranca y da URL pública.
Qué saber al final: deploy en Railway, ver logs, reiniciar.

🔴 **Variables de entorno en producción**
Qué es: configurar `.env` en Railway, no en código.
Por qué aquí: cada API key se configura una vez en Railway, se inyecta al servicio al arrancar.
Qué saber al final: añadir, modificar, ver variables. Saber que hay que redeploy tras cambios.

🔴 **Logs y monitoring**
Qué es: registros de lo que pasa, para debug.
Por qué aquí: eventos en Supabase tabla `events`. Logs de Railway y n8n.
Qué saber al final: saber dónde mirar primero cuando algo falla.

🔴 **Alertas**
Qué es: notificaciones cuando algo importante pasa (error crítico, gasto disparado).
Por qué aquí: definidas en CLAUDE.md 6.5 y costs.md 6.
Qué saber al final: configurar al menos una alerta a email o Slack.

🔴 **Restart vs redeploy vs rollback**
Qué es: restart = reiniciar sin cambios. Redeploy = volver a desplegar última versión. Rollback = volver a versión anterior.
Por qué aquí: si algo se rompe en producción, saber qué hacer y en qué orden.
Qué saber al final: identificar cuál usar en cada caso.

🔴 **Healthchecks básicos**
Qué es: endpoint o comprobación que verifica que el servicio está vivo.
Por qué aquí: si n8n se cae sin avisar, ningún webhook entra. Un healthcheck simple cada X minutos detecta esto.
Qué saber al final: saber que existe, configurar uno mínimo.

🔴 **Transición Twilio sandbox → número real** ⭐
Qué es: paso más delicado de semana 5. Reconfigurar webhooks, validar entregabilidad.
Por qué aquí: documentado en costs.md 3.
Qué saber al final: ejecutar transición sin romper agente, validar que mensajes salen del número real.

🔴 **DNS y dominios** (opcional para V1)
Qué es: cómo funcionan las URLs públicas. Railway te da subdominio gratis. Dominio propio es opcional.
Por qué aquí: para V1 no necesitas dominio propio. Para producción seria sí.
Qué saber al final: saber que existe, no necesitas configurarlo en V1.

### 🚨 Errores típicos del Bloque 7

- **Olvidar variable de entorno tras redeploy.** Servicio arranca pero rompe en runtime porque falta una env var.
- **Servicio caído sin enterarte porque no hay alertas.** Configurar alertas DESDE EL DÍA UNO.
- **Webhook apuntando a URL local en lugar de producción.** Mismo problema del bloque 4 pero más caro: en producción afecta a clientes reales.
- **Redeploy mientras hay tráfico real.** Si la clínica está activa, el redeploy puede perder mensajes. Avisar y desplegar en horas de baja actividad.
- **Logs no estructurados y no encontrar nada.** Logs deben ser legibles. JSON con timestamp + nivel + mensaje + contexto.
- **No rotar API keys cuando un dev se va o se filtra alguna.** Política básica de seguridad.

---

## Bloque 8 — Portfolio y entrevistas (semana 6)

🔴 **Cómo se cuenta una decisión técnica**
Qué es: estructura: problema, opciones consideradas, decisión, razón, trade-offs.
Por qué aquí: tu portfolio se basa en 3-5 decisiones técnicas defendibles.
Qué saber al final: explicar "arquitectura desacoplada con adaptadores" en 2 minutos sin notas.

🔴 **README de portfolio público**
Qué es: archivo README.md del repo público. Primera impresión para reclutadores.
Por qué aquí: tu repo es parte del portfolio.
Qué saber al final: README que cuente problema, solución, arquitectura, stack, video demo, sin presumir.

🔴 **Demo en video (Loom o similar)**
Qué es: video de 2-3 min mostrando el sistema funcionando end-to-end.
Por qué aquí: el reclutador no va a ejecutar tu código. Necesita ver que funciona.
Qué saber al final: grabar demo concisa, sin disclaimers de sandbox, sin credenciales visibles, con narración clara.

🔴 **Capturas (screenshots)**
Qué es: imágenes del sistema funcionando. Conversación de WhatsApp, dashboard de Cal.com con cita creada, fila en Supabase, registro en HubSpot.
Por qué aquí: dan prueba visual rápida.
Qué saber al final: capturar lo importante, no lo decorativo.

🔴 **Licencia del repo**
Qué es: MIT, Apache 2.0, etc. Define qué puede hacer otra gente con tu código.
Por qué aquí: si tu repo es público sin licencia, técnicamente nadie puede usarlo legalmente.
Qué saber al final: MIT es la elección estándar para portfolios.

🔴 **Defensa en entrevista**
Qué es: anticipar preguntas, tener respuestas preparadas sin sonar a guion.
Por qué aquí: objetivo final = conseguir trabajo.
Qué saber al final: responder con autoridad a las 10 preguntas típicas.

### 🚨 Errores típicos del Bloque 8

- **README de 5.000 palabras.** Nadie lo lee. Máximo 1-2 minutos de lectura.
- **Video demo de 10 minutos.** Nadie lo ve. 2-3 min y al grano.
- **Credenciales/datos sensibles visibles en demo o screenshots.** Censurar números de teléfono reales, emails reales, API keys.
- **Repo público con `.env` real subido.** Mismo problema que en bloque 1, pero ahora público.
- **README sin sección de "decisiones técnicas".** El reclutador no entiende por qué elegiste lo que elegiste.
- **No mencionar trade-offs.** "Todo perfecto" suena falso. "Elegí X aunque Y tenía estas ventajas porque..." suena maduro.
- **Hablar mal de Anvil o tu socio en entrevistas para justificar tu posición.** Nunca. Profesional siempre.

---

## Conceptos que NO vamos a tocar en V1

Para no abrumarse pensando que hay que aprender todo:

- **Testing automatizado** (Jest, Vitest, etc.).
- **CI/CD** (GitHub Actions).
- **Docker y contenedores** (Railway lo gestiona).
- **Autenticación humana avanzada** (OAuth, JWT). No hay usuarios humanos en V1.
- **Optimización de rendimiento.**
- **Frontend / UI custom.** Todo es WhatsApp + dashboards externos.
- **Escalado horizontal, balanceadores, alta disponibilidad.**
- **Programación orientada a objetos, patrones de diseño avanzados.**
- **TypeScript.** Si toca algo de JavaScript en Code nodes, JS plano.
- **Microservicios.** Esto es monolito orquestado en n8n.

Si en entrevista preguntan por estos temas, la respuesta es: "no era necesario para V1, lo dejé como roadmap si el sistema escalaba". Respuesta de senior, no de junior.

---

## Cómo defender el conjunto en una entrevista

Tres capas para "cuéntame qué has aprendido":

**Capa 1 (conceptual):** "Aprendí a diseñar arquitectura de agente IA con capa intermedia desacoplada, patrón function calling para tools, y RAG sobre vector database. Lo más importante: a tomar decisiones técnicas con criterios de negocio, no por moda."

**Capa 2 (técnica):** "A nivel técnico, schemas de Supabase con SQL, orquestación en n8n con manejo de errores y retries, integración con APIs (Twilio, Cal.com, HubSpot), embeddings y vector search en Pinecone, y el patrón completo de function calling con anti-loop."

**Capa 3 (operacional):** "Y aprendí a desplegar y mantener un sistema en producción: variables de entorno, logs, alertas, y una transición real de proveedores (de modelo free a Claude API) que mostró que la arquitectura estaba bien diseñada."

Para detalles específicos, vas al bloque correspondiente.

---

## Si surge un concepto no anticipado

A pesar de haber añadido ~30 conceptos y "errores típicos" por bloque, **es posible** que aparezca algo no contemplado. Cuando pase:

1. **No te asustes.** No es señal de que el documento esté mal, es señal de que estás aprendiendo cosas reales.
2. **Para a Claude Code con "PARA. Sección 9."** y pídele que te lo explique siguiendo el protocolo.
3. **Cuando lo entiendas, añádelo manualmente al bloque correspondiente** con el mismo formato (qué es, por qué aquí, qué saber al final).
4. **Si Claude Code escribió la entrada en la Parte B** de este documento al final de sesión, también vale: la Parte B es el registro real.

El documento es **un mapa vivo**. Está mejor cuanto más lo usas.

---

# Parte B: Sesiones

> Esta sección la rellena Claude Code al final de cada sesión, siguiendo el formato definido en `CLAUDE.md` sección 9.6. Empieza vacía y va creciendo.

<!-- Aquí Claude Code añade las entradas de cada sesión -->

## 2026-06-07 — Pipeline completo: body, lead, mensaje vinculado y log de eventos

### Conceptos nuevos

- **Estructura anidada del webhook en n8n:** cuando Twilio llama al webhook de n8n, los campos del mensaje (Body, From, MessageSid) no llegan al nivel raíz del JSON — llegan dentro de una clave llamada `body`. En el nodo Code, la ruta correcta es `$input.item.json.body['Body']`, no `$input.item.json['Body']`. Esto es específico de n8n v2 con webhooks POST de tipo form-urlencoded.
- **Upsert con Supabase REST API:** para hacer "inserta si no existe, devuelve el existente si ya está", Supabase necesita dos cosas juntas: (1) el header `Prefer: resolution=merge-duplicates,return=representation` y (2) el parámetro de URL `?on_conflict=phone` que le dice qué columna usar como referencia de conflicto. Sin el `?on_conflict`, Supabase no sabe dónde buscar el duplicado y falla con error de clave única.
- **n8n desenvuelve arrays de Supabase:** cuando Supabase devuelve `[{id, phone, ...}]` (un array con un elemento), n8n lo desenvuelve automáticamente. En el siguiente nodo, `$node["Upsert lead"].json` es el objeto directamente `{id, phone, ...}`, no el array. Por eso se usa `.json.id` y no `.json[0].id`.
- **Referencia cruzada entre nodos en n8n:** con la sintaxis `$node["NombreNodo"].json.campo` puedes acceder a los datos de cualquier nodo anterior, no solo del inmediatamente anterior. Esto permite que un nodo use datos de dos nodos distintos sin necesitar un nodo intermedio que los combine.
- **Dos workflows con el mismo nombre:** n8n permite tener varios workflows con el mismo nombre. El activo (el que recibe webhooks reales) puede ser diferente del que aparece primero en la lista. Hay que verificar siempre cuál tiene `active: true` antes de hacer cambios.

### Patrones técnicos aplicados

- **Pipeline de 5 nodos para un mensaje entrante:** Recibir → Parsear → Upsert lead → Guardar mensaje → Log evento → Responder. Cada nodo tiene una responsabilidad única. Los nodos de "Guardar mensaje" y "Log evento" usan referencias cruzadas para acceder a datos de nodos anteriores sin duplicar trabajo.
- **Debug por capas vía API:** cuando algo fallaba, usamos la API REST de n8n (`/api/v1/executions`) para ver el output exacto de cada nodo en la última ejecución, sin necesidad de abrir la UI. Permite diagnosticar en producción.
- **Credenciales hardcodeadas para V1:** como `$env` está bloqueado para nodos añadidos vía API (pero no para los configurados manualmente), la solución pragmática en V1 es pegar los valores directamente. Anotado como deuda técnica para resolver con Variables de n8n en V2.

### Decisiones técnicas

- **`on_conflict=phone` en la URL del upsert:** elegido sobre otras alternativas (hacer GET primero para buscar el lead, o usar `resolution=ignore-duplicates` + GET separado) porque es la forma más directa y atómica: una sola llamada que crea o encuentra y siempre devuelve el lead con su id.
- **`payload` como JSONB en events:** en lugar de columnas fijas (phone, message_body...), el payload es un objeto libre. Esto permite que distintos tipos de eventos tengan estructuras distintas sin cambiar el schema. `message_received` guarda phone + body + sid. Futuros eventos como `appointment_booked` guardarán otros campos.

### Sintaxis / herramientas nuevas

- **`$node["NombreNodo"].json.campo`:** sintaxis de n8n para referenciar datos de un nodo específico por nombre. Las comillas dobles dentro de la expresión `={{ ... }}` se escapan como `\"`.
- **`?on_conflict=columna` en URL de Supabase:** parámetro de query que activa el comportamiento upsert de PostgREST. Sin él, `resolution=merge-duplicates` no sabe qué columna usar y falla.
- **`Prefer: resolution=merge-duplicates,return=representation`:** header que combina dos instrucciones a Supabase: "si hay conflicto, actualiza" + "devuelve la fila completa en la respuesta".
- **API REST de n8n para debug:** `GET /api/v1/executions?workflowId=ID&limit=1&includeData=true` devuelve la última ejecución con el output de cada nodo. Indispensable para diagnosticar en producción sin tocar la UI.

### Preguntas pendientes

- ¿Cómo configurar Variables de n8n (`$vars`) correctamente para no depender de credenciales hardcodeadas en los nodos? Pendiente para cuando Railway tenga las variables configuradas y n8n las exponga como `$vars`.
- ¿Por qué `$env` funciona para nodos configurados manualmente en la UI pero no para nodos añadidos vía API? Diferencia de versión o de permisos de ejecución — no investigado en esta sesión.

## 2026-06-03 — Happy path mínimo: WhatsApp → n8n → Supabase → respuesta fija

### Conceptos nuevos

- **Webhook trigger:** una URL que n8n genera y le das a Twilio. Cuando llega un WhatsApp, Twilio llama a esa URL con los datos del mensaje y n8n arranca el workflow. Es "push" (Twilio te avisa), no "pull" (n8n pregunta si hay mensajes).
- **Twilio sandbox:** número de WhatsApp compartido gratuito para pruebas. Para usarlo, el móvil de prueba envía primero un mensaje de activación ("join [palabra]"). Solo acepta mensajes de teléfonos activados. No sirve para leads reales, solo para tus pruebas en semanas 1-4.
- **Test URL vs Production URL en n8n:** cada webhook tiene dos URLs distintas. La test solo funciona cuando tienes n8n abierto esperando manualmente. La production funciona siempre que el workflow esté activo. Error clásico: pegar la test URL en Twilio y luego no entender por qué no llegan mensajes.
- **Supabase REST API automática:** cuando creas una tabla en Supabase, automáticamente tienes un endpoint para insertar y leer filas. n8n la llama como cualquier otra API. No hace falta escribir servidor propio.
- **Row Level Security (RLS):** seguridad por fila que Supabase activa por defecto. Sin políticas configuradas, todas las queries devuelven vacío o error silencioso. En V1 lo desactivamos para las tablas internas. Síntoma si está activo: insertas desde n8n, no hay error, pero en Supabase no aparece nada.
- **service_role key vs anon key en Supabase:** la anon key es pública con permisos limitados. La service_role key es privada con acceso total (bypasea RLS). n8n usa la service_role key, guardada como variable de entorno en Railway, nunca en el código.

### Patrones técnicos aplicados

- **Webhook → Code → HTTP Request → Respond to Webhook:** los 4 nodos del workflow de hoy. Patrón base que se repetirá en todos los workflows que reciban mensajes entrantes.
- **Variables de entorno para secretos:** las API keys de Supabase se ponen en Railway como variables de entorno (`SUPABASE_URL`, `SUPABASE_SERVICE_KEY`). n8n las lee con `$env.SUPABASE_URL`. Nunca en el JSON del workflow.
- **TwiML como respuesta:** Twilio espera que el webhook responda con XML en formato TwiML para enviar el mensaje de vuelta al lead. n8n lo genera con el nodo "Respond to Webhook" con Content-Type text/xml.

### Decisiones técnicas

- **lead_id nullable en messages para V1:** el mensaje se guarda aunque el lead no exista aún en la tabla leads. Permite tener el happy path funcionando sin necesidad de crear el lead primero. Se vincula en sesión 2.
- **RLS desactivado en V1:** una sola clínica, acceso interno. Activarlo con políticas correctas requiere más configuración. Se deja para V2 multi-clínica donde es obligatorio.
- **Respuesta fija en lugar de modelo LLM:** el happy path de semana 1 no usa modelo. La respuesta "Hola, hemos recibido tu mensaje..." es hardcoded en el nodo TwiML. El modelo se añade en semana 3.

### Sintaxis / herramientas nuevas

- **Expresión n8n:** `={{ expresión }}` — la forma de usar variables dinámicas en campos de n8n. Ejemplo: `={{ $env.SUPABASE_URL }}` lee la variable de entorno. Sin el `=` al principio, n8n lo trata como texto literal.
- **`$input.item.json['Campo']`:** en el nodo Code de n8n, así se accede a los datos que llegan del nodo anterior. `$input.item` es el dato actual, `.json` es el objeto JSON, `['From']` es el campo concreto.
- **`gen_random_uuid()`:** función de PostgreSQL (la base de datos de Supabase) que genera un UUID automáticamente al insertar una fila. Por eso en el schema el `id` no lo ponemos nosotros, lo genera Supabase.
- **`TIMESTAMPTZ`:** tipo de columna en PostgreSQL para fechas con zona horaria. Es el correcto para timestamps en un sistema que podría tener usuarios en distintas zonas. `DEFAULT now()` lo rellena automáticamente.
- **`JSONB`:** tipo de columna en PostgreSQL para guardar JSON. La B significa "binary" — lo almacena optimizado para búsquedas. Usado en la tabla `events.payload` para guardar cualquier estructura sin saber de antemano qué campos tendrá.

### Preguntas pendientes

- ¿Cómo se valida la firma de los webhooks de Twilio? (Bloque 3 del curriculum: "firmar/validar webhooks de Twilio"). No es necesario para V1 pero es una mejora de seguridad para producción.
- El nodo HTTP Request en n8n: ¿cuándo usar "specifyBody: json" vs "keypairs"? Quedó pendiente verificar cuál encaja mejor en la versión exacta de n8n desplegada en Railway.
- ¿Por qué llegan vacíos `Body` y `MessageSid` de Twilio en el nodo Code? Pendiente inspeccionar el payload raw del webhook en n8n para ver los nombres exactos de campo.

---

## 2026-06-07 — Debug del happy path: GRANT, $env y conexión MCP

### Conceptos nuevos

- **GRANT en PostgreSQL:** permiso a nivel de tabla. Distinto de RLS (que es nivel de fila). Si no existe el GRANT, el rol no puede ni tocar la tabla, aunque sea `service_role` y aunque RLS esté desactivado. Crear tablas desde el SQL Editor de Supabase no añade GRANTs automáticamente — hay que hacerlo explícito.
- **`$env` bloqueado en n8n:** n8n bloquea por defecto el acceso a variables de entorno del sistema desde los workflows, por seguridad. La alternativa correcta es usar `$vars` (Variables de n8n) o pegar los valores directamente en el nodo para V1.
- **MCP (Model Context Protocol):** protocolo que permite a Claude conectarse directamente a herramientas externas (n8n, Supabase, etc.) y operar sobre ellas sin que el usuario tenga que hacer cambios manualmente. Se configura en `~/.claude/settings.json`.
- **n8n API REST:** n8n expone una API propia en `/api/v1/` que permite listar, leer y modificar workflows programáticamente. Se llama con header `X-N8N-API-KEY`. Útil para debug sin tocar la UI.

### Patrones técnicos aplicados

- **Diagnóstico por capas:** cuando algo falla, se aísla la capa exacta haciendo la misma llamada desde distintos sitios (primero n8n, luego PowerShell directo a Supabase). Si falla en ambos, el problema es en Supabase. Si falla solo en n8n, el problema es en cómo n8n construye la llamada.
- **JWT decode para verificar rol:** los tokens JWT de Supabase (anon key, service_role key) son decodificables y contienen el campo `role`. Se puede verificar qué key se está usando sin depender de lo que dice la UI.

### Decisiones técnicas

- **Credenciales pegadas directamente en el nodo (V1):** sin Variables de n8n disponibles y con $env bloqueado, la solución pragmática para V1 es pegar los valores directamente. Trade-off: si la key cambia, hay que actualizar el nodo manualmente. Aceptable para una clínica en V1.
- **GRANT solo a service_role, no a anon:** las operaciones de backend (insertar mensajes, crear leads) deben ir por service_role. Dar acceso a anon sería inseguro para tablas internas.

### Sintaxis / herramientas nuevas

- **`GRANT ALL ON TABLE x TO role`:** sentencia SQL que da permisos totales a un rol sobre una tabla. Se ejecuta una vez en el SQL Editor de Supabase.
- **`Invoke-RestMethod` en PowerShell:** equivalente a `curl` en Windows. Hace llamadas HTTP directamente desde la terminal. Útil para probar APIs sin depender de n8n.
- **`X-N8N-API-KEY` header:** así se autentican las llamadas a la API REST de n8n. Distinto del header `Authorization` que se usa para APIs de terceros.

### Preguntas pendientes

- ¿Por qué llegan vacíos `Body` y `MessageSid` de Twilio? Investigar en sesión 2 inspeccionando el payload raw.
- ¿Cómo configurar Variables de n8n (`$vars`) correctamente para no depender de credenciales hardcodeadas en los nodos?
