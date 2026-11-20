---
name: revisione-settimanale
description: Revisione settimanale dell'account Meta Ads. Dà un verdetto sulle mosse e sulle creatività della settimana prima (funzionata, non funzionata, troppo presto, non si sa), legge i test, aggiorna le lezioni imparate e scrive un report breve per il cliente con il piano della settimana dopo. Solo lettura. Usala nel giorno fissato in config (operativita.giorno_revisione), col comando /revisione-settimanale, o quando il cliente chiede "com'è andata la settimana?", "fammi il report".
---

# Revisione settimanale

**Solo lettura.** Prima leggi:
- `<profilo>/cliente/config.yaml`;
- `<profilo>/registro/decisioni.md`, `<profilo>/registro/creativita.md` e `<profilo>/registro/lezioni.md`;
- i briefing della settimana in `<profilo>/report/briefing/`;
- `.claude/skills/briefing/references/lettura-dati.md` e `prodotti.md`;
- `.claude/skills/notorieta/references/giudizio.md` e `rotazione.md`, se il profilo ha schede con `tipo: notorieta`.

## 1. Dall'ultima volta: un verdetto su ogni mossa

Per ogni voce di `<profilo>/registro/decisioni.md` con "Da verificare il" scaduto:
1. leggi i dati dell'oggetto **dalla data della modifica** e confrontali con lo stesso numero di giorni prima, escludendo le ultime 72 ore;
2. assegna un verdetto:
   - **funzionata**: l'effetto atteso c'è, oltre il rumore;
   - **non funzionata**: l'effetto atteso non c'è, o c'è l'effetto opposto;
   - **troppo presto**: il campione è insufficiente; sposta la data di verifica;
   - **non si sa**: troppe cose cambiate insieme o dati inaffidabili; spiega perché.
3. scrivi il verdetto nella voce del registro.

## 2. Creatività in test

Per ogni riga di `<profilo>/registro/creativita.md` con esito "in test":
- metriche dell'inserzione dalla pubblicazione: spesa, CTR, costo per risultato, frequenza. Per i video: quota che supera il primo quarto e visualizzazioni complete sulle riproduzioni. L'hook rate sui 3 secondi si legge sul gruppo, perché per singola inserzione il dato non esiste;
- se c'è un A/B test, `ads_experiment_list_tests` e `ads_experiment_abtest_get_test`;
- giudica solo dopo `campione_minimo` e almeno 5-7 giorni;
- esiti possibili:
  - **vincente**: sotto il target del suo prodotto con campione sufficiente; si propone di scalarla o farne varianti;
  - **da tenere**;
  - **perdente**: si propone la pausa con `/interventi`;
  - **troppo presto**.

**Contenuti di una campagna di notorietà** (tipo "post esistente" nel registro): l'esito non passa dal target di costo per contatto. Usa i verdetti di `.claude/skills/notorieta/references/giudizio.md`: POCO TESTATO resta "in test", REGGE diventa "da tenere", DA SCALARE "vincente", DEBOLE "perdente". Durante la misura restano tutti "in test".

## 3. Le lezioni

Se un verdetto insegna qualcosa di riutilizzabile, aggiungilo in `<profilo>/registro/lezioni.md`, con la fonte. Per esempio: "Le statiche con recensione battono i video prodotto sul pubblico nuovo: CTR 1,8% contro 1,1%, 3 test, ottobre". Le lezioni sono fatti verificati, non opinioni.

## 4. Il quadro della settimana

- Spesa dell'account contro budget.
- **Per ogni prodotto**: risultati, CPA o ROAS contro il target della sua scheda, e il confronto con la settimana precedente.
- **Per ogni scheda di notorietà**: spesa contro `budget_mensile`, persone raggiunte, frequenza, follower dalle inserzioni, costo per il risultato principale contro riferimento e target, contenuti attivi, e cosa hanno in comune i contenuti migliori e i peggiori (`rotazione.md`, "Dai risultati alle idee"). Se la misura è finita e `costo_riferimento` è vuoto, calcola le mediane e proponi riferimento e target.
- Schede prodotto da riconfermare e campi `da_confermare`: scegline uno o due da chiedere al cliente in fondo al report.
- Le 2-3 variazioni più importanti, con causa e livello di fiducia (alto, medio, basso).
- Lo stato delle creatività:
  - quante idee nuove sono in test (minimo `creativita.concept_in_test_min`);
  - quante creatività sono a rischio di fatica nelle prossime 2 settimane.
- Il ritmo del budget mensile.

## 4b. Taratura delle soglie (dopo 4 settimane di dati)

Le soglie iniziali in `regole` sono regole pratiche, in buona parte nate su account americani. Vanno misurate sull'account del cliente.

**Quando.** Alla prima revisione in cui un prodotto ha almeno `regole.taratura.dopo_giorni` giorni di campagne attive, poi ogni `regole.taratura.ripeti_ogni_giorni` giorni. La data dell'ultima taratura è in `regole.taratura.ultima`.

**Cosa si misura**, per ogni prodotto con dati sufficienti, sulle settimane disponibili (escluse le ultime 72 ore):
- la **frequenza** settimanale dei gruppi nelle settimane in cui CTR e costo per risultato erano stabili: è la frequenza "normale" di quel pubblico. Se c'è stata almeno una settimana di fatica vera (CTR giù, costo su, frequenza su), conta la frequenza a cui è cominciata;
- la **variazione normale del CTR** da una settimana all'altra: `calo_ctr_pct` deve stare sopra l'oscillazione abituale, altrimenti scatta per rumore;
- la **variazione normale del costo per risultato**, per `aumento_costo_risultato_pct`;
- l'**hook rate** tipico dei video del prodotto, per `hook_rate_min_pct`;
- per le schede di **notorietà**: le mediane di aggancio, tenuta e costo per risultato dei contenuti con campione sufficiente, per aggiornare `notorieta.costo_riferimento` e, se i dati lo giustificano, le soglie di `regole.notorieta`. Con meno di `reel_min_per_mediana` contenuti misurati è "troppo presto".

**Come si propone.** Una tabella per prodotto: soglia, valore attuale → valore proposto, dati su cui si basa (periodo, numero di settimane, conversioni). Regole:
- con meno di 4 settimane o meno di `campione_minimo.conversioni_per_lettura_fine` conversioni, scrivi "troppo presto" e riprova alla revisione dopo;
- mai cambiare i numeri economici (CPA target, pareggio, margine, `costo_target` di una scheda di notorietà): quelli sono del cliente, nelle schede. Il `costo_riferimento` invece è una misura: si aggiorna, mostrando il valore vecchio e quello nuovo;
- mai toccare le soglie di sicurezza: budget, `aumento_max_per_passo_pct`, learning.

Con il sì del cliente aggiorna il campo `fatica` della scheda (o `regole`), poi `regole.taratura.ultima` a oggi. Scrivi la taratura in `<profilo>/registro/decisioni.md` (prima → dopo, perché, verifica alla taratura successiva) e, se insegna qualcosa sull'account, in `<profilo>/registro/lezioni.md`. È una modifica al file di configurazione, non a Meta: vale anche in sola lettura.

## 5. Il piano della settimana dopo

- Le mosse da proporre con `/interventi`.
- Le creatività da preparare con `/creativita`, una coda di 2-3 idee.
- I test da far partire o chiudere.
- Le verifiche in scadenza.
- La taratura, se è dovuta e non è stata ancora approvata.

## 6. Scrivi il report

Salva in `<profilo>/report/settimanali/AAAA-Www.md` (per esempio `2026-W44.md`). La prima parte è **per il cliente**, sotto le 200 parole:

```
# Settimana <n> (<data inizio> – <data fine>)
**In sintesi:** <una frase>

Spesa: <x> di <budget>
- <ETICHETTA>: 🟢/🟡/🔴 <CPA o ROAS vs target> · Risultati: <n>
- <ETICHETTA notorietà>: <in misura | 🟢/🟡/🔴> · Persone raggiunte: <n> · Follower dalle inserzioni: <n> · Costo per <risultato>: <x> vs riferimento

**Cosa è cambiato**
1. <variazione> — <causa> (fiducia: alta/media/bassa)
2. ...

**Cosa abbiamo fatto e com'è andata**
- <mossa> → <verdetto>

**La prossima settimana**
- ...
```

Sotto, una sezione **"Dettaglio tecnico"** con tabelle, verdetti completi e dati mancanti.

In chat mostra la parte per il cliente e proponi i prossimi passi.
