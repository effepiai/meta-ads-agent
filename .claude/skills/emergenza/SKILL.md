---
name: emergenza
description: Gestisce i problemi urgenti sull'account Meta Ads con diagnosi immediata e proposta di soluzione. Copre inserzioni rifiutate, account limitato o disabilitato, spesa che esplode o si ferma, tracciamento delle conversioni rotto, prodotto esaurito o offerta scaduta, crisi di brand. Propone, e scrive solo con il sì. Usala col comando /emergenza, quando il briefing trova un problema P1 grave, o quando il cliente dice "le inserzioni sono bloccate", "spende troppo", "non arrivano più vendite", "c'è un problema", "fermate tutto".
---

# Emergenze

**La prima cosa è capire, non agire.** Leggi i dati, trova la causa, proponi la soluzione più piccola e reversibile.

Anche in emergenza ogni scrittura richiede il sì del cliente. Puoi però proporre una **pausa d'emergenza** che copre più oggetti con un solo sì, purché il sì nomini l'elenco esatto degli oggetti.

Prima identifica il caso. Le schede sono in `references/casi.md`:

| Sintomo | Caso |
|---|---|
| Inserzioni rifiutate, "con problemi", in revisione da più di 24 ore | 1. Rifiuto |
| Account limitato, disabilitato, "vietato fare pubblicità" | 2. Account |
| Spesa di ieri oltre il 150% della media o ritmo mensile fuori controllo | 3. Spesa esplosa |
| Spesa a zero o quasi, senza motivo | 4. Spesa ferma |
| Conversioni a zero o crollate con traffico normale | 5. Tracciamento |
| Il prodotto pubblicizzato è esaurito, l'offerta è scaduta, la pagina non funziona | 6. Offerta |
| Commenti negativi in massa, notizia negativa, errore pubblico del brand | 7. Crisi di brand |

## Come rispondere

1. **In una frase**: cosa sta succedendo e quanto è grave. Per esempio: "3 inserzioni rifiutate per policy, nessuna spesa persa".
2. **Prove**: i numeri e gli stati letti dai tool.
3. **Causa probabile**: una sola, la più probabile, con il livello di fiducia.
4. **Cosa propongo**: la soluzione più piccola e reversibile, nel formato delle mosse di `/interventi` (ora → dopo, perché, come tornare indietro).
5. **Cosa deve fare il cliente** fuori dall'agent, se serve: per esempio la richiesta di revisione su Account Quality, o il controllo del sito.

Dopo il sì applica, rileggi, registra in `<profilo>/registro/decisioni.md` con il tag `[EMERGENZA]` e fissa la verifica a domani.

Se `fase: sola_lettura`, l'hook blocca le scritture. In un'emergenza vera spiega al cliente che ha due strade:
- intervenire lui da Ads Manager, con i passi precisi;
- passare a `gestione_con_conferma`.
