---
name: onboarding
description: Setup iniziale del progetto per il cliente. Verifica i connettori, legge il design system e il materiale del brand, fa le domande su obiettivi, numeri, pubblico, creatività e operatività, fotografa l'account Meta e compila <profilo>/cliente/config.yaml e <profilo>/cliente/brand-profile.md. Usala al primo avvio (quando onboarding_completato è false), quando il cliente dice "configuriamo", "rifacciamo il setup", "cambiano gli obiettivi", oppure col comando /onboarding.
---

# Onboarding

Obiettivo: alla fine l'agent conosce il cliente abbastanza per lavorare da solo. Questo significa:
- `<profilo>/cliente/config.yaml` compilato;
- `<profilo>/cliente/brand-profile.md` scritto;
- una fotografia dell'account in `<profilo>/report/onboarding.md`.

**Durante l'onboarding non si scrive nulla su Meta.**

L'onboarding riguarda **il profilo scelto in questa sessione**, cioè un solo account pubblicitario. Se la sessione non ha ancora un profilo, usa prima la skill `profili` (per un cliente nuovo: `./scripts/nuovo-profilo.sh <nome>` e `./scripts/usa-profilo.sh <nome> <id-sessione>`).

Tono: accogliente e rapido. Spiega all'inizio cosa succederà e quanto dura (circa 20-30 minuti). Fai le domande **a blocchi**, con lo strumento delle domande a scelta quando le opzioni sono chiare, e lascia sempre spazio a una risposta libera. Non chiedere quello che puoi leggere da solo dall'account, dal sito o dai file.

Se l'onboarding è già stato fatto e il cliente vuole solo aggiornare qualcosa, chiedi cosa e tocca solo quel blocco.

**Se il cliente vuole solo farsi conoscere** (più follower, copertura, visite al profilo, promuovere i post che ha già) e non vendere né raccogliere contatti, non fargli fare tutto questo: proponi il percorso rapido della skill `notorieta`, che chiede solo account, Instagram, zona, budget ed etichetta. Il resto si completa qui quando servirà.

**Se il profilo ha già fatto il percorso rapido** (`onboarding_rapido: true`): non richiedere quello che c'è già nel config (account, Instagram, pagina, paese, scheda di notorietà, fase). Mostralo, chiedi se vale ancora e fai solo i blocchi che mancano. Non riportare la fase a `sola_lettura` senza che il cliente lo chieda.

## Passo 1 — Benvenuto e controllo dei connettori

1. Presentati in tre righe: cosa fai (briefing ogni mattina, proposte di intervento, creatività, pubblicazione in pausa) e cosa non fai mai da solo (attivare, spostare budget, spendere crediti, cancellare).
2. Verifica il connettore Meta chiamando `ads_get_ad_accounts`.
   - Se il tool non esiste o dà errore di autenticazione: spiega come collegarlo (README, sezione "Collegare Meta") e fermati.
   - Per ogni account mostra nome, ID, business e attività. Segnala `is_ads_mcp_enabled: false`, `is_queryable: false` (con il motivo), `has_payment_method: false` e uno stato diverso da ACTIVE.
3. Controlla quali altri connettori ha il cliente e annotali per il Passo 6: generazione immagini, Figma, Canva, Drive.

## Passo 2 — Azienda e obiettivi (domande)

Prima leggi il sito del cliente, se te lo dà, per non chiedere l'ovvio. Poi chiedi:

**Blocco A — L'azienda**
- Nome, sito, cosa vendi in una frase, prodotto o servizio su cui spingere di più.
- Paesi in cui vendi e lingua degli annunci.
- Settore regolamentato? (salute, finanza, lavoro, casa, alcol, integratori…) Serve per le categorie speciali Meta e le frasi vietate.

**Blocco B — Prodotti, obiettivi e numeri** (il blocco più importante: senza questi l'agent non può giudicare)

Un'azienda vende cose diverse, con valori e margini diversi: ogni prodotto o servizio pubblicizzato ha la sua **scheda** in `prodotti` (regole in `.claude/skills/briefing/references/prodotti.md`).

1. Elenca i prodotti o servizi che hai trovato su sito e account e chiedi quali si pubblicizzano **adesso**. Gli altri diventano schede `futuro` con il solo nome: i numeri si chiedono quando si lanceranno.
2. Per ogni prodotto da pubblicizzare adesso:
   - cosa conta come risultato: vendita online, contatto (lead), telefonata, messaggio, prenotazione, visita al negozio;
   - il numero che guardi: costo per risultato (CPA) o ritorno sulla spesa (ROAS);
   - il valore medio dell'ordine o del cliente;
   - il margine di contribuzione medio in %. Serve per il pareggio: con il 30% di margine un ROAS sotto 3,3 perde soldi;
   - i passaggi dal risultato alla vendita, per esempio "su 10 preventivi, quanti diventano ordini?";
   - chi compra davvero, in che zona, con che stagionalità;
   - se il pubblico è ampio (tante persone, si rinnova di continuo) o ristretto (locale, di nicchia o di alto valore): va in `pubblico_dimensione` e cambia la frequenza normale.

   Poi calcola il **costo di pareggio** e proponi un **obiettivo**, come in `prodotti.md`, mostrando il calcolo. Il cliente conferma o corregge.

   **Se lo scopo è farsi conoscere** (più persone che vedono i contenuti, più follower) e non un contatto o una vendita, la scheda è di `tipo: notorieta` e le domande su valore, margine e passaggi di vendita **non si fanno**. Chiedi solo: cosa conta di più (follower, video visti fino in fondo, persone raggiunte, visite al profilo), dove (solo Instagram o anche Facebook), a chi (paese, lingua), budget mensile per la notorietà. Il costo obiettivo non si chiede: si misura nelle prime settimane. Dettagli in `.claude/skills/notorieta/SKILL.md`, passo 1.
3. Per tutto l'account: il budget Meta giornaliero o mensile e il massimo che non va mai superato.

Se il cliente non conosce un numero, proponi un modo per ricavarlo, per esempio il CPA medio degli ultimi 90 giorni dall'account. Segnalalo come **da confermare** (nella lista `da_confermare` della scheda), non inventarlo.

## Passo 3 — L'account Meta (lo leggi tu, poi confermi)

Leggi e poi chiedi conferma su quello che hai trovato:
- **L'account di questo profilo.** Se il connettore ne vede più di uno, chiedi quale gestire **in questo profilo**: uno solo. Controlla con `./scripts/profili.sh` che non sia già in un altro profilo; se lo è, fermati e chiedi come procedere. Gli altri account, se il cliente li vuole gestire, avranno ciascuno il suo profilo. Appena il cliente sceglie, scrivi l'account in `meta.account_pubblicitari` (`- { id: "<numero>", nome: "<nome>", ruolo: "principale" }`): da quel momento gli hook lasciano passare solo le chiamate su quell'account.
- **Pagina Facebook e account Instagram** (`ads_get_ad_account_pages`, `ads_get_ig_accounts`). `ads_get_ad_account_pages` elenca le pagine già promosse dall'account: una pagina che non compare lì può essere comunque utilizzabile. Controlla anche `ads_get_user_pages`, e per Instagram il `page_id` abbinato restituito da `ads_get_ig_accounts`.
- **Dataset e pixel** (`ads_get_datasets`) e la sua qualità (`ads_get_dataset_quality`). Chiedi quale evento è la conversione che conta.
- **Campagne attive, ultimi 90 giorni** (`ads_get_ad_entities`, level campaign): obiettivo, budget, CBO o ABO, spesa, risultati.

Poi domande:
- Ci sono campagne che **non devo mai toccare**? (vanno in `non_toccare`)
- Qualcun altro lavora sull'account (agenzia, collaboratori)? Serve a evitare modifiche in conflitto.
- C'è già una campagna dove testare le creatività nuove? Se no, ne proporrai una con `/lancio-campagna` quando si uscirà dalla sola lettura.

## Passo 4 — Pubblico, offerta e prove (domande)

- Chi è il cliente ideale? Chi compra davvero, non chi vorresti che comprasse.
- Perché comprano? Chiedi frasi dei clienti: recensioni, messaggi, domande frequenti.
- Obiezioni più comuni e come rispondi.
- Offerte attive e scadenze; garanzie, spedizione, prova gratuita.
- Prove disponibili: numero di clienti, recensioni, premi, casi, certificazioni.
- Cose che non si possono dire: promesse vietate, vincoli legali, parole del settore da evitare.

## Passo 5 — Brand e design system

1. Leggi tutto quello che c'è in `<profilo>/cliente/brand/`: PDF, immagini, loghi. Guarda le immagini.
2. Se il cliente ha il design system su Figma, Canva o Drive con il connettore attivo, leggilo da lì. Altrimenti chiedi di esportare i pezzi chiave in `<profilo>/cliente/brand/`.
3. Dal sito ricava colori, font e stile fotografico.
4. Guarda le inserzioni migliori degli ultimi 90 giorni:
   - con `ads_get_ad_entities` a livello di ad, ordinate per spesa, con metriche di risultato;
   - poi con `ads_get_creatives` e `ads_get_ad_preview`.

   Capisci quale stile ha funzionato.
5. Domande:
   - Come descriveresti il tono del brand in tre parole?
   - Un'inserzione tua o di altri che ti piace, e una che non ti piace.
   - Le persone possono comparire nelle inserzioni? (fondatore, team, clienti)
6. Scrivi `<profilo>/cliente/brand-profile.md` seguendo il modello già presente. Fallo vedere al cliente e correggilo con lui.

## Passo 6 — Creatività e strumenti (domande)

- **Generazione immagini.** Quale strumento usi? Mostra i connettori trovati al Passo 1.
  - Se nessuno: l'agent preparerà testi, prompt e brief per il grafico, e varianti video con ffmpeg.
  - Ricorda che ogni generazione costa e chiederai sempre prima.
- **Video.** Chi gira il materiale nuovo? C'è materiale grezzo? Va messo in `<profilo>/cliente/materiale/`.
- **Caricamento su Meta.** Il connettore accetta file solo da un link pubblico diretto. Le scelte sono tre:
  - `manuale` (predefinita): l'agent prepara i file, il cliente li carica nella libreria multimediale di Ads Manager e l'agent li ritrova per nome;
  - `sito_cliente`: il cliente mette i file in una cartella pubblica del suo sito;
  - `supabase`: un bucket pubblico, con lo script `scripts/carica-media-supabase.sh`.
- **Etichetta AI.** Per i contenuti fatti con l'AI: dichiararlo sempre, mai, o chiedere ogni volta? In UE la dichiarazione conta e dopo la creazione non si cambia.
- **Concorrenti** da tenere d'occhio, con nomi o pagine Facebook.

## Passo 7 — Come lavoriamo (domande)

- **Autonomia.** Consiglia 14 giorni di sola lettura: l'agent fa i briefing, tu confronti i numeri con Ads Manager e prendi fiducia. Poi si passa a `gestione_con_conferma`. Se il cliente vuole partire subito con la gestione, accettalo ma registralo nel config e in `<profilo>/registro/decisioni.md`, con la data e le sue parole.
- **Briefing.** A che ora? Lo vuoi automatico ogni mattina? Se sì, spiega le opzioni del README (attività programmata dell'app desktop, oppure `scripts/briefing-programmato.sh`). Configurale solo con il suo ok.
- **Revisione settimanale.** In che giorno?
- **Approvazioni.** Chi approva le modifiche e le spese?

## Passo 8 — Fotografia di partenza e chiusura

1. **Fotografia dell'account.** Per l'account del profilo:
   - spesa, risultati, CPA o ROAS e frequenza degli ultimi 28 e 90 giorni, per campagna;
   - le inserzioni migliori e peggiori;
   - storico delle modifiche degli ultimi 30 giorni (`ads_account_get_activity_logs`);
   - anomalie (`ads_insights_anomaly_signal`) e opportunity score (`ads_get_opportunity_score`);
   - stato del tracciamento.

   Salva tutto in `<profilo>/report/onboarding.md`, con le prime 3 osservazioni importanti.
2. **Configurazione.** Compila `<profilo>/cliente/config.yaml` con tutte le risposte: una scheda in `prodotti` per ogni prodotto, con `aggiornato_il` a oggi e le stime in `da_confermare`. Poi imposta:
   - `onboarding_completato: true` e `data_onboarding` a oggi;
   - `fase: sola_lettura` e `fine_sola_lettura` a oggi + 14 giorni (oppure la fase scelta dal cliente).

   Le soglie in `regole:` lasciale come sono, salvo indicazioni del cliente. Spiega che sono un punto di partenza e che dopo 4 settimane di dati la revisione settimanale proporrà di tararle sull'account (`regole.taratura`).
3. **Riepilogo al cliente.** Mostra:
   - cosa hai capito (5 righe);
   - i numeri chiave;
   - cosa manca ed è segnato "da confermare";
   - il programma dei prossimi 14 giorni.

   Proponi il primo `/briefing`.
