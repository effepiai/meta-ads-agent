# Le mosse e quando usarle

Le soglie sono in `<profilo>/cliente/config.yaml` (sezioni `regole` e `budget`). Qui c'è la logica. CPA target = `cpa_target` della scheda del **prodotto** della campagna (vedi `.claude/skills/briefing/references/prodotti.md`). Se il `kpi` del prodotto è il ROAS, ragiona con il suo `roas_target`: "sopra target" significa ROAS più basso del target.

Una campagna **senza prodotto** non riceve mosse basate sui costi (SPEGNERE per CPA, SCALARE): prima si collega a una scheda. Restano possibili SISTEMARE, RUOTARE e ASPETTARE.

Le campagne di **notorietà** (scheda con `tipo: notorieta`) hanno regole proprie: vedi la sezione "Campagne di notorietà" più sotto.

*Adattato da: goose-skills `moves.md` e `meta-levers.md` (GooseWorks, MIT), marketingskills `meta-decision-system.md` (Corey Haines, MIT), markifact-mcp `safe-write-operations` e `rotate-creative` (Markifact, MIT).*

## SPEGNERE (mettere in pausa)

Si propone quando, fuori dal learning e con le ultime 72 ore escluse:
- **zero conversioni** dopo aver speso `spegnere.senza_conversioni_dopo_x_cpa` × CPA target;
- **oppure** CPA oltre `spegnere.cpa_oltre_x_target` × target dopo aver speso `spegnere.dopo_spesa_x_cpa` × CPA target;
- **oppure** al giorno 7 l'inserzione non ha ricevuto spesa: sotto `consegna_giorno_7_min_quota` della sua quota.

Non si spegne:
- un'inserzione che converte ancora sotto target, anche se è stanca: prima la si sostituisce;
- l'unica inserzione attiva di un gruppo, senza un sostituto;
- in base al solo CPA medio: guarda l'effetto breakdown in `.claude/skills/briefing/references/lettura-dati.md`.

## SCALARE (aumentare il budget)

Si propone quando:
- il CPA è sotto `scalare.cpa_max_x_target` × target, con un campione sufficiente;
- il budget si esaurisce ogni giorno (`budget_remaining` vicino a zero);
- il gruppo è fuori dal learning e non è stato toccato negli ultimi `scalare.giorni_tra_aumenti` giorni.

Come:
- al massimo +`aumento_max_per_passo_pct`% per passo, e mai oltre il doppio in un passo;
- un aumento ogni `giorni_tra_aumenti` giorni;
- non si scala mentre il ROAS del prodotto è sotto il suo pareggio.

Fare marcia indietro: se dopo un aumento il CPA supera 1,5 × target, si propone di tagliare del 20-30%.

## ASPETTARE

È la mossa giusta più spesso di quanto sembri:
- il gruppo è in learning, o è stato modificato negli ultimi `giorni_attesa_dopo_modifica` giorni;
- ha speso meno di 1 × CPA target;
- il dato è sotto il campione minimo.

Ogni "aspettare" ha **una data** in cui si ridecide e **un allarme**, per esempio "se spende 3 × CPA senza conversioni, si spegne prima".

## RUOTARE (sostituire creatività stanche)

Si propone quando:
- c'è fatica (vedi `lettura-dati.md`): CTR in calo, costo per risultato in salita **e** frequenza in salita rispetto al periodo precedente. Una frequenza alta con risultati stabili non è un motivo per ruotare;
- **oppure** il CTR scende da 2-3 settimane a spesa costante.

Come:
1. si preparano 2 varianti per ogni inserzione stanca con `/creativita`;
2. si pubblicano in pausa con `/pubblica`;
3. si attivano;
4. **solo dopo** si mette in pausa l'originale.

Tieni sempre almeno `creativita.concept_in_test_min` idee nuove in test.

## SISTEMARE

Problemi con una soluzione nota: inserzione rifiutata, budget esaurito per errore, link rotto, offerta scaduta, prodotto esaurito. Per i casi gravi usa `/emergenza`.

## Campagne di notorietà

Per le campagne di una scheda con `tipo: notorieta` le soglie sopra, basate sul CPA, **non si applicano**. Valgono quelle di `regole.notorieta`, con il giudizio di `.claude/skills/notorieta/references/giudizio.md`. "Contenuto" qui significa un'inserzione che promuove un post o un reel.

- **Durante la misura** (scheda senza `costo_riferimento`): solo SISTEMARE e ASPETTARE. Nessuna pausa e nessun aumento basati sui costi.
- **SPEGNERE un contenuto**: verdetto DEBOLE dopo il campione minimo (`impression_min_per_reel`, `giorni_min_per_reel`), cioè aggancio e tenuta sotto `tenuta_sotto_mediana_x` × mediana, oppure costo per risultato oltre `costo_sopra_mediana_x` × riferimento. Non si spegne se i contenuti attivi scenderebbero sotto `reel_attivi_min`: prima se ne attiva uno nuovo.
- **SCALARE la campagna**: costo per risultato sotto `scalare_costo_sotto_mediana_x` × riferimento, persone raggiunte ancora in crescita, frequenza non in salita. Stessi passi di sempre: al massimo +`aumento_max_per_passo_pct`% ogni `giorni_tra_aumenti` giorni, mai oltre il `budget_mensile` della scheda.
- **Non si scala** per compensare contenuti deboli, né quando le persone raggiunte sono ferme: lì servono contenuti nuovi.
- **RUOTARE**: quando il bacino è stanco (persone raggiunte ferme a spesa uguale, frequenza in salita, aggancio e tenuta in calo), oppure a ritmo regolare (`nuovi_reel_a_settimana`). I contenuti si scelgono con `/notorieta`. Aggiungere contenuti fa ripartire il learning del gruppo: si aggiungono insieme, non uno al giorno.
- **Fare marcia indietro**: se dopo un aumento il costo per risultato supera `costo_sopra_mediana_x` × riferimento, si propone di tornare al budget precedente.
- **Un reel spinto da solo** (una campagna per reel) ha una data di fine: di solito la mossa giusta è lasciarlo finire. Si ferma prima solo per un problema (rifiuto, commenti da gestire, paese o posizioni sbagliati).

## Le modifiche che fanno ripartire il learning (circa 7 giorni)

- Budget cambiato di oltre il 20% in un colpo.
- Pubblico cambiato in modo significativo (oltre il 10% circa).
- Posizionamenti cambiati.
- Evento di ottimizzazione o strategia di offerta cambiati.
- Nuova creatività aggiunta, oppure creatività principale sostituita.
- Gruppo rimesso in pausa e poi riattivato dopo più di 7 giorni.

Ogni volta che una mossa ne include una, scrivilo nel campo "Rischio".

## Il ritmo

- **Al massimo una modifica significativa per gruppo di inserzioni a settimana.** Dopo una modifica, il gruppo è "congelato" finché l'effetto non è leggibile.
- **Un sì, una modifica.** Il sì deve nominare oggetto e valore nuovo.
- **Prima di applicare, rileggi l'oggetto.** Se nel frattempo è cambiato (per esempio l'ha modificato qualcun altro), fermati e riproponi.
- **Ritmo di spesa**: tolleranza ±10% sul budget massimo mensile. Oltre, si propone una correzione.
