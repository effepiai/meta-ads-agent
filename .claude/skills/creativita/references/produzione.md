# Produzione di immagini e video

*Adattato da: meta-ads-skill `reference/creative.md` (Boring Marketing, MIT) e goose-skills `make-static-ads` (GooseWorks, MIT).*

## Formati

| Formato | Misura | Dove |
|---|---|---|
| 9:16 | 1080×1920 | Reels, Storie |
| 4:5 | 1080×1350 | Feed (il formato più versatile) |
| 1:1 | 1080×1080 | Feed, colonna destra |

Si consegnano i formati in `creativita.formati`.

## Safe zone

Su un file 1080×1920, testi, logo, prodotto e volti vanno **tra y=420 e y=1500**, centrati in orizzontale con un margine di almeno 60 px. In quella fascia restano visibili anche nei ritagli 4:5 e 1:1 e non finiscono sotto l'interfaccia di Reels e Storie (nome dell'account in alto, testo e pulsanti in basso).

Per controllare, usa `./scripts/safe-zone.sh <file> <uscita.png>`. Crea un'immagine con la fascia sicura in verde e le linee dei ritagli 4:5 e 1:1. Guardala prima di consegnare.

## Immagini con un generatore (costano)

1. Prepara i prompt, uno per idea e formato, partendo da `brand-profile.md`: colori in HEX, luce, soggetti, stile.
   - Nel prompt descrivi la scena **senza testi**: titoli e logo si applicano dopo, così non escono storpiati.
   - Lascia spazio libero nella safe zone per il titolo.
2. **Preventivo:** quante immagini, quale modello, costo per immagine e totale, più un eventuale tentativo extra per immagine. Aspetta il sì: vale solo per quel lotto. Se il generatore ha una funzione di stima dei costi, usala.
3. Genera, poi guarda ogni immagine:
   - il prodotto deve essere corretto, senza deformazioni;
   - niente mani o testi strani;
   - deve essere coerente con il brand.

   Scarta quelle con errori invece di consegnarle.
4. Applica titolo e logo con il font e i colori del brand, dentro la safe zone. Puoi usare ffmpeg (se ha il filtro `drawtext`) o lo strumento del generatore. Se non hai uno strumento per il testo, consegna l'immagine pulita più il testo separato per il grafico.
5. Se il generatore restituisce un link pubblico diretto al file, annotalo in `testi.md`: si può usare per caricare il file su Meta.

## Video da materiale esistente (gratis, con ffmpeg)

Gli script sono in `scripts/`. Ognuno stampa l'uso se lanciato senza argomenti.

| Script | Cosa fa |
|---|---|
| `video-formati.sh <video> <cartella>` | Crea le versioni 9:16, 4:5 e 1:1 con ritaglio centrato |
| `video-nuovo-hook.sh <hook.mp4> <corpo.mp4> <uscita.mp4> [secondi da togliere all'inizio del corpo]` | Mette un nuovo inizio davanti al video. Normalizza misura, fps e audio. |
| `video-sottotitoli.sh <video> <sottotitoli.srt> <uscita.mp4>` | Sottotitoli impressi, posizionati nella safe zone (serve ffmpeg con libass) |
| `estrai-fotogrammi.sh <video> <cartella> [ogni N secondi]` | Fotogrammi da guardare, per analizzare un video |
| `safe-zone.sh <immagine o video> <uscita.png>` | Controllo visivo della safe zone |

Idee di montaggio senza nuove riprese:
- un nuovo hook preso da un altro punto dello stesso video (il momento più forte all'inizio);
- un taglio più corto, sotto i 15 secondi;
- sottotitoli grandi nel primo terzo del video;
- un ordine diverso dei pezzi;
- un'immagine finale con l'offerta.

I sottotitoli (file `.srt`) li scrivi tu, partendo dal parlato. Se non hai la trascrizione, chiedila o usa un servizio di trascrizione solo dopo aver chiesto, perché può avere un costo.

## Video con riprese nuove

Non si fingono testimonianze o persone. Prepara `copione.md` con:
- l'hook in tre parti: cosa si vede, cosa si dice, il testo a schermo;
- il corpo diviso in scene, con la durata di ciascuna;
- la chiamata all'azione;
- la lista delle inquadrature e le indicazioni pratiche (luce, verticale, audio, durata totale).

## Etichetta AI

Il campo `self_ai_disclosure` va deciso **prima** di creare la creatività su Meta, perché dopo non si cambia. È OPT_IN se l'immagine o il video sono creati o modificati con un'AI generativa. Segui `creativita.dichiarazione_ai` del config. Annota la scelta in `testi.md`.

## Anteprima per il cliente

`anteprima.html` è una pagina semplice, senza librerie esterne. Per ogni variante mostra:
- l'immagine (`<img>`) o il video (`<video controls>`);
- accanto, testo principale, titolo, CTA e link.

I file sono richiamati con percorsi relativi nella stessa cartella. Il cliente la apre con un doppio clic.
