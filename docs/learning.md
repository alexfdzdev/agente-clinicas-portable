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
