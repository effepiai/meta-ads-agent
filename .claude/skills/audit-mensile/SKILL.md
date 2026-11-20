---
name: audit-mensile
description: Audit mensile completo dell'account Meta Ads con una checklist di circa 40 controlli su tracciamento, creatività, struttura, pubblico e conformità. Ogni controllo è Ok, Attenzione, Problema, Non verificabile o Non applicabile. Il punteggio si dà solo se si è verificata abbastanza parte dei controlli. Solo lettura. Usala una volta al mese, col comando /audit-mensile, o quando il cliente chiede "fai un controllo completo", "audit", "com'è messo l'account?".
---

# Audit mensile

**Solo lettura.** Prima leggi:
- `<profilo>/cliente/config.yaml`;
- l'ultimo audit in `<profilo>/report/audit/`, per confrontare;
- `references/checklist.md`.

## 1. Raccogli

- Struttura completa degli ultimi 30 giorni (`ads_get_ad_entities` sui livelli campaign, adset e ad): obiettivi, budget, strategia di offerta, learning, frequenza, CTR, posizionamenti, targeting.
- Qualità del tracciamento: `ads_get_datasets`, `ads_get_dataset_quality`, `ads_get_dataset_stats`.
- Pubblici: `ads_get_ad_account_custom_audiences`.
- Test: `ads_experiment_list_tests`.
- Raccomandazioni Meta: `ads_get_opportunity_score`.
- Confronto con il mercato: `ads_insights_performance_vs_peers` e `ads_insights_industry_benchmark`.
- Modifiche del mese: `ads_account_get_activity_logs`.

## 2. Valuta ogni controllo

Usa la checklist. Gli esiti possibili sono:
- **Ok**;
- **Attenzione**;
- **Problema**;
- **Non verificabile**: il dato non si legge dal connettore (per esempio impostazioni di Events Manager). Va chiesto al cliente o lasciato così;
- **Non applicabile**. Per le campagne di una scheda con `tipo: notorieta` sono non applicabili i controlli che presuppongono un CPA, un ROAS, un pixel o una pagina di destinazione (per esempio S4). Al loro posto si controlla quello che dice `.claude/skills/notorieta/references/giudizio.md`: scheda completa, misura fatta, contenuti attivi sopra il minimo, paese e posizioni uguali a quelli della scheda.

**Non verificabile** non è un problema dell'account: riduce la copertura, non il punteggio.

## 3. Punteggio (solo se onesto)

- Punteggio per categoria = controlli Ok ÷ controlli verificati. Peso con i pesi della checklist.
- **Copertura** = controlli verificati ÷ controlli applicabili.
  - Almeno 80%: il punteggio vale.
  - Tra 60 e 79%: punteggio **provvisorio**.
  - Sotto 60%: **nessun punteggio**, solo l'elenco dei problemi trovati.
- Le soglie della checklist sono regole pratiche, non verità: lo storico dell'account e i benchmark Meta valgono di più.

## 4. Scrivi

Salva in `<profilo>/report/audit/AAAA-MM.md`:
- sintesi in 3 righe;
- punteggio con copertura, oppure il motivo per cui manca;
- confronto con il mese scorso;
- tabella per categoria;
- **le 5 correzioni più importanti**, ordinate per impatto stimato e facilità, ognuna con chi la fa (agent con `/interventi` oppure cliente in Ads Manager o Events Manager);
- l'elenco dei controlli non verificabili, con la domanda da fare al cliente.
