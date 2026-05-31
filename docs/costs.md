# costs.md — Costes del proyecto y plan de transición

> Este documento vive en `/docs/costs.md`. Define qué se usa en cada fase, cuánto cuesta, y cuál es la herramienta homóloga de pago para cuando V1 escale o se venda.

## 1. Filosofía

Construimos en dos fases. La **fase de aprendizaje y construcción** usa herramientas gratuitas o free-tier. La **fase de producción y demo** usa herramientas profesionales que cuestan céntimos pero garantizan calidad.

**Razón:** la arquitectura es proveedor-agnóstica. Cambiar de fase es cambiar configuración, no rediseñar.

## 2. Stack por fases

### 2.1 Fase de construcción y aprendizaje (semanas 1-4)

| Componente | Herramienta | Plan | Coste |
|---|---|---|---|
| Orquestación | n8n self-hosted en Railway | Free tier ($5 crédito Railway) | 0€ |
| Modelo LLM | Groq u OpenRouter | Modelos free (Llama 3, Mistral) | 0€ |
| Embeddings | HuggingFace Sentence Transformers | Free | 0€ |
| Vector store | Pinecone | Free tier (1 índice, 100k vectores) | 0€ |
| WhatsApp | Twilio | Sandbox compartido | 0€ |
| Calendario | Cal.com | Free | 0€ |
| Capa intermedia | Supabase | Free tier (500MB BD) | 0€ |
| Adaptador CRM | HubSpot | Free | 0€ |

**Total fase 1: 0€**

### 2.2 Fase de producción y demo (semana 5 y siguientes)

Cambian solo los tres componentes que afectan a la calidad final del producto:

| Componente | Cambia a | Por qué |
|---|---|---|
| Modelo LLM | Claude Sonnet vía API Anthropic | Calidad conversacional notablemente superior, necesaria para demo creíble |
| Embeddings | OpenAI text-embedding-3-small ($0.02 por millón de tokens, verificado mayo 2026) | Estándar de la industria, coherente con stack de Anvil, coste ridículo |
| WhatsApp | Número Twilio real en cuenta Anvil verificada | Sandbox no es presentable en demo ni utilizable con clientes |

**Coste durante fase de demo (~2 semanas hasta tener demo grabada): ~15€ totales.**

### 2.3 Producción real con clínica activa (post-demo)

Cuando una clínica firme y reciba leads reales:

| Componente | Coste mensual (estimación 100 leads/mes) |
|---|---|
| Claude API | 10-15€ |
| OpenAI embeddings | <1€ (a este volumen es prácticamente cero) |
| Twilio (número + mensajes WhatsApp) | 5-10€ |
| Pinecone | 0€ (free tier) |
| Supabase | 0€ (free tier) |
| Railway | 0-5€ |
| Cal.com | 0€ |
| HubSpot (de la clínica, no nuestro) | N/A |
| **Total por clínica activa** | **15-30€/mes** |

**Estos costes los asume Anvil dentro de la cuota mensual cobrada al cliente.**

## 3. Plan de transición (semana 5)

Cuando se decide pasar de fase 1 a fase 2:

### Día 1 (lunes)
- Solicitar número Twilio nuevo en cuenta Anvil verificada.
- Configurar display name del número (24-72h de espera Meta).

### Días 1-3 (mientras llega Twilio)
- Crear cuenta Anthropic API, obtener credits iniciales.
- Crear cuenta OpenAI API, obtener credits iniciales.
- Cambiar variables de configuración en n8n: endpoints, API keys.
- **No tocar workflows ni código de orquestación.**

### Día 3-4
- Reindexar la base de conocimiento de la clínica en Pinecone con OpenAI embeddings.
- **Importante:** los embeddings de HuggingFace y los de OpenAI **no son compatibles** (dimensiones distintas, geometría semántica distinta). No se "migra", se reindexa desde cero. El catálogo completo de una clínica son céntimos en API calls de embedding.
- Probar que las búsquedas RAG siguen recuperando contexto correcto. La calidad de recuperación puede mejorar respecto a HuggingFace, pero hay que verificar manualmente con 5-10 consultas de prueba.

### Día 4-5
- Pruebas de conversación end-to-end con stack de producción.
- Ajuste fino de prompts si el modelo Claude responde distinto a Groq (lo hará, mejor).

### Día 5+
- Número Twilio ya activo.
- **Reconfigurar webhooks de Twilio.** Importante: la transición del sandbox al número real NO es transparente. El sandbox usa endpoints compartidos de Twilio y requiere que el usuario envíe "join [palabra]" para activarse. El número real usa webhooks dedicados configurados en Twilio Console apuntando a tu URL de n8n. Hay que:
  1. Configurar URL del webhook en Twilio Console del número nuevo.
  2. Actualizar el endpoint en los workflows de n8n que reciben mensajes.
  3. Verificar que los mensajes salientes ahora salen desde el número nuevo y no desde el sandbox.
- Pruebas con número real.
- Si todo OK, grabación de demo final.

## 4. Homólogos de pago para escalar

Si V1 escala más allá de lo que aguanta el free tier:

| Componente actual | Limite del free tier | Homólogo de pago | Coste |
|---|---|---|---|
| Railway free | $5 crédito/mes | Railway Pro | desde $5/mes real |
| Pinecone free | 1 índice, 100k vectores | Pinecone Standard | 70$/mes |
| Supabase free | 500MB BD, 50k MAU | Supabase Pro | 25$/mes |
| Cal.com free | Funcional | Cal.com Teams | 12$/mes/usuario |
| HubSpot Free (demo) | Limitado | HubSpot Starter o el CRM real del cliente | varía |

**Decisión de escalado:** se hace cuando hay datos reales que lo justifican, no antes. Cada upgrade se documenta en `architecture.md` con la razón.

## 5. Lo que NUNCA cuesta dinero

- El diseño de la arquitectura.
- Los workflows de n8n.
- Los prompts.
- El schema de Supabase.
- La estructura del repo.
- La documentación.

Eso es **el activo del proyecto**. Las API keys son commodity intercambiable.

## 6. Riesgos de coste

- **Claude API descontrolada:** si un bug hace que el agente llame al modelo en bucle, el coste puede dispararse. **Mitigación:** rate limiting en n8n (máximo N llamadas por minuto por lead) + alerta si el gasto diario supera 2€.
- **Twilio fuera de control:** si alguien envía spam desde el sistema o un bug hace bucle de mensajes, Twilio cobra por mensaje. **Mitigación:** rate limiting en n8n (máximo N mensajes por hora por lead) + alerta si el gasto diario supera 2€.
- **Reindexación masiva de embeddings:** reindexar un catálogo completo de clínica cuesta céntimos. Si se hace en bucle por error, escala lentamente. **Mitigación:** reindexación solo manual, nunca automática.

Las tres alertas viven en n8n y mandan email a Alex cuando se disparan.
