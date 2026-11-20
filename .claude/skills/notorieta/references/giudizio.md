# Notorietà: la scheda, le metriche e come si giudica

Le soglie sono in `<profilo>/cliente/config.yaml`, sezione `regole.notorieta`. Sono valori provvisori: si tarano sui dati dell'account. Qui c'è il ragionamento.

*In parte adattato da: meta-ads-mcp `meta-ads-video-analysis` (ByAds — Santiago Bastidas, MIT) per la lettura della curva di visione; ai-ads-claude `ads-funnel` (Zubair Trabzada, MIT) per l'elenco dei numeri da guardare sul pubblico nuovo; ai-maxxing-skills `media-buying` (Melvyn Malherbe, MIT) per l'ordine di lettura di un video. Il metodo della mediana e le regole sulle mosse sono di questo progetto.*

## La scheda

Una scheda in `prodotti` con `tipo: notorieta`. Non ha valore medio, margine, pareggio, CPA o ROAS: quei campi restano vuoti.

| Campo | Cosa contiene |
|---|---|
| `etichetta`, `nome`, `stato` | Come ogni scheda. L'etichetta va all'inizio dei nomi: `[NOTO] Bacino reel`. |
| `tipo` | `notorieta`. |
| `kpi` | `costo_per_risultato`. |
| `risultato`, `evento_conversione` | Restano vuoti: il risultato di queste schede sta in `notorieta.risultato`. |
| `budget_mensile` | Obbligatorio qui: è il vero limite di una campagna di notorietà. |
| `pubblico`, `zona`, `pubblico_dimensione` | Come ogni scheda. Con una zona locale `pubblico_dimensione` è `ristretto`. |
| `notorieta.zona_cerchio` | Solo per una zona a cerchio: centro e raggio inviati a Meta. Vuoto se si esce su tutto il paese. |
| `notorieta.risultato` | Il risultato principale: `follower`, `visualizzazione_completa`, `persona_raggiunta` o `visita_profilo`. |
| `notorieta.solo_instagram`, `posizioni_instagram` | Dove escono le inserzioni. Lista vuota = tutte le posizioni di Instagram. |
| `notorieta.costo_riferimento` | La mediana misurata sull'account del costo per il risultato principale. La calcola l'agent alla fine della misura. |
| `notorieta.costo_target` | L'obiettivo confermato dal cliente, dopo la misura. |
| `notorieta.misurato_il` | Data dell'ultima misura. |
| `notorieta.campagna_bacino_id`, `ad_set_bacino_id` | Dove si aggiungono i contenuti nuovi. |
| `notorieta.pubblici_esclusi` | ID dei pubblici personalizzati che il cliente ha creato per non mostrare i contenuti a chi li ha già visti. |

Una campagna si collega alla scheda come le altre: etichetta nel nome o ID nella lista `campagne` (vedi `.claude/skills/briefing/references/prodotti.md`).

**Una scheda per bacino.** Ogni scheda ha un solo risultato principale, un solo riferimento e un solo bacino. Se il cliente vuole provare due strade insieme, per esempio un bacino di visualizzazioni e uno di visite al profilo, sono due schede con due etichette (`VIDEO` e `PROFILO`, per dire) e due budget mensili. Così si confrontano senza mescolare i numeri.

## I numeri e da dove vengono

Tutti verificati con `ads_get_field_context` (elenco e date in `.claude/skills/briefing/references/campi-verificati.md`). Si leggono **a livello di inserzione**: ogni inserzione è un contenuto.

| Numero | Come si ottiene | Cosa dice |
|---|---|---|
| Persone raggiunte | `reach` | Quante persone diverse l'hanno visto |
| Frequenza | `frequency` | Quante volte a testa |
| Costo ogni 1.000 persone | `cpp` | Quanto costa farsi vedere |
| Riproduzioni | `video_play_actions` | Il video è partito. È il denominatore degli altri |
| **Aggancio** | `video_p25_watched_actions` ÷ `video_play_actions` | Quanti superano il primo quarto: l'inizio funziona? |
| **Tenuta** | `video_thruplay_watched_actions` ÷ `video_play_actions` | Quanti arrivano a 15 secondi o alla fine |
| Fine | `video_p100_watched_actions` ÷ `video_play_actions` | Quanti lo vedono tutto |
| Costo per visualizzazione completa | `cost_per_thruplay` | |
| Salvataggi ogni 1.000 persone | `post_save` ÷ `reach` × 1.000 | Lo trovano utile |
| Commenti, reazioni | `comment`, `post_reaction` | |
| **Follower dalle inserzioni** | `instagram_profile_follow_v2` | Chi ha iniziato a seguire, attribuito da Meta alle inserzioni |
| **Costo per follower** | `amount_spent` ÷ `instagram_profile_follow_v2` | Si calcola: non esiste un campo pronto |
| Visite al profilo | `results` di un gruppo ottimizzato per le visite al profilo | **Da verificare sull'account alla prima lettura**: non esiste un campo dedicato. Se `results` non torna, scrivi MANCANTE |
| Costo per visita al profilo | `amount_spent` ÷ visite al profilo | Solo per le campagne ottimizzate per le visite |

Limiti da ricordare:
- **Persone raggiunte e frequenza non si sommano.** La stessa persona può aver visto più contenuti: il totale di una campagna si legge con una lettura a livello di campagna, mai sommando le inserzioni.
- `3_second_video_plays` e `post_shares` esistono solo per account, campagna e gruppo, **non per inserzione**. Per il singolo contenuto l'aggancio si misura sul primo quarto del video, non sui 3 secondi.
- Aggancio e tenuta dipendono dalla durata: un video di 10 secondi arriva a un quarto in due secondi e mezzo, e la sua visualizzazione completa coincide con la fine. La mediana si calcola su tutti i contenuti misurati; la durata è un'avvertenza da scrivere accanto al verdetto ("corto: tenuta gonfiata dalla durata"). Solo quando ci sono almeno `reel_min_per_mediana` contenuti nella stessa fascia (sotto i 15 secondi, tra 15 e 45, oltre) si usa la mediana di fascia.
- Si leggono le **quote**, non i conteggi: "il 40% supera il primo quarto" è un'informazione, "12.000 riproduzioni" no.
- I follower sono quelli che Meta attribuisce alle inserzioni. La crescita totale del profilo è un altro numero, che il connettore non mostra.
- Con zero follower in un periodo il costo per follower non esiste: scrivi "nessun follower su <spesa> €", non un numero.
- **Il costo per follower si riporta sempre per ogni contenuto**, con spesa e follower accanto, anche quando il risultato principale è un altro. È un'informazione che il cliente vuole vedere; diventa un giudizio solo con abbastanza follower (vedi più sotto, "Con pochi follower").

## Le tre fasi

### 1. Misura

Dura `regole.notorieta.giorni_misura` giorni di spesa. In questa fase:
- si guardano solo consegna, ritmo del budget e problemi (rifiuti, spesa ferma, paese o posizioni sbagliati);
- si ordina la classifica dei contenuti, senza verdetti sui costi;
- nessuna mossa SPEGNERE o SCALARE basata sui costi.

**Con un budget piccolo la misura dura di più.** I giorni di `giorni_misura` bastano solo se nel frattempo i contenuti arrivano a `impression_min_per_reel`. Con pochi euro al giorno divisi tra più contenuti può non succedere: dillo al cliente all'inizio, e alla scadenza scrivi "misura ancora in corso: <n> contenuti su <m> hanno il campione", non un riferimento calcolato su pochi dati.

### 2. Riferimento

Alla fine della misura, per i contenuti con almeno `impression_min_per_reel` impression:
1. calcola la **mediana** di aggancio, tenuta, costo ogni 1.000 persone e costo per visualizzazione completa. La mediana, non la media: un contenuto fuori scala non deve spostare il riferimento;
2. se i contenuti con campione sufficiente sono meno di `reel_min_per_mediana`, scrivi "troppo presto" e allunga la misura;
3. proponi al cliente `costo_riferimento` e un `costo_target` uguale o poco sotto. Mostra i numeri su cui si basa: periodo, contenuti, spesa. Il riferimento dipende dal risultato principale:
   - `visualizzazione_completa` e `persona_raggiunta`: la mediana per contenuto del costo per visualizzazione completa, o del costo ogni 1.000 persone;
   - `follower` e `visita_profilo`: il costo **della campagna** nel periodo di misura (spesa ÷ follower, oppure spesa ÷ visite). Non la mediana per contenuto: molti contenuti hanno pochi follower o nessuno, e una mediana calcolata solo su quelli che ne hanno portati sarebbe troppo bassa e farebbe sembrare caro tutto il resto;
4. con il sì, scrivili nella scheda con `misurato_il` a oggi e la voce in `<profilo>/registro/decisioni.md`.

Le mediane si ricalcolano con la taratura della revisione settimanale (`regole.taratura`).

### 3. Giudizio

Per ogni contenuto, nell'ordine. Ci si ferma alla prima risposta negativa.

**Prima domanda: il video regge?**
- Aggancio e tenuta rispetto alla mediana dei contenuti di durata simile.
- Sotto `tenuta_sotto_mediana_x` × mediana su tutte e due: il contenuto non trattiene. Più budget non lo aggiusta.
- Come riferimento esterno, solo indicativo e solo per video oltre i 15 secondi: tenuta sotto `thruplay_min_pct`. La fonte non dice su quale base calcola la percentuale; qui è sulle riproduzioni. Non basta da sola per un verdetto.

| Dove cade | Cosa significa | Cosa fare |
|---|---|---|
| Crollo prima del primo quarto | L'inizio non ferma chi scorre | Un contenuto con un altro inizio |
| Calo regolare, metà ancora buona | Normale | Niente: guarda i costi |
| Crollo a metà | Parte centrale lenta, o la sostanza arriva tardi | Contenuti più corti, il punto prima |
| Molti arrivano alla fine, pochi seguono | Piace ma non dà un motivo per seguirti | Una chiusura che dica cosa trovano sul profilo |
| Regge, ma pochi salvataggi | Intrattiene, non è utile da tenere | Preferisci i contenuti "come si fa" |

**Seconda domanda: costa il giusto?**
- Costo per il risultato principale del contenuto rispetto a `costo_riferimento` (e a `costo_target`, se c'è).
- Con risultato `follower` o `visita_profilo` il confronto con il riferimento si fa **sulla campagna**. Il singolo contenuto si giudica sul costo per visualizzazione completa rispetto alla mediana dei contenuti, e i suoi follower si riportano come informazione.
- Oltre `costo_sopra_mediana_x` × riferimento: caro.
- Sotto `scalare_costo_sotto_mediana_x` × riferimento, con frequenza non in salita: candidato a ricevere più budget.

**Il verdetto**

| Verdetto | Quando |
|---|---|
| **POCO TESTATO** | Meno di `impression_min_per_reel` impression o meno di `giorni_min_per_reel` giorni attivo. Nessun giudizio. |
| **REGGE** | Tenuta nella norma, costo vicino al riferimento. Non si tocca. |
| **DA SCALARE** | Regge e costa meno del riferimento. Si propone più budget alla campagna, o contenuti simili. |
| **DEBOLE** | Non regge, oppure regge ma costa troppo. Si propone la pausa, se restano abbastanza contenuti attivi. |

Regole che valgono sempre:
- **Ordina per spesa.** Un contenuto con numeri ottimi e pochi euro spesi è poco testato, non migliore.
- **Meta sposta già la spesa.** In un bacino i contenuti deboli ricevono poco. Un contenuto che non spende non va "aiutato": va lasciato lì o sostituito.
- **Le ultime ore sono incomplete** per i follower come per le conversioni: escludi `regole.escludi_ultime_ore` ore dai giudizi.
- **Con pochi follower** vale la tabella del rumore di `.claude/skills/briefing/references/lettura-dati.md`: sotto circa 30 follower per contenuto si leggono solo differenze di circa 2 volte. In quel caso giudica il contenuto su tenuta e costo per visualizzazione completa, e i follower a livello di campagna.

## La stanchezza di un bacino

Una creatività di vendita è stanca quando calano i clic. Un bacino di notorietà è stanco quando **parla sempre alle stesse persone**:
- le persone raggiunte smettono di crescere a spesa uguale (confronta gli ultimi 7 giorni con i 7 precedenti);
- la frequenza sale oltre `regole.fatica.crescita_frequenza_pct` (su un pubblico `ristretto`, come una zona locale, una frequenza alta è il punto di partenza normale: conta la salita, non il livello);
- aggancio e tenuta calano sugli stessi contenuti.

Con tutti e tre i segnali servono contenuti nuovi o un pubblico più ampio, non più budget. La frequenza alta da sola non basta: su un pubblico ristretto è normale.

## Semaforo nel briefing e nel report

Una campagna di notorietà si riporta così:
- **durante la misura**: "in misura, giorno <n> di <giorni_misura>", senza semaforo;
- **con il riferimento**: 🟢 costo per risultato entro il target · 🟡 tra il target e `costo_sopra_mediana_x` × riferimento · 🔴 oltre;
- **sempre**: spesa contro `budget_mensile`, persone raggiunte, follower dalle inserzioni, numero di contenuti attivi contro `reel_attivi_min`.
