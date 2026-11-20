# Connettore Meta Ads: contratti dei tool ed errori tipici

Verificato sugli schemi del connettore ufficiale (`mcp.facebook.com/ads`) a ottobre 2026. **La descrizione del tool nel connettore è sempre la fonte di verità**: se qualcosa qui non torna, vale lo schema live. I nomi dei tool possono cambiare durante la beta.

*In parte adattato da meta-ads-skill `tool-contracts.md` e `troubleshooting.md` (Beka Zakaidze, MIT).*

## Regole generali

- **ID account** numerico, senza prefisso `act_`. Fa eccezione `ads_experiment_abtest_create_test`, che lo vuole con il prefisso: leggi sempre lo schema.
- **Budget** sempre in **centesimi** della valuta dell'account: 50,00 € = 5000. Non dedurre mai un importo o una cadenza: "2.000 € al mese" non è né giornaliero né totale, quindi chiedi.
- Molti parametri sono **stringhe JSON**, non oggetti: `targeting`, `promoted_object`, `special_ad_categories`, `creative` (in `ads_create_ad`) e `fields` (in `ads_update_entity`).
- Ogni chiamata include `client_conversation_id`, `advertiser_job` e `advertiser_request` come indicato nelle descrizioni dei tool. Le parole del cliente vanno riportate così come sono.
- Se la risposta contiene `next_actions`, esegui in ordine quelle di sola lettura prima di rispondere.

## Lettura: `ads_get_ad_entities`

- Verifica i campi con `ads_get_field_context` prima di usarli (vedi `<profilo>/cliente/campi-verificati.md`).
- `level`: `ad_account`, `campaign`, `adset` (senza trattino basso), `ad`. A livello account non si possono usare filtri, ordinamento e `cost_per_result`.
- Periodo: `date_preset` (`yesterday`, `last_7d`, `last_28d`, …) **oppure** `time_range` `{"since":"AAAA-MM-GG","until":"AAAA-MM-GG"}`. Mai tutti e due. Senza nessuno dei due vale 28 giorni.
- Filtri: `[{"field":"effective_status","operator":"IN","value":["ACTIVE"]}]`, con valori sempre in array di stringhe.
- Ordinamento: stringa, per esempio `amount_spent_descending`.
- Paginazione: se c'è `pagination.next_cursor`, richiama con `cursor` e **tutti gli altri parametri identici**.
- `reporting_purpose` aiuta il tool ad aggiungere le metriche giuste: `key_performance`, `pacing`, `creative`, `entity_lookup`, `metric_lookup`.
- Le bozze si leggono con `object_state: draft` e arrivano in `ad_drafts`, con l'ID in `ad_object_id`. In bozza la lettura con l'ID della campagna restituisce solo la campagna: gruppi e inserzioni si rileggono ognuno col suo ID, da conservare dalla risposta di creazione.

## Media: `ads_creative_upload_media`

- In Claude Code: `upload_source: URL`, con `media_type` IMAGE o VIDEO e un `media_url` **pubblico e diretto**. Drive, Dropbox e Canva non funzionano.
- `LOCAL_FILE` solo nei client con MCP Apps interattive, non in Claude Code da terminale.
- Le immagini restituiscono un **hash**, i video un **video_id**. Lo stato dei video si controlla con `ads_get_ad_videos`: si usano solo quando sono `ready`.

## Creatività: `ads_create_creative`

| Formato | Campi obbligatori |
|---|---|
| Immagine | `ad_account_id`, `page_id`, `link_url`, uno tra `image_hash` e `image_url` |
| Video | `ad_account_id`, `page_id`, `video_id`, più una copertina (`image_hash` o `image_url`). Se usi `description` serve anche `link_url`. |
| Multi-media (più file e testi) | `multi_media` (2-10 voci, ognuna con un solo `image_hash`, `image_url` o `video_id`), `primary_texts`, `headlines`, `descriptions` (fino a 5 ciascuno), più `link_url` se c'è un'immagine |
| Carosello | `cards` (2-10), ognuna con immagine o video, eventuale link e titolo |
| Post esistente della pagina Facebook | `object_story_id` = `<page_id>_<post_id>`, senza altri media o testi |
| Post o reel esistente di Instagram | `page_id` (la pagina abbinata all'account Instagram), `instagram_user_id`, `source_instagram_media_id` (l'`id` da `ads_get_ig_media`), senza altri media o testi. Il pulsante è facoltativo: `link_url` più `call_to_action_type`. Si passa il post originale, non una copia già sponsorizzata |

- `instagram_user_id`: numerico. **Se manca, Instagram è escluso.**
- `call_to_action_type`: solo valori della lista (per esempio `SHOP_NOW`, `LEARN_MORE`, `SIGN_UP`, `BOOK_NOW`, `CONTACT_US`, `GET_OFFER`, `WHATSAPP_MESSAGE`). Le CTA telefoniche non sono supportate.
- `self_ai_disclosure`: `OPT_IN` o `OPT_OUT`, deciso prima, perché non si cambia dopo. Mai impostarlo al posto del cliente.
- `advantage_plus_creative`: lasciare spento se il cliente non vuole le modifiche automatiche di Meta.
- **Le creatività non si modificano**: per cambiare testo o immagine si crea una creatività nuova e un'inserzione nuova, poi si mette in pausa la vecchia.

## Struttura

- **`ads_create_campaign`**:
  - `objective` solo ODAX: `OUTCOME_SALES`, `OUTCOME_LEADS`, `OUTCOME_TRAFFIC`, `OUTCOME_ENGAGEMENT`, `OUTCOME_AWARENESS`, `OUTCOME_APP_PROMOTION`;
  - `buying_type: AUCTION`;
  - budget sulla campagna (CBO) come predefinito, con `campaign_daily_budget` in centesimi;
  - `special_ad_categories` come stringa JSON, per esempio `"[]"`. Si chiude in pausa.
- **`ads_create_ad_set`**:
  - `optimization_goal` scelto solo tra i `valid_optimization_goals` restituiti dalla campagna;
  - `billing_event: IMPRESSIONS`;
  - `targeting` come stringa JSON (per esempio `{"geo_locations":{"countries":["IT"]}}`), con Advantage+ Audience attivo come da default;
  - **mai inventare ID di interessi**;
  - per le vendite sul sito, `promoted_object` con `pixel_id` e `custom_event_type` (per esempio `PURCHASE`);
  - sotto una campagna CBO non si mette budget sul gruppo;
  - budget minimo: `min_daily_budget_cents` da `ads_get_ad_accounts`;
  - per l'UE i campi DSA (`dsa_beneficiary`, `dsa_payor`) si compilano in automatico con il nome del business dell'account; se l'account non appartiene a un business, chiedili al cliente e passali;
  - **posizionamenti**: automatici se non si invia nulla. Per restringerli, `publisher_platforms` e le relative posizioni vanno dentro `targeting` (per esempio `"publisher_platforms":["instagram"],"instagram_positions":["reels"]`). Non dire al cliente che le posizioni sono state scelte se quei campi non sono stati inviati;
  - **zona a cerchio**: dentro `targeting`, `geo_locations.custom_locations` con `latitude`, `longitude`, `radius` e `distance_unit: "kilometer"`, al posto di `countries`. Un cerchio può sconfinare in un altro stato: dillo al cliente;
  - **esclusioni**: `excluded_custom_audiences` dentro `targeting`, come oggetti con `id`;
  - **visite al profilo Instagram**: `OUTCOME_TRAFFIC` con `optimization_goal: VISIT_INSTAGRAM_PROFILE` e `destination_type: INSTAGRAM_PROFILE`. Con `PROFILE_VISIT` o `PROFILE_AND_PAGE_ENGAGEMENT` serve anche `promoted_object` con il `page_id`. Altre combinazioni per la notorietà in `.claude/skills/notorieta/references/campagne.md`.
- **`ads_create_ad`**: `ad_account_id`, `ad_set_id`, `ad_name`, `creative` come stringa JSON `{"creative_id":"<id>"}`. Nasce in pausa.

## Promuovere un post Instagram: `ads_boost_ig_post`

- Crea campagna, gruppo e inserzione per **un** post, in pausa. Due passaggi: prima `confirmed: false` (restituisce il piano), poi `confirmed: true` con gli stessi parametri, solo dopo il sì.
- **Valori riempiti da soli se mancano**: paese Stati Uniti, circa 5 dollari al giorno, 6 giorni, obiettivo traffico verso il profilo, nomi "Instagram post: …". Vanno sempre passati esplicitamente: `targeting`, budget, `duration_days`, obiettivo e i tre nomi con `[ETICHETTA]`.
- `ig_media_id` è l'`id` di `ads_get_ig_media`, così com'è.
- In sola lettura anche `confirmed: false` viene bloccato dal controllo di sicurezza: il piano si scrive a mano.
- Per più post nella stessa campagna non si usa questo tool: si creano creatività con `source_instagram_media_id` (vedi `.claude/skills/notorieta/references/campagne.md`).

## Modifiche: `ads_update_entity`

- `entity_type`: `campaign`, `ad_set`, `ad`.
- `fields` usa i nomi delle API, **non** quelli dei tool di creazione: `name`, `daily_budget`, `lifetime_budget`, `bid_strategy`, `status`.
- Pausa: solo `{"status":"PAUSED"}`. Dopo una pausa **non** chiamare `ads_activate_entity`.
- **Vietati** in questo progetto: `DELETED` e `ARCHIVED` (bloccati da un hook).
- Non si può cambiare la creatività di un'inserzione: `creative` e `creative_id` non sono accettati.
- Se cambi `targeting` lo sostituisci tutto: riporta `targeting_automation` com'era.

## Attivazione: `ads_activate_entity`

- **Solo dopo un sì esplicito**: fa partire la spesa.
- **Entità normali.** Si attiva ogni livello, dall'alto in basso: campagna, gruppo, inserzione. Un figlio attivo sotto un padre in pausa non consegna.
- **Modalità bozza.**
  - Gli oggetti creati sono in bozza in Ads Manager.
  - Si pubblicano passando in `object_ids` gli ID esatti, letti con `ads_get_ad_entities` e `object_state: draft`.
  - `publish_as_active: true` solo se il cliente ha chiesto di attivare.
  - Quello che si pubblica va attivo subito: in modalità bozza il sì alla pubblicazione è il sì alla spesa, e il cliente va avvisato prima di chiederlo.
- `PUBLISHING` = consegnato al sistema di pubblicazione, **non** attivo. Rileggi e conferma solo quello che risulta.

## A/B test: `ads_experiment_abtest_create_test`

- `cells`: almeno 2, ognuna con **un solo** ID (tutti dello stesso livello e dello stesso account).
- Date `AAAA-MM-GG`. L'inizio è al più presto domani; la durata predefinita è 7 giorni.
- `primary_kpi` nel formato `cost_per_action_type:<azione>`, per esempio `cost_per_action_type:lead`. Il predefinito è `cost_per_result`.

## Errori tipici

| Errore | Cosa fare |
|---|---|
| Errore di rete (socket) | Riprova una volta |
| Errore interno su una creazione | Controlla se l'oggetto esiste già, poi riprova al massimo una volta; altrimenti fermati |
| Errore di validazione con elenco dei campi supportati | L'elenco della risposta vale più di qualsiasi altra fonte: correggi e riprova |
| "Performance goal isn't available" | Obiettivo di ottimizzazione non compatibile con obiettivo di campagna, destinazione o `promoted_object` |
| "Facebook Page is Missing" | Manca `page_id` |
| Video senza copertina | Aggiungi `image_hash` o `image_url` |
| Budget sotto il minimo | Leggi `min_daily_budget_cents` |
| Inserzione "In revisione" | Normale, da pochi minuti fino a 24 ore |
| Account senza permessi o non abilitato | Il cliente controlla i permessi dell'integrazione in Impostazioni del Business > Integrazioni aziendali |
| Account limitato o "vietato fare pubblicità" | Richiesta di revisione da Account Quality. **Mai** creare un business manager parallelo per aggirarlo |

## Anteprime: `ads_get_ad_preview`

Restituisce link lunghi migliaia di caratteri, scomodi da mostrare in chat. Per far vedere un'inserzione al cliente conviene indicargli dove trovarla in Gestione inserzioni (tra le bozze, se l'account è in modalità bozza). Il link si incolla solo se lo chiede.
