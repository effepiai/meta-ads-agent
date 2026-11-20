---
name: interventi
description: Trasforma le priorità del briefing in mosse concrete sull'account Meta Ads (spegnere, scalare, aspettare, ruotare, sistemare). Ogni mossa ha motivo, effetto atteso, come tornare indietro e data di verifica. Le applica una alla volta solo dopo un sì esplicito. Usala dopo il briefing, col comando /interventi, o quando il cliente chiede "cosa facciamo?", "spegni questa campagna", "alza il budget", "metti in pausa".
---

# Interventi

Prima leggi:
- `<profilo>/cliente/config.yaml`: fase, soglie, `non_toccare`, budget e le schede `prodotti`;
- l'ultimo `<profilo>/report/briefing/`;
- `<profilo>/registro/decisioni.md`, per sapere cosa è stato toccato e quando;
- `references/mosse.md`.

Se `fase: sola_lettura`, prepara comunque le mosse come **bozza**. Scrivile nel registro con stato "proposta" e spiega che verranno applicate quando si passerà alla gestione con conferma.

## 1. Prepara le mosse

Per ogni punto P1 e P2 del briefing scegli **una** mossa tra quelle di `references/mosse.md`: SPEGNERE, SCALARE, ASPETTARE, RUOTARE, SISTEMARE. Prima di proporla controlla:

- L'oggetto è in `non_toccare`? → nessuna mossa.
- È in learning o è stato modificato negli ultimi `giorni_attesa_dopo_modifica` giorni? → **ASPETTARE**, con una data.
- Il dato è nella zona grigia (`zona_grigia_x_target`) o sotto il campione minimo? Mostra **due letture**, "se è rumore…" e "se è reale…", e lascia decidere il cliente.
- Stai spegnendo l'ultima inserzione che converte in un gruppo? Serve prima un sostituto attivo: passa a `/creativita`.
- La campagna è di una scheda con `tipo: notorieta`? Usa la sezione "Campagne di notorietà" di `references/mosse.md`: niente CPA. Nel campo "Perché" metti tenuta e costo per risultato contro la mediana dell'account.

## 2. Presenta le mosse

Una tabella, poi i dettagli di ciascuna:

```
### Mossa 1 — <verbo> <oggetto>
- Oggetto: <tipo> "<nome>" (ID <id>)
- Ora → dopo: <es. budget giornaliero 50,00 € → 60,00 €>
- Perché: <numeri: periodo, spesa, risultati, CPA vs target del prodotto <ETICHETTA>>
- Effetto atteso: <cosa ci aspettiamo, entro quando>
- Rischio: <es. il learning riparte per circa 7 giorni>
- Come tornare indietro: <azione inversa>
- Verifica il: <data>
```

Chiedi conferma mossa per mossa. Il cliente può rispondere "sì alla 1 e alla 3". Un sì generico dato prima di vedere le mosse non vale.

## 3. Applica (solo con il sì, una alla volta)

- **Pausa**: `ads_update_entity` con `fields: {"status":"PAUSED"}` e nient'altro. Dopo una pausa **non** chiamare `ads_activate_entity`, perché annullerebbe la pausa. Verifica con `ads_get_ad_entities`.
- **Budget**:
  - prima leggi se il budget è sulla campagna (CBO) o sul gruppo (ABO), con `ads_get_ad_entities`, campi `daily_budget` e `lifetime_budget`;
  - poi `ads_update_entity` con `daily_budget` in **centesimi** (50,00 € = 5000);
  - aumento massimo `aumento_max_per_passo_pct`;
  - oltre `doppia_conferma_oltre_pct` serve una seconda conferma esplicita;
  - mai oltre `budget.massimo_mensile`.
- **Riattivare** qualcosa in pausa: `ads_activate_entity`, sempre con il suo sì.
- **Cambiare creatività**: non si può modificare una creatività esistente. Passa a `/creativita` e poi a `/pubblica`, che creano un'inserzione nuova e mettono in pausa la vecchia solo quando la nuova è attiva.
- **Modalità bozza.** Se la risposta dice `is_draft: true`, la modifica è in bozza in Ads Manager e non è ancora attiva. Dillo al cliente. Si pubblica con `ads_activate_entity` passando in `object_ids` solo gli oggetti modificati, con `publish_as_active: false` se la modifica non era un'attivazione. Annota `meta.modalita_bozza: si` nel config.
- Al massimo `modifiche_max_per_conferma` scritture per ogni conferma.
- Se una chiamata fallisce con un errore interno:
  1. controlla se la modifica è stata applicata comunque;
  2. riprova una volta sola;
  3. se fallisce ancora, fermati e spiega.

## 4. Verifica e registra

Dopo ogni scrittura:
1. Rileggi il valore con `ads_get_ad_entities` e mostra "fatto: <valore letto>".
2. Aggiungi la voce in `<profilo>/registro/decisioni.md`: stato "approvata e applicata", data di verifica = oggi + `giorni_attesa_dopo_modifica`.
3. Le mosse rifiutate o rimandate vanno comunque nel registro con il loro stato.
