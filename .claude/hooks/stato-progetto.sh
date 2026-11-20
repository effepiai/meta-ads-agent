#!/bin/bash
# SessionStart: elenca i profili e chiede su quale lavorare, oppure, se la sessione ne ha
# già uno (ripresa o briefing programmato), ne riassume lo stato.
# Quello che stampa su stdout entra nel contesto della sessione.

. "$(dirname "$0")/profili.sh"

input=$(cat)
sessione=$(campo_json session_id "$input")

# Sessioni vecchie di oltre 30 giorni non servono più
find "$cartella_sessioni" -type f -mtime +30 -exec rm -f {} + 2>/dev/null

profilo=$(profilo_della_sessione "$sessione")
if [ -n "$profilo" ]; then
  if [ -n "${META_PROFILO:-}" ] && [ -n "$sessione" ]; then
    mkdir -p "$cartella_sessioni" && printf '%s\n' "$profilo" > "$cartella_sessioni/$sessione"
  fi
  "$radice/scripts/stato-profilo.sh" "$profilo"
  exit 0
fi

oggi=$(date +%F)
elenco=$(elenca_profili)
echo "Oggi è $oggi. Id di questa sessione: ${sessione:-sconosciuto}."
if [ -z "$elenco" ]; then
  echo "NESSUN PROFILO ANCORA. Ogni account pubblicitario ha il suo profilo, cioè una cartella di lavoro in profili/."
  echo "Saluta, spiega in due righe cosa fa questo agent e chiedi come chiamare il primo profilo (di solito il nome del cliente o dell'account)."
  echo "Poi: ./scripts/nuovo-profilo.sh <nome>, ./scripts/usa-profilo.sh <nome> ${sessione:-<id-sessione>} e la skill onboarding (oppure, se vuole solo farsi conoscere, il percorso rapido della skill notorieta)."
else
  echo "PROFILO NON ANCORA SCELTO. Prima di qualsiasi lavoro chiedi al cliente su quale profilo lavorare in questa sessione:"
  echo "$elenco"
  echo "(oppure se vuole crearne uno nuovo per un altro account, con ./scripts/nuovo-profilo.sh <nome>)."
  echo "Quando risponde, esegui ./scripts/usa-profilo.sh <nome> ${sessione:-<id-sessione>}. Fino ad allora le chiamate a Meta su un account sono bloccate."
fi
exit 0
