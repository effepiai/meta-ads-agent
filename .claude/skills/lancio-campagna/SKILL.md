---
name: lancio-campagna
description: Crea una nuova campagna Meta Ads da zero (campagna, gruppo di inserzioni e inserzioni), tutto in pausa o in bozza, con due conferme, prima di creare e prima di attivare. Include la campagna di test per le creatività. Usala col comando /lancio-campagna, o quando il cliente chiede "crea una campagna", "lanciamo una nuova campagna", "serve una campagna di test", "nuova promozione".
---

# Lancio di una campagna

Prima leggi:
- `<profilo>/cliente/config.yaml`: fase, budget, `blocco_lanci`, categoria speciale e le schede `prodotti`;
- `.claude/skills/briefing/references/prodotti.md`;
- `.claude/skills/pubblica/references/contratti-tool.md`.

In sola lettura o durante un blocco lanci, prepara solo il piano.

**Se l'obiettivo è farsi conoscere** (copertura, visualizzazioni dei video, follower, promuovere post o reel già pubblicati), usa la skill `notorieta`: ha la sua scheda, i suoi tipi di campagna e un metro di giudizio che non passa dal CPA. Questa skill resta per vendite, contatti, messaggi e traffico verso un sito.

*Regole adattate da markifact-mcp `launch-meta-campaign` (Markifact, MIT) e meta-ads-skill `launch-playbook.md` (Beka Zakaidze, MIT).*

## 1. Il brief (domande, se mancano dal config)

- **Prodotto.** Per quale prodotto o servizio è la campagna?
  - **Ha già una scheda**: mostrala in 3-5 righe con la data di `aggiornato_il` e chiedi se i numeri valgono ancora. Non rifare le domande. Se è più vecchia di `regole.scheda_prodotto_valida_giorni`, chiedi espressamente di prezzi, margini, offerta e stagione.
  - **Non ha una scheda**: fai solo le domande della scheda, calcola pareggio e obiettivo come in `prodotti.md`, falli confermare e salva la scheda prima di proseguire.
- **Obiettivo.** Vendite, contatti, messaggi, traffico o notorietà. **Si sceglie una volta: non si cambia dopo.**
- **Cosa promuoviamo**: prodotto o offerta, pagina di destinazione, scadenza.
- **Budget**: giornaliero o totale, con le date. Non dedurlo da un importo mensile: chiedi.
- **Paesi o zona.**
- **Dove esce.** Posizionamenti automatici (predefinito) oppure solo alcune piattaforme, per esempio solo Instagram. Se il cliente non lo dice, non restringere.
- **Creatività**: pronte in `<profilo>/creativita/`, oppure da preparare prima con `/creativita`.

## 2. Il piano (prima conferma)

Struttura predefinita:
- **1 campagna** con budget sulla campagna (CBO, cioè Meta distribuisce il budget);
- **1 gruppo di inserzioni** con pubblico ampio (Advantage+ Audience, solo paese o zona) e posizionamenti automatici;
- **un'inserzione per ogni creatività**: Meta sposta da solo la spesa sulla migliore. È il test più economico.

Regole:
- **Al massimo 2-4 gruppi** per campagna. Più gruppi dividono i dati e rallentano il learning.
- **Nome con l'etichetta**: campagna, gruppi e inserzioni iniziano con `[ETICHETTA]` del prodotto, per esempio `[CORSI] Contatti Lombardia`. Così briefing e revisione la giudicano con l'obiettivo giusto.
- **Budget sufficiente per il learning** (non vale per le schede di notorietà, che non hanno un CPA): circa CPA target del prodotto × 50 ÷ 7 al giorno per gruppo. Se il budget è più basso, dillo chiaramente: il gruppo resterà in "learning limitato". Proponi un evento di ottimizzazione più frequente (per esempio aggiunta al carrello invece di acquisto) o un budget più alto.
- **Vendite sul sito**: serve `promoted_object` con pixel ed evento (per esempio PURCHASE). Senza, nessun obiettivo di ottimizzazione è valido.
- **Mai inventare ID di interessi.** Pubblico ampio, oppure interessi forniti dal cliente con ID reali.
- **Solo Instagram, o altre restrizioni di posizionamento**: `publisher_platforms` e le relative posizioni vanno dentro `targeting` (esempio e posizioni accettate in `.claude/skills/notorieta/references/campagne.md`). Dopo la creazione rileggi `targeting` e conferma al cliente solo quello che risulta.
- **Categoria speciale**: va dichiarata nella campagna. Comporta niente età e sesso, e raggio minimo di 25 km.
- **Campagna di test per le creatività**: una campagna CBO con circa `budget.quota_test_pct` del budget, un gruppo ampio, dove `/pubblica` metterà le creatività nuove. Dopo la creazione salva gli ID in `meta.campagna_test_id` e `meta.ad_set_test_id`.

Mostra il piano in una tabella: nomi, obiettivo, budget in euro, ottimizzazione, pubblico, posizionamenti, inserzioni, link con UTM. Chiedi il sì per **creare in pausa**.

## 3. Creazione (in pausa o in bozza)

1. Verifica l'account con `ads_get_ad_accounts`: abilitato, metodo di pagamento, `min_daily_budget_cents`.
2. `ads_create_campaign`: obiettivo ODAX, `buying_type: AUCTION`, budget in centesimi sulla campagna, categorie speciali.
3. `ads_create_ad_set`:
   - `optimization_goal` scelto tra i `valid_optimization_goals` restituiti dalla campagna;
   - `billing_event: IMPRESSIONS`;
   - `targeting` in JSON, `promoted_object`;
   - nessun budget sul gruppo sotto CBO.
4. Creatività e inserzioni come nella skill `pubblica`, passi 3 e 4.
5. Rileggi tutto con `ads_get_ad_entities`. Nella modalità bozza usa `object_state: draft`. Mostra le anteprime con `ads_get_ad_preview`.

Se il connettore risponde con `status=DRAFT`, l'account è in modalità bozza: annota `meta.modalita_bozza: si`. Tutto è visibile in Ads Manager, nelle bozze.

## 4. Attivazione (seconda conferma)

Riepilogo: cosa parte, quanto spende al giorno, da quando. Chiedi il sì esplicito.

- **Account normale.** `ads_activate_entity` dall'alto in basso: campagna, gruppo, ogni inserzione.
- **Modalità bozza.** Un'unica `ads_activate_entity` con `object_ids` (campagna, gruppi e inserzioni letti dalla bozza) e `publish_as_active: true`.
- `PUBLISHING` non significa attivo: rileggi e conferma solo quello che risulta.

## 5. Registra

In `<profilo>/registro/decisioni.md`: il lancio, con il prodotto e la sua etichetta, verifica al giorno 7 (controllo della consegna) e al giorno 14 (primo giudizio). Aggiungi l'ID della campagna alla lista `campagne` della scheda del prodotto.
