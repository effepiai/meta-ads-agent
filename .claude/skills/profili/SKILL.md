---
name: profili
description: Mostra i profili (uno per account pubblicitario), fa scegliere su quale lavorare, passa a un altro account o ne crea uno nuovo. Usala all'avvio quando la sessione non ha ancora un profilo, quando il cliente dice "su quale account siamo?", "passiamo a…", "lavoriamo su…", "aggiungi un account", "nuovo cliente", oppure col comando /profili.
---

# Profili

Ogni account pubblicitario ha il suo profilo in `profili/<nome>/`. La sessione lavora su un profilo alla volta e gli hook permettono chiamate a Meta solo sull'account di quel profilo.

## Vedere e scegliere

1. Esegui `./scripts/profili.sh` e mostra l'elenco: nome del profilo, cliente, account.
2. Chiedi su quale lavorare, con lo strumento delle domande a scelta. Aggiungi sempre l'opzione "Nuovo account".
3. Esegui `./scripts/usa-profilo.sh <nome> <id-sessione>`. L'id della sessione è nel messaggio di avvio; se non lo trovi, dillo al cliente e chiedigli di riaprire la sessione.
4. Leggi quello che stampa lo script e i file del profilo (config, brand-profile, ultime righe di decisioni e lezioni), poi riparti da lì: onboarding se manca, altrimenti il briefing se quello di oggi non c'è.

## Passare a un altro profilo

Solo se lo chiede il cliente. Prima chiudi quello che stavi facendo: niente modifiche a metà su un account mentre passi a un altro. Poi come sopra, dal punto 3. Da quel momento dimentica i numeri del profilo precedente: non vanno citati né usati per l'altro cliente.

## Nuovo account

1. Chiedi come chiamare il profilo: di solito il nome del cliente o dell'account, in minuscolo, con trattini al posto degli spazi.
2. Esegui `./scripts/nuovo-profilo.sh <nome>` e poi `./scripts/usa-profilo.sh <nome> <id-sessione>`.
3. Avvia l'onboarding. Al passo dell'account Meta l'account scelto va in `meta.account_pubblicitari` del nuovo profilo: un solo account per profilo.
4. Se l'account scelto è già in un altro profilo (lo vedi da `./scripts/profili.sh`), fermati e chiedi: o si lavora su quel profilo, o si sposta lì l'account con il consenso del cliente.
