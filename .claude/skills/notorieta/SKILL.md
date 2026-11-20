---
name: notorieta
description: Campagne Meta Ads per farsi conoscere, senza un costo per contatto o per vendita da inseguire. Fa crescere copertura, visualizzazioni dei video e follower Instagram promuovendo i post e i reel già pubblicati. Crea e gestisce la scheda di notorietà, sceglie i contenuti da promuovere, prepara le campagne (un reel spinto da solo, un bacino di contenuti, visite al profilo), le giudica sulla tenuta del video e sul costo rispetto alla mediana dell'account, e propone cosa spegnere, scalare o aggiungere. Usala col comando /notorieta, o quando il cliente dice "voglio farmi conoscere", "più follower", "spingi questo reel", "sponsorizza i miei contenuti", "campagna di notorietà", "copertura", "traffico verso il profilo", "visite al profilo", "solo Instagram", "solo nella mia zona", "come vanno i reel sponsorizzati". Ha un percorso rapido per chi parte da zero e vuole solo questo.
---

# Notorietà

Qui il risultato non è un contatto né una vendita: è **quante persone nuove vedono i contenuti, quante li guardano davvero e quante poi seguono il profilo**. Per questo le regole su margine, pareggio e CPA non si applicano. Valgono invece tutte le regole d'oro di `AGENTS.md`: un sì per ogni modifica, tutto nasce in pausa, mai cancellare, budget con prudenza.

Prima leggi:
- `<profilo>/cliente/config.yaml`: fase, `blocco_lanci`, `budget`, `regole.notorieta` e le schede `prodotti` con `tipo: notorieta`;
- `<profilo>/cliente/brand-profile.md`;
- `<profilo>/registro/decisioni.md`, `creativita.md` e `lezioni.md`;
- `references/giudizio.md`: la scheda, le metriche e le regole per giudicare;
- `references/campagne.md`: i nomi di Gestione inserzioni, i tre tipi di campagna, la zona locale e i parametri verificati sul connettore;
- `references/rotazione.md`: quali contenuti scegliere e come farli ruotare.

In `sola_lettura` o con `blocco_lanci: true` si lavora lo stesso, ma solo su scheda, scelta dei contenuti, piano e giudizio. Nessuna scrittura su Meta.

## 0. Cosa vuole il cliente

Capisci quale di questi lavori serve e salta agli altri solo se servono:

| Il cliente dice | Passo |
|---|---|
| "Voglio farmi conoscere", prima volta | 1, poi 2 e 3 |
| Lo stesso, ma il profilo non ha ancora fatto l'onboarding | "Percorso rapido" qui sotto, poi 1, 2 e 3 |
| "Voglio una campagna Notorietà / Traffico / Interazioni / Copertura" | Traduci con la tabella "I nomi di Gestione inserzioni" di `references/campagne.md`, poi 1 |
| "Spingi questo reel", "quali reel promuovo?" | 2, poi 3 |
| "Come stanno andando?", "cosa spengo?" | 4, poi 5 |
| "Aggiungi i reel nuovi" | 2, poi 3 (aggiunta al bacino) |

Il cliente spesso usa i nomi che vede in Gestione inserzioni (Notorietà, Traffico, Interazioni, Copertura). Non correggerlo: ripeti la sua parola e accanto il risultato, per esempio "Traffico verso il profilo Instagram, cioè visite al profilo".

## Percorso rapido: solo farsi conoscere, senza onboarding completo

Per chi ha appena installato l'agent e vuole soltanto promuovere i suoi contenuti. Vale quando `onboarding_completato` è `false`. Margini, CPA, pixel, brand e design system qui non servono: si saltano e si faranno con `/onboarding` il giorno in cui servirà una campagna di vendita.

1. **Dillo subito**: "Facciamo il percorso breve: poche domande e prepariamo la campagna. Il resto dell'onboarding lo completiamo quando ti servirà."
2. **Account** (in sola lettura): `ads_get_ad_accounts`. Se il connettore ne vede più di uno, chiedi quale. Scrivilo in `meta.account_pubblicitari`. Segnala se manca il metodo di pagamento: senza, la campagna si prepara ma non parte, e lo aggiunge il cliente in Gestione inserzioni.
3. **Instagram e pagina**: `ads_get_ig_accounts` e il `page_id` abbinato. Scrivili in `meta.instagram_id` e `meta.pagina_facebook_id`.
4. **Il minimo sull'azienda**: nome, paese, lingua (`cliente.nome`, `paesi`, `lingua_annunci`) e se il settore è una categoria speciale.
5. **La scheda**: passo 1 qui sotto.
6. **Il tetto**: `budget.massimo_mensile`, che non si supera mai. Può coincidere con il `budget_mensile` della scheda.
7. **Segna il percorso**: `onboarding_rapido: true` nel config. `onboarding_completato` resta `false`.
8. **La fase.** Un profilo nuovo è in `sola_lettura`, e in sola lettura si prepara tutto tranne la creazione: scheda, contenuti e piano. Quando il piano è pronto spiega la scelta in due righe: restare in sola lettura e creare la campagna a mano in Gestione inserzioni seguendo il piano, oppure passare a `gestione_con_conferma`, dove l'agent crea e attiva ma solo con un sì per ogni passaggio. **Non proporre il passaggio come scontato e non farlo da solo**: serve una frase esplicita del cliente ("passiamo alla gestione con conferma"). Con quella, cambia `fase` nel config e scrivilo in `<profilo>/registro/decisioni.md` con la data e le sue parole.

Finché il profilo ha solo il percorso rapido: funzionano `/notorieta`, `/briefing`, `/interventi` e `/revisione-settimanale` sulle schede di notorietà. Per `/lancio-campagna`, `/creativita`, `/pubblica` e `/audit-mensile` serve prima l'onboarding completo: dillo e proponilo.

## 1. La scheda di notorietà

Una scheda in `prodotti` con `tipo: notorieta`, come spiega `references/giudizio.md`. Se esiste già, mostrala in 3-5 righe con la data di `aggiornato_il` e chiedi se vale ancora. Se non esiste, chiedi solo questo:

1. **Cosa conta di più**: nuovi follower, persone che guardano i video fino in fondo, persone raggiunte, oppure visite al profilo. Uno solo è il risultato principale; gli altri si riportano comunque.
2. **Dove**: solo Instagram, oppure anche Facebook. Se solo Instagram, in quali posizioni (tutte, oppure solo alcune).
3. **A chi**: tutto il paese oppure una zona (una città e fin dove arrivare), lingua, eventuali limiti di età detti dal cliente. Per una zona si usa un cerchio: regole in `references/campagne.md`, "Zona locale". Con una zona il pubblico è ristretto: `pubblico_dimensione: ristretto`, e spiega al cliente che vedrà frequenze più alte e che è normale.
4. **Quanto**: budget giornaliero o totale con le date, e il massimo mensile per la notorietà. Non dedurlo: chiedi. Con pochi euro al giorno di' due cose: si parte con pochi contenuti (`reel_attivi_min`) e la misura può durare più di `giorni_misura`.
5. **Etichetta**: breve e maiuscola, per esempio `NOTO`. Va all'inizio dei nomi di campagne, gruppi e inserzioni.

**Non chiedere e non inventare un costo obiettivo.** Nella scheda `costo_riferimento` e `costo_target` restano vuoti: si misurano sull'account (passo 4). Salva la scheda, con `aggiornato_il` a oggi, prima di proseguire.

Controlla anche, in sola lettura:
- l'account con `ads_get_ad_accounts` (attivo, metodo di pagamento, `min_daily_budget_cents`);
- l'account Instagram con `ads_get_ig_accounts` e la pagina Facebook abbinata (`page_id` nella risposta). Senza pagina abbinata chiedi al cliente quale usare: non sceglierne una a caso;
- se l'account appartiene a un business. Se no, per l'Unione Europea servono dal cliente i nomi di chi paga e di chi beneficia delle inserzioni (`references/campagne.md`, "Il pubblico").

## 2. Scegli i contenuti

Segui `references/rotazione.md`. In breve:

1. Leggi i contenuti promuovibili con `ads_get_ig_media` (l'account pubblicitario del profilo e l'account Instagram della scheda). Si possono filtrare per tipo, per esempio solo i reel.
2. Togli quelli già promossi (`<profilo>/registro/creativita.md`) e quelli che non parlano a chi non ti conosce.
3. Ordina i rimasti con i segnali che hai: like e commenti dal connettore, più quello che il cliente sa dalle statistiche di Instagram (salvataggi, condivisioni, visualizzazioni), che il connettore non mostra per i post non sponsorizzati.
4. Proponi una rosa con un motivo per ciascuno. Per un bacino: da `regole.notorieta.reel_attivi_min` a `reel_attivi_max` contenuti.

Il cliente sceglie. I contenuti si promuovono **così come sono**: testo, video e commenti restano quelli del post originale.

Per ogni contenuto scelto, due domande che vanno fatte adesso e non a metà creazione:
- **È fatto o modificato con l'AI?** La dichiarazione si decide per contenuto e dopo la creazione non si cambia.
- **Chiude con un invito a commentare** ("commenta X e ti mando…")? Sponsorizzarlo porta commenti nuovi sul post originale, da persone che si aspettano la risposta. Se le risposte sono automatiche, va verificato **prima dell'attivazione** che l'automatismo copra anche quel post: vedi `references/rotazione.md`, "La chiamata all'azione che c'è già nel post".

## 3. Prepara e crea la campagna

Scegli il tipo con il cliente (dettagli e parametri in `references/campagne.md`):

| Tipo | Quando | Come si crea |
|---|---|---|
| **Spingi un reel** | Un contenuto sta andando bene da solo e lo si vuole far girare subito, per pochi giorni | Una campagna per quel reel |
| **Bacino di contenuti** | Lavoro di base, sempre acceso: tanti contenuti nello stesso gruppo, Meta sposta la spesa sui migliori | Una campagna, un gruppo, un'inserzione per contenuto |
| **Visite al profilo** | Il risultato principale sono i follower | Come il bacino, ottimizzato per le visite al profilo |

Una scheda ha un solo bacino. Per provare insieme un bacino di visualizzazioni e uno di visite al profilo servono due schede con due etichette: così i loro costi per follower si confrontano senza mescolarsi.

Poi:

1. **Piano (primo sì).** Una tabella con:
   - nomi con l'etichetta, e il tipo;
   - obiettivo con **il nome di Gestione inserzioni e il risultato** ("Traffico verso il profilo Instagram: visite al profilo"), e l'ottimizzazione;
   - budget in euro e date, e quanto fa al mese;
   - paese o zona (per un cerchio: centro, raggio, località comprese, eventuale sconfinamento in un altro stato);
   - posizioni;
   - contenuti, con il link al post e per ognuno la **dichiarazione AI** scelta dal cliente;
   - pubblici esclusi;
   - per l'Unione Europea, i nomi di chi paga e di chi beneficia, se l'account non ha un business;
   - **quante creazioni servono e in quante conferme** (2 + 2 × contenuti, al massimo `budget.modifiche_max_per_conferma` per conferma);
   - cosa succede alla spesa.

   Di' chiaramente che tutto nasce in pausa. **Se `meta.modalita_bozza` è `si` o `sconosciuta`, avvisa già qui**: su alcuni account gli oggetti nascono in bozza, e in quel caso pubblicare vuol dire attivare.
2. **Creazione in pausa.** Segui `references/campagne.md`, senza saltare i controlli. Procedi nei lotti annunciati nel piano, con un sì per lotto.
3. **Rilettura.** Rileggi con `ads_get_ad_entities` (in modalità bozza con `object_state: draft`, ogni oggetto col suo ID). Controlla soprattutto paese o zona, posizioni e budget: sono i valori che il connettore riempie da solo se mancano. Per le anteprime manda il cliente in Gestione inserzioni: i link di `ads_get_ad_preview` sono troppo lunghi per la chat.
4. **Attivazione (secondo sì).** Riepilogo di cosa parte, quanto spende al giorno e fino a quando. Prima controlla le questioni rimaste aperte: metodo di pagamento, risposte ai commenti dei contenuti con invito a commentare. Poi come in `/lancio-campagna`, passo 4; in modalità bozza come in `references/campagne.md`, "Modalità bozza".
5. **Registro.** In `<profilo>/registro/decisioni.md` il lancio, con verifica al giorno 7 (consegna) e alla fine della misura. In `<profilo>/registro/creativita.md` una riga per contenuto, tipo "post esistente", con l'ID del post, l'ID dell'inserzione ed esito "in test". Nella scheda: gli ID della campagna e del gruppo del bacino.

## 4. Giudica

Segui `references/giudizio.md`. I dati si leggono a livello di inserzione, perché ogni inserzione è un contenuto.

- **Durante la misura** (i primi `regole.notorieta.giorni_misura` giorni di spesa): solo consegna, ritmo del budget e classifica dei contenuti. Nessun giudizio sui costi.
- **Alla fine della misura**: calcola le mediane dell'account, proponi `costo_riferimento` e un `costo_target`, e falli confermare. È una modifica al file di configurazione, non a Meta.
- **Dopo**: per ogni contenuto le due domande, nell'ordine. Il video regge? Costa il giusto? Poi un verdetto: POCO TESTATO, REGGE, DA SCALARE, DEBOLE.

Scrivi il risultato così:

```
## Notorietà [ETICHETTA] — <periodo>
**In sintesi:** <una frase>

Spesa <x> € di <budget> · persone raggiunte <n> · costo ogni 1.000 persone <x> € · frequenza <x> (letti sulla campagna: non si sommano i contenuti)
Follower dalle inserzioni <n> · costo per follower <x> € (riferimento <x> €)
Visite al profilo <n> · costo per visita <x> € (solo per le campagne ottimizzate per le visite)

| Contenuto | Spesa | Persone | Aggancio | Tenuta | Salvataggi ogni 1.000 | Follower | Costo per follower | Costo per <risultato> | Verdetto |

Fatti · Ipotesi · MANCANTE
```

**Il costo per follower si mostra sempre, per ogni contenuto**, qualunque sia il risultato principale della scheda, con la spesa e il numero di follower nella stessa riga: è spesa ÷ follower di quel contenuto. Con zero follower si scrive "nessuno su <spesa> €", non un numero. Nelle campagne di visite al profilo "Costo per <risultato>" è il costo per visita. Con pochi follower per contenuto il numero si riporta ma non si giudica (vedi `references/giudizio.md`).

## 5. Proponi le mosse

Le mosse sono in `.claude/skills/interventi/references/mosse.md`, sezione "Campagne di notorietà". Si presentano e si applicano come in `/interventi`: una alla volta, con motivo, rischio, come tornare indietro e data di verifica.

Tre attenzioni proprie di queste campagne:
- **Si spegne un contenuto solo se ne resta un numero sufficiente attivo** (`reel_attivi_min`). Altrimenti prima se ne aggiunge uno nuovo.
- **Non si scala per coprire un contenuto debole**: prima si cambia il contenuto.
- **Nuovi contenuti a ritmo regolare** (`nuovi_reel_a_settimana`): un bacino che non riceve contenuti nuovi parla sempre alle stesse persone.

## Cosa non si può fare, e va detto al cliente

- **Non esiste un'ottimizzazione "per follower".** Meta ottimizza per visite al profilo, visualizzazioni o copertura; i follower si misurano dopo.
- **I follower sono quelli che Meta attribuisce alle inserzioni**, non la crescita totale del profilo.
- **Le visite al profilo non sono un numero leggibile da solo**: si leggono come risultato di una campagna ottimizzata per le visite.
- **I pubblici personalizzati** (per esempio "chi ha già visto i miei video") li crea il cliente in Gestione inserzioni: l'agent non può crearli, li usa soltanto.
- **Commenti e messaggi** non si leggono: si vede quanti sono, non cosa dicono.
