# Schede dei casi di emergenza

*In parte adattato da meta-ads-skill `troubleshooting.md` (Beka Zakaidze, MIT) e goose-skills `run-paid-campaigns` (GooseWorks, MIT).*

## 1. Inserzione rifiutata o con problemi

- **Leggi**:
  - inserzioni con `effective_status` rifiutato o con problemi (`ads_get_ad_entities`, livello ad);
  - errori e motivi (`ads_get_errors`);
  - la policy citata (`ads_get_help_article`).
- **Cause frequenti**: attributi personali nel testo ("Sei…?"), promesse non dimostrabili, prima e dopo, finta interfaccia, landing non coerente o non funzionante, categoria speciale non dichiarata.
- **Proposta**:
  - se è un errore di Meta: il cliente chiede una revisione da Ads Manager o da Account Quality;
  - se il problema è reale: creatività corretta con `/creativita` e `/pubblica`, poi pausa di quella rifiutata.

  Una creatività non si può modificare: va rifatta.
- "In revisione" è normale fino a 24 ore. Oltre, segnalalo.
- **Mai** tentare di aggirare la revisione: ricaricare identico, cambiare solo qualche parola per ingannare il controllo.

## 2. Account limitato o disabilitato

- **Leggi**: `ads_get_ad_accounts`, cioè `account_status`, `is_queryable` e `not_queryable_reason`.
- **Proposta**:
  - il cliente apre Account Quality (business.facebook.com/accountquality) e chiede la revisione;
  - l'agent prepara il testo della richiesta, con fatti e assenza di violazioni.
- **Mai** creare un business manager o un account parallelo per aggirare il blocco: porta al blocco permanente.
- Se il problema è il metodo di pagamento (`has_payment_method: false` o pagamento rifiutato), lo sistema il cliente in Impostazioni di pagamento.

## 3. Spesa esplosa

- **Leggi**:
  - spesa di ieri e di oggi per campagna;
  - modifiche recenti (`ads_account_get_activity_logs`): è stato alzato un budget? È partita una campagna nuova? Qualcun altro ha cambiato qualcosa?
  - ritmo del mese contro `budget.massimo_mensile`.
- **Proposta**:
  - se è una modifica sbagliata: riportare il budget al valore precedente;
  - se la spesa sta andando bene (CPA sotto il target del prodotto): può essere un'opportunità. Spiegalo e lascia scegliere;
  - se il budget mensile è a rischio: pausa d'emergenza o taglio dei budget, con l'elenco preciso degli oggetti.

## 4. Spesa ferma

Controlla, in ordine:
1. metodo di pagamento;
2. limite di spesa dell'account raggiunto;
3. budget della campagna esaurito o date di fine passate;
4. inserzioni tutte rifiutate o in revisione;
5. gruppo in pausa o padre in pausa;
6. pubblico troppo piccolo;
7. offerta troppo bassa, se c'è un tetto di costo.

La proposta dipende dalla causa. Il limite di spesa dell'account lo cambia solo il cliente.

## 5. Tracciamento rotto

- **Segnali**: conversioni a zero o crollate da un giorno all'altro, mentre clic e visite alla pagina sono normali.
- **Leggi**:
  - `ads_get_dataset_stats` e `ads_get_dataset_quality` per il dataset in config: eventi ricevuti nelle ultime 24-72 ore e qualità dell'abbinamento;
  - modifiche recenti al sito, che chiedi al cliente.
- **Proposta**: è un problema di misura, non di inserzioni.
  - **Non spegnere** campagne per conversioni "sparite".
  - Il cliente o il suo sviluppatore controlla pixel e API di conversione (Events Manager).
  - Nel frattempo i giudizi sulle conversioni sono sospesi: tutte le campagne vanno su APPROFONDIRE.

## 6. Prodotto esaurito, offerta scaduta, pagina rotta

- **Leggi**: quali inserzioni puntano a quel prodotto, pagina o offerta (link nelle creatività con `ads_get_creatives`).
- **Proposta**:
  - pausa d'emergenza delle inserzioni coinvolte, con l'elenco preciso;
  - riattivazione quando il prodotto torna disponibile;
  - se serve, una creatività alternativa su un altro prodotto.

## 7. Crisi di brand

- **Proposta immediata**: pausa d'emergenza di tutte le inserzioni attive, o di quelle legate al tema, con l'elenco preciso. Poi `blocco_lanci: true` nel config: nessuna nuova creatività finché il cliente non dà il via.
- Non rispondere ai commenti e non preparare messaggi pubblici senza istruzioni del cliente.
- Alla ripresa: `blocco_lanci: false` e riattivazione graduale, con il sì.
