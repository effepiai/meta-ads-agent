---
name: pubblica
description: Pubblica su Meta Ads le creatività approvate. Carica immagini e video, crea creatività e inserzioni in pausa (o in bozza), mostra l'anteprima e attiva solo dopo un sì esplicito. Facoltativamente lancia un A/B test, poi mette in pausa le inserzioni sostituite. Usala col comando /pubblica, o quando il cliente dice "pubblica", "carica le varianti", "metti online", dopo che /creativita ha preparato una cartella approvata.
---

# Pubblicazione

Prima leggi:
- `<profilo>/cliente/config.yaml`: fase, `meta`, `creativita.caricamento_media`, `blocco_lanci`;
- la cartella della creatività: `<profilo>/creativita/<data>-<nome>/testi.md` e i file;
- `references/contratti-tool.md`: parametri esatti ed errori tipici.

Se `fase: sola_lettura` o `blocco_lanci: true`, non pubblicare. Spiega il motivo e lascia la cartella pronta.

**Due conferme separate**: una per **creare** (in pausa), una per **attivare**.

## 1. Controlli prima di partire

- **Account.** `ads_get_ad_accounts`: l'account dev'essere abilitato al connettore (`is_ads_mcp_enabled`), avere un metodo di pagamento ed essere ACTIVE.
- **Pagina e Instagram.** Pagina Facebook e ID Instagram presi dal config. Senza `instagram_user_id` la creatività **esclude Instagram**.
- **Dove va l'inserzione.** Predefinito: `meta.ad_set_test_id`.
  - Se non c'è, chiedi al cliente in quale gruppo di inserzioni metterla, oppure proponi `/lancio-campagna` per creare una campagna di test.
  - Non mettere creatività da testare nella campagna che sta funzionando, se esiste una campagna di test.
- **Testi.** Ogni variante ha link con `utm_content`, CTA ed etichetta AI decisa.

## 2. Mostra il piano e chiedi il primo sì

Tabella con, per ogni inserzione da creare:
- nome inserzione: `[ETICHETTA]_<cartella>_<idea>_<formato>`, con l'etichetta del prodotto (vedi `.claude/skills/briefing/references/prodotti.md`);
- gruppo di destinazione;
- file;
- testi;
- CTA e link;
- etichetta AI.

Specifica che **tutto verrà creato in pausa** (o in bozza) e che non partirà nessuna spesa. Chiedi il sì per creare.

## 3. Carica i media

Secondo `creativita.caricamento_media`:

- **`manuale`** (predefinito):
  1. chiedi al cliente di caricare i file della cartella nella libreria multimediale di Ads Manager, con lo stesso nome dei file;
  2. quando dice fatto, trovali con `ads_get_ad_images` e `ads_get_ad_videos`;
  3. annota hash e ID in `testi.md`.
- **`sito_cliente` o `supabase`**:
  1. ottieni l'URL pubblico diretto. Con `supabase` lancia `./scripts/carica-media-supabase.sh <file>`, che restituisce l'URL;
  2. poi `ads_creative_upload_media` con `upload_source: URL`, `media_type` IMAGE o VIDEO e `media_url`.

  I link di Drive, Dropbox e Canva non funzionano.
- **Link pubblico del generatore**: se è diretto al file, si può usare come sopra.

**Video**: l'elaborazione è asincrona. Controlla con `ads_get_ad_videos` finché lo stato è `ready` prima di creare la creatività. Ogni video ha bisogno di un'immagine di copertina: un fotogramma esportato con `estrai-fotogrammi.sh`, caricato come immagine.

## 4. Crea creatività e inserzioni (in pausa)

Per ogni variante:

1. **Creatività** con `ads_create_creative`:
   - **Più alternative di testo**: formato multi-media (`multi_media` con 2-10 file, più `primary_texts`, `headlines`, `descriptions` fino a 5).
   - **Una sola immagine o un solo video**: formato singolo.
   - Usa sempre `page_id`, `instagram_user_id`, `link_url` (con UTM), `call_to_action_type`, `self_ai_disclosure` e un `name` chiaro.
   - Non attivare le ottimizzazioni automatiche Advantage+ Creative se il cliente non l'ha chiesto.
2. **Inserzione** con `ads_create_ad`: `ad_set_id`, `ad_name`, `creative: {"creative_id":"<id>"}`. Nasce in pausa, oppure in bozza se l'account è in modalità bozza.
3. **Anteprima** con `ads_get_ad_preview`: mostra il link o l'anteprima al cliente.

Al massimo `modifiche_max_per_conferma` creazioni per ogni conferma. Se sono di più, dividi in lotti.

Se un errore interno interrompe una creazione:
1. controlla con `ads_get_ad_entities` se l'oggetto esiste già;
2. riprova una volta sola;
3. poi fermati.

## 5. Secondo sì: attivare

Riepilogo:
- inserzioni create, con ID e anteprime;
- gruppo e budget che le ospita;
- cosa succede alla spesa: le nuove inserzioni dividono il budget del gruppo, non lo aumentano;
- quali inserzioni stanche verranno messe in pausa **dopo**.

Chiedi un sì che nomini le inserzioni. Poi:

- **Account normale.** `ads_activate_entity` per ogni inserzione (`entity_type: ad`). Campagna e gruppo devono essere già attivi, altrimenti dillo: attivarli è un'altra decisione.
- **Modalità bozza.**
  1. Trova gli ID con `ads_get_ad_entities` e `object_state: draft`.
  2. Pubblica con `ads_activate_entity`, passando in `object_ids` solo le inserzioni nuove.
  3. Imposta `publish_as_active: true`, perché il cliente ha chiesto di attivarle.
- **Risposta `PUBLISHING`.** Significa "consegnato a Meta", non "attivo". Rileggi con `ads_get_ad_entities` e conferma solo quello che risulta attivo. Le inserzioni in revisione possono richiedere fino a 24 ore.

## 6. Test A/B (facoltativo)

Se il cliente vuole un test formale invece della distribuzione automatica di Meta:
- controlla l'idoneità con `ads_experiment_check_eligibility`;
- crea il test con `ads_experiment_abtest_create_test`: una cella per inserzione o gruppo, KPI principale coerente con l'obiettivo (per esempio `cost_per_action_type:omni_purchase`);
- inizio al più presto domani, durata predefinita 7 giorni.

Serve un sì dedicato.

## 7. Sostituire le stanche

Solo quando le nuove inserzioni risultano **attive** (non in revisione), proponi di mettere in pausa le inserzioni stanche indicate da `/creativita`. Si fa con `ads_update_entity` `{"status":"PAUSED"}`, con il loro sì.

## 8. Registra

- In `<profilo>/registro/creativita.md`: ID delle inserzioni, stato "attiva" o "in pausa" ed esito "in test".
- In `<profilo>/registro/decisioni.md`: la pubblicazione, con data di verifica = oggi + 7 giorni.
