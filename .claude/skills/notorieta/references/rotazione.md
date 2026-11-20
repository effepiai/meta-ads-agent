# Notorietà: quali contenuti scegliere e come farli ruotare

Le regole di questo file sono scritte per questo progetto. Sono punti di partenza, non verità: ogni account le conferma o le smentisce con i suoi numeri, e quello che si impara va in `<profilo>/registro/lezioni.md`.

## Chi li vedrà

Una campagna di notorietà mostra i contenuti a persone che **non conoscono il cliente e non lo stavano cercando**. Un contenuto adatto:
- si capisce senza aver visto nient'altro del profilo;
- dice di cosa parla nei primi secondi, anche senza audio (testo a schermo, sottotitoli);
- dà qualcosa subito: un'informazione, una dimostrazione, un punto di vista;
- fa capire chi è la persona e perché vale la pena seguirla.

Non adatti, anche se sono piaciuti ai follower:
- contenuti che rimandano ad altri ("come dicevo ieri…");
- annunci, auguri, dietro le quinte senza contesto;
- contenuti legati a una data o a un'offerta già scaduta;
- contenuti con musica, marchi o persone per cui il cliente non ha i diritti di sponsorizzazione.

## Come scegliere

1. **Parti da quello che ha già funzionato da solo.** Un contenuto che ha raccolto più reazioni, commenti, salvataggi e condivisioni della media del profilo ha più probabilità di reggere anche a pagamento. È un'ipotesi ragionevole, non una garanzia.
2. **Usa i segnali che hai, e di' quali mancano.**
   - Dal connettore (`ads_get_ig_media`): testo, tipo, data, like e commenti.
   - Dal cliente (statistiche di Instagram): visualizzazioni, salvataggi, condivisioni, nuovi follower per contenuto. Il connettore non li mostra per i post non sponsorizzati: chiedili, oppure scrivi MANCANTE.
3. **Confronta ogni contenuto con la mediana del profilo**, non con numeri assoluti. Venti commenti sono tanti per un profilo e pochi per un altro.
4. **Varia.** In un bacino metti argomenti e inizi diversi. Cinque contenuti sullo stesso tema si rubano il pubblico a vicenda e non dicono cosa funziona.
5. **Tieni conto della durata.** Segna la fascia di ogni contenuto (sotto i 15 secondi, 15-45, oltre): il giudizio confronta tra loro contenuti di durata simile.

Per ogni contenuto proposto, una riga:

```
- <data> · <titolo breve> · <durata> · <like> like, <commenti> commenti (mediana del profilo: <n>) · perché: <motivo> · <link>
```

## La chiamata all'azione che c'è già nel post

Molti contenuti chiudono con "commenta X e ti mando…". Promuoverli porta commenti da persone nuove, e chi commenta si aspetta la risposta.
- I commenti arrivano **sul post originale**, non su una copia: chi commenta dall'inserzione finisce insieme agli altri.
- Chiedi al cliente se le risposte sono automatiche o manuali, e se regge il volume in più.
- **Se sono automatiche, va verificato prima dell'attivazione.** Molti automatismi (uno strumento di risposta ai commenti, un flusso costruito in casa) seguono solo i post recenti, o solo quelli scelti a mano: un reel di due mesi fa può non essere più coperto, e chi commenta non riceve niente. Chiedi al cliente di controllare nel suo strumento che ogni contenuto promosso con un invito a commentare sia seguito, e che il materiale promesso esista ancora. L'agent non può controllarlo da solo: finché il cliente non conferma, quel contenuto resta fuori dall'attivazione oppure parte con l'avvertenza scritta nel piano e nel registro.
- I commenti si contano (`comment`), ma l'agent non li legge e non risponde.
- Se la promessa del post non è più valida (materiale ritirato, offerta scaduta), il contenuto non si promuove.

## Il ritmo del bacino

- **Quanti attivi**: tra `reel_attivi_min` e `reel_attivi_max`.
- **Quanti nuovi**: circa `nuovi_reel_a_settimana` a settimana, aggiunti insieme in un giorno fisso, non uno al giorno: ogni aggiunta fa ripartire il learning del gruppo.
- **Chi esce**: i contenuti con verdetto DEBOLE, dopo il campione minimo. Prima entra il nuovo, poi esce il vecchio.
- **Chi resta**: un contenuto che regge può restare per settimane. Non si toglie perché è vecchio: si toglie quando calano aggancio e tenuta e sale la frequenza.
- **Dove si scrive**: ogni contenuto entrato o uscito in `<profilo>/registro/creativita.md`, con l'esito.

## Non mostrare due volte lo stesso contenuto

Con un pubblico ampio e pochi euro al giorno il problema è piccolo: la frequenza resta bassa. Diventa reale quando il pubblico è ristretto o il budget cresce. Tre strade, dalla più semplice:

1. **Contenuti nuovi a ritmo regolare.** È quasi sempre sufficiente.
2. **Escludere chi segue già o ha già interagito.** Il cliente crea in Gestione inserzioni un pubblico personalizzato dalle interazioni con l'account Instagram e ne dà l'ID. Va in `notorieta.pubblici_esclusi`. Quali pubblici si possono creare dipende da cosa offre Gestione inserzioni in quel momento: lo verifica il cliente lì.
3. **Escludere chi ha già visto un certo video.** Un pubblico personalizzato per video, da creare a mano. Ha senso solo con budget alti e molti contenuti: è lavoro manuale per ogni contenuto.

L'agent non crea né modifica pubblici personalizzati: li legge (`ads_get_ad_account_custom_audiences`) e li usa nelle esclusioni.

## Quando servono contenuti nuovi, non più budget

- Le persone raggiunte non crescono più a spesa uguale.
- La frequenza sale e aggancio e tenuta scendono sugli stessi contenuti.
- Tutti i contenuti attivi sono REGGE o DEBOLE e nessuno è DA SCALARE.

In questi casi la mossa è passare a `/creativita` per capire cosa girare, usando come fonte i contenuti che hanno retto meglio: stesso inizio su un argomento nuovo, oppure stesso argomento con un inizio diverso. Una leva alla volta.

## Dai risultati alle idee

Alla revisione settimanale, per i contenuti con campione sufficiente:
- cosa hanno in comune i tre con la tenuta migliore (argomento, inizio, durata, formato);
- cosa hanno in comune i tre peggiori;
- quale contenuto porta follower e quale porta solo visualizzazioni.

Una differenza che si ripete in almeno tre contenuti diventa una lezione, con i numeri. Una differenza vista una volta resta un'ipotesi.
