# Prodotti e obiettivi

Un'azienda vende cose diverse, con valori e margini diversi: un corso, una consulenza, un prodotto dello shop. Un unico costo obiettivo per tutto l'account porterebbe a spegnere campagne che rendono o a scalarne altre che perdono. Per questo ogni prodotto o servizio pubblicizzato ha una **scheda** in `<profilo>/cliente/config.yaml`, nella sezione `prodotti`, e **ogni campagna si giudica con l'obiettivo del suo prodotto**.

Le soglie in `regole` (moltiplicatori, frequenze, campioni) valgono per tutti i prodotti, salvo quelle di fatica che una scheda può sovrascrivere per il suo pubblico (campo `fatica`). I numeri economici (CPA o ROAS target, pareggio, valore, margine) stanno solo nelle schede.

## La scheda

| Campo | Cosa contiene |
|---|---|
| `etichetta` | Nome breve, maiuscolo, senza spazi (es. `CORSI`). Va all'inizio del nome delle campagne. |
| `stato` | `attivo` (si pubblicizza ora), `futuro` (se ne parlerà), `sospeso`. |
| `tipo` | `vendita` (predefinito: si giudica su CPA o ROAS) oppure `notorieta` (farsi conoscere: vedi sotto). |
| `risultato`, `evento_conversione` | Cosa conta come risultato (vendita, contatto, telefonata…) e l'evento Meta. |
| `kpi` | `cpa` (costo per risultato) o `roas` (ricavo diviso spesa). |
| `valore_medio`, `margine_pct`, `passaggi_vendita` | I numeri da cui si calcola il pareggio. |
| `cpa_pareggio`, `cpa_target`, `roas_target` | Il limite oltre il quale si perde e l'obiettivo. |
| `budget_mensile` | Facoltativo: quota del budget dell'account. |
| `pubblico`, `zona`, `stagionalita`, `pagina_destinazione` | Il contesto per creatività e campagne. |
| `pubblico_dimensione` | `ampio` (si rinnova di continuo, frequenze basse) o `ristretto` (locale, di nicchia o di alto valore: frequenze alte sono normali). |
| `fatica` | Facoltativo: soglie che sostituiscono quelle di `regole.fatica` per questo prodotto, per esempio `{frequenza_freddo_attenzione: 4}`. Si compilano con la taratura (vedi sotto), non a occhio. |
| `campagne` | ID delle campagne di questo prodotto il cui nome non ha l'etichetta. |
| `da_confermare` | Campi stimati dall'agent e non ancora confermati dal cliente. |
| `aggiornato_il` | Data dell'ultima conferma del cliente. |

## Calcolare pareggio e obiettivo

- **CPA di pareggio** = valore medio × margine × probabilità che un risultato diventi una vendita.
  Esempio: corso da 1.000 € con margine del 50%, 1 contatto su 2 diventa preventivo, 3 preventivi su 10 diventano iscrizioni → 1.000 × 0,5 × 0,5 × 0,3 = **75 €** a contatto.
- **ROAS di pareggio** = 100 ÷ margine %.
- **Obiettivo**: proponi un valore sotto il pareggio che lasci un margine (per esempio la metà o un terzo del pareggio) e fallo confermare. Se un passaggio è stimato, mettilo in `da_confermare`.
- Mai inventare un numero: se manca, chiedilo o proponi come ricavarlo (per esempio il CPA medio dello storico) e segnalo come da confermare.

## Le schede di notorietà

Una campagna fatta per farsi conoscere (copertura, visualizzazioni dei video, follower) non porta contatti né vendite: giudicarla con un CPA la farebbe spegnere sempre. Ha quindi una scheda con `tipo: notorieta`:
- **non ha** valore medio, margine, pareggio, `cpa_target` né `roas_target`: quei campi restano vuoti e non vanno chiesti;
- il suo metro è il **costo per il risultato principale** (follower, visualizzazione completa, persona raggiunta o visita al profilo), confrontato con `notorieta.costo_riferimento`, cioè il costo misurato sull'account nel periodo di misura, e con `notorieta.costo_target`, confermato dal cliente dopo la misura;
- il limite vero è `budget_mensile`, obbligatorio su queste schede;
- finché `costo_riferimento` è vuoto la campagna è **in misura**: si riportano spesa, consegna e classifica dei contenuti, senza giudizio sui costi.

Tutte le regole sono in `.claude/skills/notorieta/references/giudizio.md`. Dove queste istruzioni e le altre skill dicono "CPA target del prodotto", per una scheda di notorietà si legge "costo di riferimento del risultato principale". Le formule con margine, pareggio e ROAS non si applicano.

## Collegare una campagna al suo prodotto

In quest'ordine:
1. l'ID della campagna è nella lista `campagne` di una scheda;
2. il nome della campagna inizia con `[ETICHETTA]`, per esempio `[CORSI] Contatti Lombardia`;
3. per le inserzioni nella campagna di test condivisa (`meta.campagna_test_id`), il nome dell'**inserzione** inizia con `[ETICHETTA]`.

Se una campagna attiva non si collega a nessuna scheda è **senza prodotto**:
- riporta spesa, consegna e fatica, ma **non giudicare CPA o ROAS** e non proporre di spegnere o scalare in base ai costi;
- proponi al cliente a quale prodotto potrebbe appartenere e chiedi conferma. Con il sì, aggiungi l'ID alla lista `campagne` della scheda: è una modifica al file di configurazione, non a Meta.

Le campagne nuove nascono sempre con l'etichetta nel nome (lo fanno `/lancio-campagna` e `/pubblica`).

## Il riepilogo dell'account

Con più prodotti non esiste un CPA unico dell'account: sommare contatti da 75 € e vendite da 30 € non dice nulla. Il riepilogo si fa **per prodotto** (risultati, CPA o ROAS contro il target del prodotto). A livello di account si guardano solo la spesa totale e il ritmo contro `budget.massimo_mensile`.

## Le soglie per pubblico e la taratura

Il pubblico cambia cosa è normale: la stessa frequenza è un allarme per un prodotto di massa e la normalità per uno di nicchia.
- All'onboarding si indica solo `pubblico_dimensione`. Il campo `fatica` della scheda resta vuoto: valgono le soglie generali, che comunque non bastano da sole a dichiarare stanca un'inserzione (vedi `lettura-dati.md`).
- Dopo 4 settimane di dati, la revisione settimanale fa la **taratura**: calcola dallo storico del prodotto le soglie adatte e le propone al cliente. Con il sì si scrivono nel campo `fatica` della scheda (o in `regole`, se valgono per tutto l'account).

## Le informazioni già date non si richiedono

Quello che il cliente ha già detto è nei file (`config.yaml`, `brand-profile.md`, `<profilo>/registro/`). Non si rifanno le domande da capo: **si mostra quello che si sa e si chiede se vale ancora.**

- **Nuova campagna o nuove creatività per un prodotto che ha già una scheda.** Mostra la scheda in 3-5 righe (risultato, valore, margine, obiettivo, zona, stagione) con la data di `aggiornato_il` e chiedi una sola cosa: "Valgono ancora questi numeri?".
  - Se la scheda è più vecchia di `regole.scheda_prodotto_valida_giorni` giorni, dillo ("l'ultima conferma è di 6 mesi fa") e chiedi espressamente di prezzi, margini, offerta e stagione, che sono i dati che cambiano più spesso.
  - Con il sì, aggiorna `aggiornato_il` a oggi. Se cambia qualcosa, aggiorna solo quei campi e ricalcola pareggio e obiettivo.
- **Prodotto senza scheda.** Fai solo le domande della scheda (le stesse del Blocco B dell'onboarding, per quel prodotto), calcola pareggio e obiettivo, falli confermare e crea la scheda. Prima di chiedere, guarda se lo storico dell'account, il sito o `brand-profile.md` hanno già la risposta.
- **Campi in `da_confermare`.** Chiedili alla prima occasione utile, per esempio alla revisione settimanale, uno o due alla volta.
- **Lavoro di routine** (briefing, interventi, revisione). Si usano le schede così come sono, senza fare domande. Se una scheda attiva è oltre la validità, aggiungi una riga in fondo: "Scheda <ETICHETTA> da riconfermare (ultima conferma <data>)".

Lo stesso vale per il profilo del brand: prima di una creatività nuova, se qualcosa è cambiato (offerte, prove, tono), si aggiorna `brand-profile.md` dopo averlo mostrato al cliente.
