---
name: briefing
description: Briefing del mattino sull'account Meta Ads. Confronta ieri con gli ultimi 7 e 28 giorni, controlla spesa, consegna, costi, conversioni, fatica delle creatività e tracciamento, e assegna a ogni campagna una decisione (TENERE, SISTEMARE, TESTARE, APPROFONDIRE) in ordine di priorità. Solo lettura. Usala ogni mattina, col comando /briefing, o quando il cliente chiede "com'è andata ieri?", "cosa devo fare oggi?", "come vanno le campagne?".
---

# Briefing del mattino

Il briefing deve **finire con delle decisioni, non con un elenco di numeri**. Si legge in 2 minuti. **Solo lettura: non scrivere nulla su Meta.**

Prima di iniziare leggi:
- `<profilo>/cliente/config.yaml`, per le soglie e le schede `prodotti` con gli obiettivi di ogni prodotto;
- `<profilo>/cliente/campi-verificati.md`, se esiste;
- le voci di `<profilo>/registro/decisioni.md` con verifica scaduta o vicina;
- `references/lettura-dati.md`, con le regole per non farsi ingannare dai numeri;
- `references/prodotti.md`, per collegare ogni campagna al suo prodotto e al suo obiettivo;
- `.claude/skills/notorieta/references/giudizio.md`, se il profilo ha schede con `tipo: notorieta`.

## 1. Raccogli i dati

Per l'account del profilo (`meta.account_pubblicitari` in `<profilo>/cliente/config.yaml`):

1. **Account interrogabile.** Controlla con `ads_get_ad_accounts` che sia leggibile. Se `is_queryable` è false, riporta il motivo e fermati: senza dati non c'è briefing.
2. **Campi.** Verifica i campi con `ads_get_field_context` la prima volta e salvali in `<profilo>/cliente/campi-verificati.md`. Campi tipici: `amount_spent`, `impressions`, `reach`, `frequency`, `cpm`, `ctr`, `cpc`, `results`, `cost_per_result`, `purchase_roas` oppure `result_roas`, `effective_status`, `daily_budget`, `budget_remaining`, `learning_stage_info` (ad set), `delivery`.
3. **Campagne attive** (`ads_get_ad_entities`, `level: campaign`, solo effective_status ACTIVE), tre letture:
   - `date_preset: yesterday`;
   - `last_7d`;
   - `last_28d`, oppure un `time_range` che finisce 3 giorni fa per i giudizi sulle conversioni.
4. **Gruppi di inserzioni attivi**, ultimi 7 giorni: stato del learning, frequenza, consegna, budget.
5. **Inserzioni attive**, ultimi 7 giorni, ordinate per spesa decrescente: CTR, frequenza, costo per risultato, `creative_id`. Per i video aggiungi riproduzioni, primo quarto e visualizzazioni complete (`video_play_actions`, `video_p25_watched_actions`, `video_thruplay_watched_actions`). Le visualizzazioni da 3 secondi esistono solo per gruppo e campagna: l'hook rate si legge lì. Per le campagne di notorietà aggiungi `reach`, `cpp`, `post_save` e `instagram_profile_follow_v2`.
6. **Anomalie**: `ads_insights_anomaly_signal` sull'account.
7. **Modifiche degli ultimi 7 giorni**: `ads_account_get_activity_logs`. Ogni variazione va letta alla luce di cosa è stato cambiato.
8. **Problemi bloccanti**: inserzioni con stato rifiutato, con problemi o in revisione da oltre 24 ore.
9. Se una risposta contiene `next_actions` di sola lettura, eseguile prima di proseguire.

## 2. Analizza in quest'ordine e fermati alla prima causa vera

Prima collega ogni campagna attiva al suo prodotto, come spiega `references/prodotti.md`. Le campagne senza prodotto si analizzano solo ai punti 1, 2, 3, 5 e 7, senza giudizio sui costi.

Per ogni campagna, in ordine di spesa:

1. **Spesa e ritmo.**
   - Ieri ha speso come la media dei 7 giorni?
   - Il mese è in linea con `budget.massimo_mensile`? Il ritmo è la % di budget speso contro la % di mese trascorsa.
   - Una spesa sopra il 150% o sotto il 50% della media è un segnale da guardare.
2. **Consegna.**
   - Inserzioni rifiutate o in revisione.
   - Gruppi in "Learning limitato".
   - Spesa ferma: metodo di pagamento, budget esaurito, limite di spesa.
3. **Traffico.**
   - Il CPM (costo ogni 1000 impression) è salito?
   - CTR (percentuale di clic) e CPC (costo per clic) rispetto alla media.
4. **Conversioni.**
   - CPA o ROAS rispetto al target **del suo prodotto** (`cpa_target` o `roas_target` della scheda).
   - Applica le regole sul rumore: con poche conversioni non c'è giudizio.
   - Le conversioni di ieri sono incomplete: usale per il ritmo, non per giudicare.
   - **Campagne di notorietà** (scheda con `tipo: notorieta`): salta CPA e ROAS. Se la scheda non ha ancora `costo_riferimento`, scrivi "in misura, giorno <n> di `regole.notorieta.giorni_misura`". Altrimenti confronta il costo per il risultato principale con riferimento e target, e conta i contenuti attivi contro `reel_attivi_min`. Regole in `.claude/skills/notorieta/references/giudizio.md`.
5. **Fatica delle creatività** (regola completa in `references/lettura-dati.md`).
   - Stanca solo se, rispetto al periodo precedente, il CTR cala, il costo per risultato sale **e** la frequenza sale.
   - Frequenza sopra la soglia del prodotto ma risultati stabili: solo "da guardare", nessuna decisione.
   - Hook rate sotto `hook_rate_min_pct` (o la soglia del prodotto).
   - Per un bacino di notorietà la stanchezza è un'altra cosa: persone raggiunte ferme a spesa uguale, frequenza in salita, aggancio e tenuta in calo sugli stessi contenuti.
6. **Landing.** Se il CTR è buono ma le conversioni crollano, il problema è probabilmente la pagina o l'offerta, non l'inserzione.
7. **Tracciamento.** Conversioni a zero all'improvviso con traffico normale, oppure qualità del dataset peggiorata: è un problema di misura, non di performance.

Per la diagnosi dettagliata segui l'albero in `references/lettura-dati.md`.

## 3. Decidi: una decisione per ogni campagna

| Decisione | Quando |
|---|---|
| **TENERE** | In linea o troppo presto per dirlo. Non si tocca. |
| **SISTEMARE** | Problema noto con soluzione nota (rifiuto, budget esaurito, fatica evidente). |
| **TESTARE** | C'è un'ipotesi da verificare (nuova creatività, nuovo angolo), con una metrica e una regola di stop. |
| **APPROFONDIRE** | I dati non sono affidabili (tracciamento, numeri incoerenti). Prevale sulle altre: non si decide su dati rotti. |

E una priorità:
- **P1 oggi**:
  - spesa anomala;
  - inserzioni bloccate;
  - tracciamento rotto;
  - CPA oltre `spegnere.cpa_oltre_x_target` × target del prodotto dopo una spesa significativa;
  - budget mensile a rischio.
- **P2 questa settimana**:
  - fatica delle creatività;
  - un vincente da scalare;
  - una variante da preparare;
  - una verifica del registro scaduta.
- **P3 osservare**: tutto il resto.

Per le campagne di notorietà: P1 solo per spesa anomala, inserzioni bloccate, paese o posizioni diversi da quelli della scheda, budget mensile a rischio; P2 per contenuti DEBOLE da sostituire, contenuti DA SCALARE, bacino sotto `reel_attivi_min`, fine della misura. Il dettaglio per contenuto lo fa `/notorieta`.

Segna anche le **opportunità creative**, che passerai a `/creativita`:
- le inserzioni vincenti, cioè quelle che hanno superato `campione_minimo` e stanno sotto il target del loro prodotto;
- quelle stanche, da sostituire.

## 4. Scrivi il briefing

Salva in `<profilo>/report/briefing/AAAA-MM-GG.md`:

```
# Briefing <giorno> <data>
**In sintesi:** <una frase con la notizia principale>

## Rispetto all'obiettivo
Account: spesa ieri vs media 7 gg · ritmo del mese vs budget massimo
- <ETICHETTA prodotto>: <semaforo 🟢/🟡/🔴> · risultati · CPA o ROAS vs target del prodotto
- <ETICHETTA notorietà>: <"in misura, giorno n di m" oppure semaforo> · persone raggiunte · follower dalle inserzioni · costo per <risultato> vs riferimento · contenuti attivi
- Senza prodotto: <campagne e spesa, se ce ne sono>

## Da fare
1. [P1] <campagna> — <decisione> — <perché, con i numeri> — <prossimo passo>
2. [P2] ...

## Opportunità creative
- <inserzione vincente o stanca, con i numeri> → <variante o creatività nuova>

## Tabella campagne
| Campagna | Prodotto | Spesa ieri | Media 7 gg | Risultati 7 gg | CPA/ROAS 7 gg vs target | Frequenza | Decisione |

## Fatti · Ipotesi · Dati mancanti
- Fatti: ...
- Ipotesi: ...
- MANCANTE: ...

## Verifiche in scadenza dal registro
- ...

## Schede prodotto da riconfermare
- <ETICHETTA> (ultima conferma <data>), oppure "nessuna"
```

In chat mostra solo la sintesi, i punti "Da fare" e le opportunità. Chiudi proponendo il passo successivo: `/interventi` per i punti P1 e P2, `/creativita` per le opportunità, `/notorieta` per i contenuti di un bacino, oppure "tutto regolare, nessuna azione".

## Se il briefing gira programmato (senza persona davanti)

Fai lo stesso lavoro e salva il file. Non fare domande e non proporre scritture: le scritture sono comunque bloccate. Metti in cima al file `**Generato automaticamente alle <ora>.**`
