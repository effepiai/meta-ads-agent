# Notorietà: i tre tipi di campagna e i parametri

Verificato sugli schemi del connettore ufficiale il 2026-11-19. **La descrizione del tool nel connettore resta la fonte di verità**: se qualcosa qui non torna, vale lo schema live. Le regole generali (centesimi, stringhe JSON, modalità bozza) sono in `.claude/skills/pubblica/references/contratti-tool.md`.

**Cosa è stato provato davvero.** La strada delle visite al profilo (terza riga della tabella, bacino con tre reel, zona a cerchio, account in modalità bozza) è stata creata e pubblicata su un account reale il 2026-11-20: dove una regola qui sotto dice "provato", viene da lì. Le altre combinazioni sono verificate solo sugli schemi.

**Quello che scopri sull'account del cliente non va scritto in questo file**, che è uguale per tutti i profili: va in `<profilo>/registro/lezioni.md`, con la data. In questo file entrano solo regole del connettore valide per chiunque, senza nomi, ID, luoghi o numeri di un account.

## I nomi di Gestione inserzioni

Il cliente ragiona con i nomi che vede in Gestione inserzioni; questa skill parla per risultati. La corrispondenza:

| Il cliente dice | In Gestione inserzioni | Qui | Risultato della scheda |
|---|---|---|---|
| "Più follower", "visite al profilo", "traffico verso il profilo" | Obiettivo **Traffico**, destinazione profilo Instagram | Visite al profilo (tipo 3) | `follower` o `visita_profilo` |
| "Copertura", "farmi vedere da più persone possibile" | Obiettivo **Notorietà**, obiettivo di rendimento copertura | Bacino ottimizzato per la copertura | `persona_raggiunta` |
| "Visualizzazioni", "far guardare i reel" | Obiettivo **Interazioni**, con le visualizzazioni del video | Bacino di reel (tipo 2) | `visualizzazione_completa` |
| "Spingi questo post", "metti in evidenza" | Il pulsante "Metti in evidenza" di Instagram | Spingi un reel (tipo 1) | quello della scheda |

- **La copertura non è più un obiettivo a sé**: oggi sta dentro Notorietà, come obiettivo di rendimento. Se il cliente cerca "Copertura" tra gli obiettivi e non la trova, spiegaglielo.
- **Interazioni** copre due cose diverse: le visualizzazioni del video (quella che serve a un bacino di reel) e le interazioni con il post (like, commenti). Chiedi quale intende.
- Nel piano scrivi sempre **tutti e due i nomi**: quello di Gestione inserzioni e il risultato, per esempio "Traffico verso il profilo Instagram (visite al profilo)". Così il cliente ritrova la campagna quando apre Gestione inserzioni.
- Rileggendo una campagna Traffico, il campo dell'obiettivo può tornare come `LINK_CLICKS`: è il nome vecchio di Traffico, non un errore (provato).

## Obiettivo e ottimizzazione, secondo il risultato principale

| Risultato della scheda | Obiettivo della campagna | Destinazione | Ottimizzazione | Note |
|---|---|---|---|---|
| `visualizzazione_completa` | `OUTCOME_ENGAGEMENT` | `ON_VIDEO` | `THRUPLAY` | Meta cerca chi guarda i video. È la scelta predefinita di un bacino di reel. La destinazione è obbligatoria: senza, l'ottimizzazione viene rifiutata. Lo schema cita questa coppia insieme a un `promoted_object`: se la creazione lo chiede, è `{"page_id":"<pagina>"}` (**da verificare**) |
| `persona_raggiunta` | `OUTCOME_AWARENESS` | nessuna | `REACH` | Meta cerca le persone più economiche da raggiungere, non quelle che guardano: va detto al cliente. Sotto questo obiettivo è valida anche `THRUPLAY`, senza destinazione: è il ripiego se la riga sopra viene rifiutata |
| `visita_profilo` e `follower` | `OUTCOME_TRAFFIC` | `INSTAGRAM_PROFILE` | `VISIT_INSTAGRAM_PROFILE` | Non serve un `promoted_object` (provato: gruppo accettato senza, nessun errore di validazione) |

- **Non esiste un'ottimizzazione per follower.** Per i follower si ottimizza per le visite al profilo e si misura `instagram_profile_follow_v2`. Che questa strada porti follower a un costo migliore del bacino di visualizzazioni è un'**ipotesi da verificare sull'account**, confrontando il costo per follower delle due campagne.
- `optimization_goal` si sceglie solo tra i `valid_optimization_goals` restituiti da `ads_create_campaign`. Se la combinazione della tabella non è tra quelli, usa quella raccomandata dalla risposta e dillo al cliente.
- Lo schema cita anche `PROFILE_VISIT` (con `OUTCOME_TRAFFIC`) e `PROFILE_AND_PAGE_ENGAGEMENT` (con `OUTCOME_ENGAGEMENT`) per le visite al profilo. Per queste due il `promoted_object` con il `page_id` è **obbligatorio**, anche se si esce solo su Instagram, e il `page_id` delle creatività dev'essere lo stesso. `VISIT_INSTAGRAM_PROFILE` è l'unica presente sia tra quelle che si possono creare sia tra quelle che si possono rileggere: parti da quella.
- L'errore "Performance goal isn't available" significa che obiettivo, destinazione e ottimizzazione non vanno insieme: rileggi la descrizione di `ads_create_ad_set`.

## Solo Instagram

Le posizioni vanno **dentro `targeting`**, come stringa JSON:

```
{"geo_locations":{"countries":["IT"]},"publisher_platforms":["instagram"],"instagram_positions":["reels","stream","story","explore"]}
```

- Posizioni di Instagram accettate dal connettore: `stream` (feed), `story`, `reels`, `explore`, `explore_home`, `profile_feed`, `profile_reels`, `ig_search`, `reels_overlay`, `shop`.
- Solo `publisher_platforms: ["instagram"]`, senza `instagram_positions`: tutte le posizioni di Instagram.
- Se si omettono tutti e due, Meta usa i posizionamenti automatici, **Facebook compreso**. Non dire mai al cliente "solo Instagram" se quei campi non sono stati inviati.
- Dopo la creazione rileggi il campo `targeting` del gruppo e controlla che `publisher_platforms` sia quello richiesto.

## Zona locale: il cerchio

Chi lavora in una città o in una provincia non vuole tutto il paese. Al posto di `countries` si usa un cerchio: un punto e un raggio.

```
{"geo_locations":{"custom_locations":[{"latitude":41.9028,"longitude":12.4964,"radius":40,"distance_unit":"kilometer"}]},"publisher_platforms":["instagram"]}
```

(Nell'esempio il centro di Roma con 40 km: sono valori di esempio, da sostituire.) Formato provato sul connettore. Regole:

- **Centro e raggio li dice il cliente.** Chiedi la città o l'indirizzo e fin dove vuole arrivare; proponi tu le coordinate e falle confermare nominando due o tre località che il cerchio comprende e una che resta fuori. Non dedurre la zona dalla sede dell'azienda.
- **Un cerchio non segue i confini.** Vicino a un confine può comprendere un pezzo di un altro stato o di un'altra regione, e altra lingua: dillo al cliente prima del sì e, se non lo vuole, riduci il raggio o sposta il centro.
- **Scrivi la zona nella scheda**: a parole in `zona` e con i numeri in `notorieta.zona_cerchio`. Sono i valori con cui si controlla, a ogni rilettura, che il gruppo esca dove deve.
- **Il pubblico è ristretto.** Metti `pubblico_dimensione: ristretto` nella scheda e spiegalo al cliente: in una zona piccola le stesse persone vedono i contenuti più volte, quindi una frequenza più alta è normale e da sola non è un problema. Il segnale da guardare sono le persone raggiunte che smettono di crescere (vedi `giudizio.md`, "La stanchezza di un bacino").
- **Categoria speciale** (lavoro, casa, servizi finanziari): Meta impone un raggio minimo di 25 km.
- Il connettore può aggiungere da solo `targeting_automation.advantage_audience: 1` (provato): significa che Meta può allargare il pubblico per età e interessi, non la zona. Dopo la creazione rileggi `targeting` e conferma al cliente centro, raggio e piattaforme come risultano.

## Il pubblico

- Predefinito: pubblico ampio, solo paese o zona, con Advantage+ Audience lasciato com'è (non inviare `targeting_automation`).
- **Mai inventare ID di interessi.**
- Un limite di età si mette solo se il cliente l'ha detto in questa conversazione.
- **Esclusioni**: gli ID in `notorieta.pubblici_esclusi` vanno in `targeting.excluded_custom_audiences`, come oggetti con `id`. Restano un vincolo rigido anche con Advantage+ Audience. Prima controlla con `ads_get_ad_account_custom_audiences` che esistano ancora.
- **Unione Europea: chi paga e chi beneficia.** `dsa_beneficiary` e `dsa_payor` sono obbligatori e compaiono accanto all'inserzione. Il connettore li compila con il nome del business dell'account. **Se l'account non appartiene a un business** (un account personale, senza Business Manager) non li compila nessuno: chiedi al cliente i due nomi nel piano, prima del sì, e passali a mano sul gruppo (provato). Di solito sono la stessa persona o azienda. Non inventarli e non ricavarli dal nome del profilo.

## Tipo 1 — Spingi un reel (`ads_boost_ig_post`)

Crea campagna, gruppo e inserzione per **un solo** post. Va bene per pochi giorni su un contenuto forte. Ogni reel spinto così è una campagna a sé.

Come si usa:
1. `ig_media_id` è l'`id` restituito da `ads_get_ig_media`, così com'è. Non ricavarlo dal link del post.
2. Prima chiamata con `confirmed: false`: restituisce il piano con tutti i valori, anche quelli riempiti da soli.
3. Mostra il piano al cliente. Seconda chiamata con `confirmed: true` solo dopo il sì, con **gli stessi identici parametri**.

**I valori che il tool riempie da solo, e che vanno sempre passati esplicitamente:**

| Valore | Se manca | Cosa passare |
|---|---|---|
| Paese | Stati Uniti | `targeting` con il paese della scheda |
| Posizioni | Automatiche | `publisher_platforms` e, se servono, `instagram_positions` dentro `targeting` |
| Budget | Circa 5 dollari al giorno | `daily_budget` in centesimi, oppure `lifetime_budget` con `end_time` |
| Durata | 6 giorni | `duration_days` (da 1 a 365) |
| Nomi | "Instagram post: <testo>" | `campaign_name`, `ad_set_name`, `ad_name` con `[ETICHETTA]` davanti: senza, la campagna non si collega alla scheda |
| Obiettivo | Traffico verso il profilo | Quello della tabella sopra |

Combinazioni indicate dal tool:
- visite al profilo: `OUTCOME_TRAFFIC` + `INSTAGRAM_PROFILE` + `VISIT_INSTAGRAM_PROFILE`;
- copertura: `OUTCOME_AWARENESS` + `UNDEFINED` + `REACH`;
- visualizzazioni video: `OUTCOME_ENGAGEMENT` + `ON_VIDEO` + `THRUPLAY`;
- interazioni con il post: `OUTCOME_ENGAGEMENT` + `ON_POST` + `POST_ENGAGEMENT`.

Il pulsante: senza `call_to_action_type` l'inserzione porta al profilo Instagram (`VIEW_INSTAGRAM_PROFILE`). Per un sito serve `call_to_action_value.link`.

Attenzioni:
- **In sola lettura il piano si scrive a mano.** Il controllo di sicurezza tratta `ads_boost_ig_post` come una scrittura anche con `confirmed: false`: la chiamata verrebbe bloccata.
- Per lo stesso motivo, fuori dalla sola lettura la richiesta del piano finisce in `<profilo>/registro/azioni-meta.jsonl` anche se non crea nulla. È normale.
- Nel piano restituito controlla soprattutto paese, posizioni, budget e valuta. Se `targeting` non accetta le posizioni, dillo al cliente e proponi il bacino (tipo 2), dove le posizioni si controllano sul gruppo.
- La durata minima è 24 ore.

## Tipo 2 — Bacino di contenuti

Una campagna, un gruppo, un'inserzione per contenuto. I contenuti nuovi si aggiungono allo stesso gruppo.

1. **Account**: `ads_get_ad_accounts` (attivo, metodo di pagamento, `min_daily_budget_cents`).
2. **Campagna**: `ads_create_campaign` con l'obiettivo della tabella, `buying_type: AUCTION`, budget sulla campagna in centesimi (`campaign_daily_budget` solo se il cliente ha detto un importo al giorno, `campaign_lifetime_budget` solo se ha detto un totale), `special_ad_categories: "[]"`, nome `[ETICHETTA] Bacino <cosa>`.
3. **Gruppo**: `ads_create_ad_set` con l'ottimizzazione e la destinazione della tabella, `billing_event: IMPRESSIONS`, `targeting` con paese, posizioni ed esclusioni, nessun budget sul gruppo. Se la campagna ha un budget totale serve `end_time`.
4. **Una creatività per contenuto**: `ads_create_creative` con
   - `page_id`: la pagina Facebook abbinata all'account Instagram;
   - `instagram_user_id`: l'account Instagram che possiede il post;
   - `source_instagram_media_id`: l'`id` del post da `ads_get_ig_media`;
   - `name`: `[ETICHETTA]_<data del post>_<titolo breve>`.

   **Nient'altro**: né testi, né immagini, né video, né titoli. Il post si usa così com'è. Un pulsante è facoltativo: `link_url` più `call_to_action_type`; senza link non c'è pulsante.
5. **Un'inserzione per creatività**: `ads_create_ad` con `ad_set_id`, `ad_name` uguale al nome della creatività e `creative: {"creative_id":"<id>"}`. Rileggendo, i miglioramenti automatici di Meta risultano spenti (provato): il contenuto esce com'è.
6. Rileggi tutto. **Anteprime**: `ads_get_ad_preview` restituisce link lunghi migliaia di caratteri, inutilizzabili in chat. Di' al cliente dove guardarle: in Gestione inserzioni, sulla campagna (nelle bozze, se l'account è in modalità bozza), aprendo l'inserzione. Incolla un link di anteprima solo se lo chiede.

Attenzioni:
- Si passa **il post originale**. Un ID preso da un'inserzione esistente, o da una copia già sponsorizzata, viene rifiutato.
- **Dichiarazione dei contenuti fatti con l'AI** (`self_ai_disclosure`): si chiede **nel piano, per ogni contenuto**, non a metà creazione. La decide il cliente, vale per quel contenuto e **dopo la creazione non si cambia**. Senza la sua risposta le creatività non si creano. Con `creativita.dichiarazione_ai: sempre` o `mai` nel config si applica quella scelta, dicendolo nel piano. Sulla creatività dichiarata la scelta si rilegge in `generative_asset_spec` (provato).
- **Quanti contenuti**: da `reel_attivi_min` a `reel_attivi_max`. Troppi contenuti con poco budget restano tutti "poco testati". Al giorno 7 un contenuto che ha speso meno di `consegna_giorno_7_min_quota` della sua quota non sta ricevendo spesa.
- **Budget piccoli** (pochi euro al giorno): parti dal minimo dei contenuti, `reel_attivi_min`. Ogni contenuto in più divide una spesa già piccola. Dillo nel piano, insieme al fatto che con poca spesa la misura può durare più di `giorni_misura`: finché i contenuti non arrivano a `impression_min_per_reel` non c'è un riferimento. Controlla anche `min_daily_budget_cents`: sotto quel valore la campagna non si crea.
- **Quante scritture servono, e in quanti lotti.** Un bacino con N contenuti chiede 2 + 2 × N scritture: campagna, gruppo, N creatività, N inserzioni. Con tre contenuti sono 8, e `budget.modifiche_max_per_conferma` è 5 di serie. Il piano lo dice **prima**: "servono 8 creazioni, in due conferme: prima campagna, gruppo e le creatività, poi le inserzioni". Non fermarti a metà senza averlo annunciato.
- **Aggiungere un contenuto** a un gruppo attivo fa ripartire il learning: va scritto nel rischio della mossa. Per questo si aggiungono a gruppi, non uno al giorno.
- **Budget e learning**: gli eventi di ottimizzazione (visualizzazioni complete, persone raggiunte) costano poco, quindi il gruppo esce dal learning anche con budget piccoli. Con le visite al profilo vale la regola solita: circa 50 risultati per gruppo in 7 giorni. La formula con il CPA non si applica: al suo posto usa `costo_riferimento`, quando c'è.

## Tipo 3 — Visite al profilo

Uguale al bacino, con la terza riga della tabella. In più:
- obiettivo diverso dal bacino di visualizzazioni, quindi **campagna separata e scheda separata** (una scheda per bacino: vedi `giudizio.md`). I due bacini possono usare gli stessi contenuti;
- se si usa `PROFILE_VISIT` o `PROFILE_AND_PAGE_ENGAGEMENT` al posto di `VISIT_INSTAGRAM_PROFILE`: `promoted_object: {"page_id":"<pagina>"}` sul gruppo, e lo stesso `page_id` nelle creatività. Leggilo dal gruppo con `ads_get_ad_entities` prima di crearle.

## Modalità bozza

Su alcuni account gli oggetti non nascono "in pausa" ma **in bozza**: le creazioni rispondono `status=DRAFT`. Non si sceglie: dipende dall'account, e lo si scopre alla prima creazione (`meta.modalita_bozza` nel config). Per il cliente cambia una cosa importante, da dire **prima del sì alla creazione** e di nuovo prima di quello alla pubblicazione:

- niente è online e niente spende finché non si pubblica;
- **pubblicare vuol dire attivare.** Non esiste il passaggio intermedio "online ma in pausa": il sì alla pubblicazione è il sì alla spesa. Chiedilo con il riepilogo di cosa parte, quanto spende al giorno e fino a quando;
- le bozze il cliente le vede in Gestione inserzioni, tra le bozze da rivedere e pubblicare.

Come si lavora:
- **Rilettura.** `ads_get_ad_entities` con `object_state: draft`. Con l'ID della campagna torna **solo la campagna**: gruppo e inserzioni si rileggono ognuno col suo ID (provato). Tieni gli ID da ogni risposta di creazione;
- dopo ogni creazione controlla `active_errors` e correggi gli errori bloccanti con `ads_update_entity` prima di pubblicare;
- **Pubblicazione.** Una sola `ads_activate_entity` sulla campagna, con in `object_ids` **tutti** gli oggetti (campagna, gruppo, ogni inserzione) e `publish_as_active: true`. Risponde `PUBLISHING` (provato);
- **Dopo.** Rileggi dal vivo, senza `object_state`: campagna `ACTIVE`, inserzioni `ACTIVE` con `effective_status: IN_PROCESS` finché Meta le elabora e le rivede (provato). Di' al cliente che la consegna parte dopo la revisione, di solito entro 24 ore, e metti nel registro un controllo per il giorno dopo;
- annota `meta.modalita_bozza: si` nel config.

Non ancora verificato, e da scrivere come tale al cliente: se sull'inserzione compare il pulsante verso il profilo quando non si passa un `call_to_action_type`.
