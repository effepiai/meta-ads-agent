# Leggere i dati senza farsi ingannare

Regole per il briefing, gli interventi e la revisione. Le soglie numeriche stanno in `<profilo>/cliente/config.yaml`; qui c'è il ragionamento. Il target di una campagna è quello del **suo prodotto** (schede `prodotti`, regole in `prodotti.md`).

*Adattato da: goose-skills `reading-results.md` (GooseWorks, MIT), marketingskills `operating-check.md` e `audit-guardrails.md` (Corey Haines, MIT), markifact-mcp `diagnose-underperformer` (Markifact, MIT).*

## Le regole di base

1. **Confronta periodi uguali.** Stessa durata e stessa finestra di attribuzione (predefinita: 7 giorni dal clic, 1 giorno dalla visualizzazione). Non sommare mai conversioni Meta con quelle di altri strumenti che hanno finestre diverse.
2. **Gli ultimi giorni sono incompleti.** Le conversioni arrivano in ritardo: per giudicare vincenti e perdenti escludi le ultime `regole.escludi_ultime_ore` ore. Ieri serve per spesa e ritmo, non per giudicare il CPA.
3. **Il rumore.** L'incertezza di un risultato è circa 1 ÷ √(numero di conversioni):

   | Conversioni | Incertezza circa |
   |---|---|
   | 5 | ±45% |
   | 10 | ±32% |
   | 30 | ±18% |
   | 100 | ±10% |

   Sotto `campione_minimo.conversioni_per_lettura_fine` conversioni si leggono solo differenze di circa 2 volte. Un CPA doppio su 6 conversioni è rumore, non un verdetto.
4. **ROAS di pareggio** = 100 ÷ margine di contribuzione % del prodotto. Con margine 30% → pareggio 3,33: un ROAS di 3 perde soldi anche se "sembra buono".
5. **Ordina per spesa.** Un'inserzione con CTR altissimo ma pochi euro spesi è *poco testata*, non migliore.
6. **L'effetto breakdown.** Spegnere l'inserzione con il CPA medio più alto spesso fa salire il CPA complessivo, perché Meta le stava dando solo il traffico più economico. Prima di spegnere guarda il costo dei risultati in più, non la media.
7. **Le modifiche recenti spiegano molto.** Ogni variazione va incrociata con lo storico delle modifiche. Un calo dopo un cambio di budget o di creatività è quasi sempre il learning che riparte.
8. **Learning.** Per uscirne servono circa 50 eventi di ottimizzazione per gruppo di inserzioni in 7 giorni. Il budget necessario è circa CPA del prodotto × 50 ÷ 7 al giorno: con CPA 20 € servono circa 143 €/giorno. Con un budget più basso, il gruppo resterà spesso in "learning limitato", e va detto al cliente.
9. **Benchmark.** Fonti in ordine di affidabilità: storico dello stesso account → test propri → dati del CRM del cliente → benchmark di Meta (`ads_insights_performance_vs_peers`, `ads_insights_industry_benchmark`) → medie di settore. Le medie di settore sono solo un'indicazione.

## La fatica delle creatività

**La frequenza da sola non dice nulla.** La frequenza è quante volte in media una persona ha visto l'inserzione. Su un pubblico enorme che si rinnova di continuo (per esempio il fitness in tutta Italia) resta bassa anche con budget alti. Su un pubblico piccolo (un negozio locale, chi compra barche, gli architetti di una provincia) arriva presto a 3 o 4, e può andare benissimo. Si giudica quindi il **trend dei risultati**, confrontando gli ultimi 7 giorni con i 7 precedenti (oppure 14 con 14), escluse le ultime `regole.escludi_ultime_ore` ore.

Una creatività è **stanca** quando tutte e tre queste cose sono vere:
- il **CTR cala** oltre `fatica.calo_ctr_pct`;
- il **costo per risultato sale** oltre `fatica.aumento_costo_risultato_pct`. Con poche conversioni (sotto `campione_minimo.conversioni_per_lettura_fine`) al suo posto si guarda il CPC, cioè il costo per clic;
- la **frequenza sale** di oltre `fatica.crescita_frequenza_pct` rispetto al periodo precedente dello stesso gruppo: le stesse persone la stanno rivedendo.

Se peggiorano CTR e costi ma la frequenza è stabile, non è fatica: guarda offerta, landing, concorrenza (CPM in salita) o stagionalità.

**La soglia di frequenza serve solo a mettere "sotto osservazione".** Sopra `frequenza_freddo_attenzione` (pubblico nuovo) o `frequenza_retargeting_attenzione` (retargeting) l'inserzione si segnala come "da guardare", senza nessuna mossa. Si usano le soglie della scheda del prodotto, se ci sono (campo `fatica` della scheda), altrimenti quelle di `regole.fatica`. Un'inserzione con frequenza alta e risultati stabili o in miglioramento **non è stanca e non si tocca**.

Una creatività per pubblico nuovo vive tipicamente 2-4 settimane. Altri segnali: copertura che smette di crescere mentre la spesa resta uguale, CPM in salita oltre il 30% in 2 settimane.

## Albero diagnostico per una campagna che rende poco

Confronta gli ultimi 14 giorni con i 14 precedenti, escludendo gli ultimi 3 giorni.

**Prima regola:** un'entità con meno di `giorni_learning_non_toccare` giorni, o modificata da poco, è "in learning". La diagnosi è *aspettare*.

**A. Non spende o spende poco**
- Inserzioni in revisione o rifiutate.
- Pubblico troppo piccolo.
- Troppi gruppi di inserzioni nella stessa campagna CBO (oltre 4). CBO significa che il budget lo distribuisce Meta tra i gruppi.
- Spesa molto sotto il budget.
- Metodo di pagamento o limite di spesa.
- Al giorno 7, un'inserzione che ha speso meno di `consegna_giorno_7_min_quota` × la sua quota (budget ÷ numero di inserzioni × 7) non sta ricevendo spesa.

**B. Spende ma pochi cliccano (CTR basso)**
- Fatica (vedi sopra).
- CTR nel feed molto basso rispetto allo storico dell'account: problema dell'hook o dell'offerta.
- Hook rate basso: il problema è nei primi 3 secondi.

**C. Cliccano ma non convertono**
- Il problema è la landing o l'offerta: velocità, coerenza con l'inserzione, prezzo, mobile.
- Controlla il tracciamento: l'evento si registra? Ci sono conversioni negli ultimi 7 giorni?
- Conversione da mobile molto peggiore del desktop: problema della pagina mobile.

**D. Va bene, ma il budget lo frena**
- CPA sotto target, budget esaurito ogni giorno: opportunità di scalare. Si fa a passi di `aumento_max_per_passo_pct`.
- Frequenza in salita su un pubblico piccolo **con risultati in calo**: il pubblico è esaurito e servono pubblico o creatività nuovi. Con risultati stabili, una frequenza alta è normale per quel pubblico.

**E. Peggiorata all'improvviso**
- Strategia di offerta cambiata, budget tagliato di oltre il 30%, creatività sostituita da poco.
- Stagionalità, concorrenza (CPM in salita), problema del sito.

Riporta al massimo **3 diagnosi**, ciascuna con la prova (i numeri) e il prossimo passo.

## Hook e fasi del video: cosa cambiare

| Dove cade | Cosa significa | Cosa cambiare |
|---|---|---|
| Pochi guardano 3 secondi (hook rate basso) | L'inizio non ferma lo scroll | Immagine iniziale, prima frase, testo a schermo |
| Guardano 3 secondi ma non arrivano a 15 | L'hook promette, il seguito non mantiene | Il corpo del video, il ritmo |
| Guardano ma non cliccano (CTR basso) | L'offerta o la chiamata all'azione non convince | Offerta, prova, CTA |
| Cliccano ma non comprano | Non è un problema dell'inserzione | Landing, prezzo, tracciamento |
