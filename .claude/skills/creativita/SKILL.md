---
name: creativita
description: Prepara creatività per Meta Ads in due modalità. VARIANTE parte da un'inserzione vincente o stanca e cambia una leva (hook, angolo, formato). NUOVA parte da un'idea nuova quando le varianti non bastano più. Raccoglie materiale reale, propone una griglia di idee, scrive i testi, produce immagini e video (chiedendo il preventivo prima di spendere crediti) e prepara tutto per /pubblica. Non scrive su Meta. Usala col comando /creativita, o quando il cliente chiede varianti, nuove inserzioni, nuovi testi, nuove immagini o video, o quando il briefing segnala creatività stanche o vincenti.
---

# Creatività

Prima leggi:
- `<profilo>/cliente/brand-profile.md`;
- `<profilo>/cliente/config.yaml`, sezione `creativita`, `blocco_lanci` e la scheda `prodotti` del prodotto da pubblicizzare (pubblico, zona, stagione, risultato). Se il prodotto non ha una scheda, creala prima come spiega `.claude/skills/briefing/references/prodotti.md`. Se ce l'ha, mostrala e chiedi se vale ancora: non rifare le domande;
- `<profilo>/registro/creativita.md`, per non riproporre idee già provate;
- `<profilo>/registro/lezioni.md`;
- l'ultimo briefing.

Se `blocco_lanci: true`, fermati e spiega il motivo.

Riferimenti da usare:
- `references/hook-e-idee.md`: hook, angoli, griglia delle idee, schemi di statiche;
- `references/testi-meta.md`: lunghezze, stile italiano, controlli su promesse e policy;
- `references/produzione.md`: immagini, video, safe zone, etichetta AI, anteprima.

## 0. Variante o creatività nuova?

**VARIANTE**: c'è un'inserzione che ha superato `campione_minimo` ed è sotto target (da replicare), oppure stanca (da rinfrescare).
- Si cambia **una leva sola**: hook, angolo oppure formato.
- Due varianti per ogni inserzione di partenza.
- Per una scheda con `tipo: notorieta` il punto di partenza è un contenuto con verdetto DA SCALARE o REGGE (vedi `.claude/skills/notorieta/references/giudizio.md`): "sotto target" lì significa costo per risultato sotto il riferimento dell'account. La leva da cambiare la indica la curva di visione, non il CTR.

**NUOVA**: serve una creatività nuova quando:
- tutte le creatività attive sono stanche o troppo simili tra loro (Meta le tratta come una sola);
- la copertura cala mese su mese;
- le ultime varianti non hanno funzionato;
- c'è un'offerta, un prodotto o una stagione nuova;
- lo chiede il cliente.

Prima di tutto usa i numeri per capire **dove** intervenire (tabella in `references/hook-e-idee.md`). Se il CTR è buono ma non si converte, il problema è la landing o l'offerta: dillo e non produrre creatività inutili.

## 1. Raccogli il materiale reale

- **Le inserzioni di partenza o le migliori degli ultimi 90 giorni**: metriche da `ads_get_ad_entities` a livello ad; testi, immagini e video da `ads_get_creatives`, `ads_get_ad_images`, `ads_get_ad_videos`, `ads_get_ad_preview`. Per i video, scarica il file solo se c'è un link diretto ed estrai i fotogrammi con `./scripts/estrai-fotogrammi.sh` per guardarli.
- **Commenti e post organici migliori**: `ads_get_ig_media`.
- **Recensioni, domande frequenti e prove** da `<profilo>/cliente/brand/` e `brand-profile.md`.
- **Concorrenti**: l'ultimo `<profilo>/report/competitor/`, se c'è.
- **Materiale grezzo**: foto e video in `creativita.materiale_grezzo`.

**Regola: ogni idea deve poggiare su una fonte reale** (un'inserzione vincente, una recensione, un commento, un dato). Se mancano recensioni o esempi, chiedili al cliente invece di inventarli. Mai inventare recensioni, numeri, testimonianze o screenshot.

## 2. Griglia delle idee (gratis, nessun credito speso)

Proponi 3-5 idee: 2 per inserzione nella modalità VARIANTE, 3-5 nella modalità NUOVA. Per ciascuna:

```
### Idea <n> — <titolo breve>
- Leva cambiata (solo VARIANTE): hook | angolo | formato
- Angolo e a chi parla: <pubblico nuovo o già interessato; livello di consapevolezza>
- Formato: immagine 4:5 | video 9:16 | carosello | ...
- Hook: cosa si vede / cosa si dice / testo a schermo
- Fonte: <inserzione ID, recensione, commento, dato>
- Ipotesi: <es. "CTR +15% rispetto all'inserzione X">, metrica, quando si giudica
- Produzione: testo soltanto | immagine generata | montaggio video da materiale esistente | riprese nuove
```

Nella modalità NUOVA, almeno una idea deve essere davvero diversa (angolo o formato nuovo), non una riformulazione. Il cliente sceglie quali idee portare avanti.

## 3. Testi

Per ogni idea scelta scrivi, seguendo `references/testi-meta.md`:
- **testo principale**: 3-5 alternative, con l'essenziale nei primi 125 caratteri;
- **titolo**: 3-5 alternative, entro 40 caratteri;
- **descrizione** (opzionale): entro 30 caratteri;
- **CTA**: dalla lista di Meta, la stessa per tutte le varianti dello stesso test.

Poi fai il controllo di conformità: promesse, frasi vietate del brand, categoria speciale, policy Meta. Le alternative di testo vanno nella stessa inserzione (formato multi-media, fino a 5 per tipo): sono gratis e le testa Meta.

## 4. Preventivo e produzione

Segui `references/produzione.md`.

- **Immagini con un generatore a pagamento.** Prima mostra il preventivo: quante immagini, con quale modello e quanti crediti o euro. Aspetta il sì: vale solo per quel lotto. Poi genera, applica logo e testi seguendo il brand profile e controlla le safe zone.
- **Video da materiale esistente**: montaggio gratuito con gli script ffmpeg in `scripts/`.
- **Video con riprese nuove**: non si fingono. Prepara un copione con hook in tre parti e la lista delle inquadrature, da far girare al cliente. Salvali nella cartella della creatività.
- **Nessun generatore disponibile**: prepara prompt e brief per il grafico.

## 5. Etichetta AI

Se un'immagine o un video è creato o modificato con l'AI, applica `creativita.dichiarazione_ai`. Con `chiedi`, chiedi al cliente se dichiararlo: in UE conta, e dopo la creazione non si cambia più.

## 6. Anteprima e approvazione

Salva tutto in `<profilo>/creativita/AAAA-MM-GG-<nome>/`:
- i file finali, nominati `<idea>_<formato>.<est>`, per esempio `idea2_9x16.mp4`;
- `testi.md` con tutte le alternative, CTA, link di destinazione e `utm_content` proposto per ogni variante;
- `anteprima.html`: una pagina semplice con le immagini e i video affiancati ai testi, da aprire nel browser.

Mostra l'anteprima al cliente e raccogli le correzioni. Quando approva, aggiungi le righe in `<profilo>/registro/creativita.md` con esito "pronta" e proponi `/pubblica`.
