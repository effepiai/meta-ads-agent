# Checklist dell'audit

*Adattata da claude-ads `ads/references/meta-audit.md` v1.8 (Daniel Agrici, MIT) e marketingskills `audit-guardrails.md` (Corey Haines, MIT). Le soglie sono regole pratiche di professionisti, non dati ufficiali Meta. Gli importi originali in dollari sono convertiti a valori indicativi in euro.*

Legenda della colonna "Come": **C** = si verifica dal connettore · **Cl** = va chiesto al cliente (Events Manager, sito, CRM).

## Tracciamento — peso 30%

| # | Controllo | Ok | Attenzione | Problema | Come |
|---|---|---|---|---|---|
| T1 | Pixel o dataset attivo e ricevuto negli ultimi 7 giorni | Eventi ogni giorno | Buchi di qualche giorno | Nessun evento | C |
| T2 | API di conversione (invio lato server) attiva | Sì, insieme al pixel | Solo in parte | No | C / Cl |
| T3 | Deduplicazione pixel + server | Event ID presente, deduplica ≥90% | Event ID presente, <90% | Nessun Event ID (doppio conteggio) | C / Cl |
| T4 | Qualità dell'abbinamento (EMQ) dell'evento di acquisto | ≥ 8,5 (AddToCart ≥ 6,5) | 6,0-8,4 | < 6,0 | C |
| T5 | Evento di conversione standard (Purchase, Lead…) | Standard | Misto | Solo eventi personalizzati | C |
| T6 | Dominio verificato | Sì | — | No | Cl |
| T7 | Finestra di attribuzione coerente con il ciclo di vendita | Verificata (predefinito 7 giorni clic, 1 giorno visualizzazione) | Default non verificato | Incoerente | C |
| T8 | UTM su tutti i link | Tutti | Alcuni | Nessuno | C |

## Creatività — peso 30%

| # | Controllo | Ok | Attenzione | Problema | Come |
|---|---|---|---|---|---|
| K1 | Varietà di formati attivi | ≥ 3 (immagine, video, carosello) | 2 | 1 | C |
| K2 | Creatività per gruppo di inserzioni | ≥ 5 (≥ 10 su Advantage+ vendite) | 3-4 | < 3 | C |
| K3 | Video verticale 9:16 presente | Sì | Solo 1:1 o 4:5 | Nessun video | C |
| K4 | Fatica: inserzioni attive stanche secondo `lettura-dati.md` (CTR giù, costo su, frequenza su in 14 giorni) | Nessuna | Una | Più di una | C |
| K5 | Hook rate dei video (chi guarda 3 secondi) | ≥ 50% non salta | 30-50% | < 30% | C |
| K6 | Creatività nuova testata di recente | Negli ultimi 14-21 giorni | 21-45 giorni | Oltre 45 giorni | C |
| K7 | Frequenza a 7 giorni, pubblico nuovo, rispetto alla soglia del prodotto (o `regole.fatica`) | Sotto soglia, o sopra con risultati stabili | Sopra soglia con CTR in calo | Sopra soglia con CTR in calo e costo in salita | C |
| K8 | Frequenza a 7 giorni, retargeting, rispetto alla soglia del prodotto (o `regole.fatica`) | Sotto soglia, o sopra con risultati stabili | Sopra soglia con CTR in calo | Sopra soglia con CTR in calo e costo in salita | C |
| K9 | CTR | ≥ 1% (o sopra lo storico dell'account) | 0,5-1% | < 0,5% | C |
| K10 | Diversità reale delle idee: non solo varianti dello stesso concept | Idee e angoli diversi | Poche idee | Tutte varianti di una | C |
| K11 | Contenuti dall'aspetto nativo o UGC (girati dai clienti o da creator) | ≥ 30% | 10-30% | < 10% | C |
| K12 | Post organici migliori usati (boost o partnership) | Sì | In parte | No | C |

## Struttura — peso 20%

| # | Controllo | Ok | Attenzione | Problema | Come |
|---|---|---|---|---|---|
| S1 | Numero di campagne attive per obiettivo | 1-3 | 4-5 | > 5 (troppo frammentato) | C |
| S2 | Gruppi in "learning limitato" | < 30% | 30-50% | > 50% | C |
| S3 | Learning fatto ripartire da modifiche inutili nel mese | Mai | 1-2 volte | Spesso | C |
| S4 | Budget per gruppo rispetto al CPA target del prodotto | ≥ 5 × CPA | 2-5 × CPA | < 2 × CPA | C |
| S5 | Budget minimo per gruppo | ≥ 10 €/giorno | 5-10 € | < 5 € | C |
| S6 | Utilizzo del budget giornaliero | > 80% | 60-80% | < 60% | C |
| S7 | Obiettivo di campagna coerente con l'obiettivo del business | Sì | — | No (per esempio Traffico per vendere) | C |
| S8 | CBO o ABO adeguato: CBO = budget distribuito da Meta tra i gruppi, ABO = budget per gruppo | Coerente con budget e test | Funziona ma non ideale | Incoerente | C |
| S9 | Posizionamenti Advantage+ (automatici) | Sì, o esclusioni motivate | Manuali motivati | Manuali senza motivo | C |
| S10 | Strategia di offerta | Coerente: tetto di costo per proteggere il margine, costo minimo per il volume | — | Tetto sotto il CPA storico | C |
| S11 | Almeno un test attivo o pianificato | Sì | Pianificato | Nessuno | C |
| S12 | Gruppi che si sovrappongono sullo stesso pubblico | No | Poca sovrapposizione | Molta | C |

## Pubblico — peso 20%

| # | Controllo | Ok | Attenzione | Problema | Come |
|---|---|---|---|---|---|
| P1 | Advantage+ Audience in uso o testato | Sì | — | Mai testato | C |
| P2 | Clienti già acquisiti esclusi dal pubblico nuovo (se l'obiettivo è acquisire) | Sì | In parte | No | C |
| P3 | Pubblici personalizzati del sito aggiornati | Entro 180 giorni | 180-365 | Oltre o assenti | C |
| P4 | Lookalike da fonti di valore | Fonte ≥ 1000 persone di alto valore | 500-1000 | < 500 o fonte debole | C |
| P5 | Dati propri (liste clienti) usati | Sì e aggiornati | Caricati ma vecchi | No | C / Cl |

## Conformità e governance — controllo senza peso, ma ogni Problema va in cima al report

| # | Controllo | Ok | Problema | Come |
|---|---|---|---|---|
| G1 | Categoria speciale dichiarata se il settore lo richiede | Sì | No | C |
| G2 | Dati DSA (beneficiario e pagante) per l'UE | Compilati | Mancanti | C |
| G3 | Etichetta AI sulle creatività generate con l'AI | Coerente con la policy del cliente | Incoerente | C |
| G4 | Tutte le scritture del mese passate da un sì (registro decisioni contro `<profilo>/registro/azioni-meta.jsonl`) | Sì | Scritture senza voce nel registro | C |
| G5 | Nessuna inserzione rifiutata attiva o abbandonata | Nessuna | Rifiutate non gestite | C |
