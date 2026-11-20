#!/bin/bash
# Stato di un profilo: onboarding, fase, crisi, schede prodotto da riconfermare, briefing di oggi.
# Uso: ./scripts/stato-profilo.sh <nome-profilo>

. "$(cd "$(dirname "$0")/.." && pwd)/.claude/hooks/profili.sh"

profilo="$1"
dir="$cartella_profili/$profilo"
config="$dir/cliente/config.yaml"
oggi=$(date +%F)

if ! nome_valido "$profilo" || [ ! -f "$config" ]; then
  echo "Il profilo \"$profilo\" non esiste. Profili disponibili:"
  elenca_profili
  exit 1
fi

echo "Oggi è $oggi. Profilo attivo: $profilo (cartella profili/$profilo/)."

if ! grep -Eq '^onboarding_completato:[[:space:]]*true' "$config"; then
  if grep -Eq '^onboarding_rapido:[[:space:]]*true' "$config"; then
    echo "ONBOARDING RAPIDO (solo notorietà) per questo profilo: si lavora con /notorieta, /briefing, /interventi e /revisione-settimanale sulle schede di notorietà."
    echo "Per campagne di vendita, creatività nuove o l'audit serve prima l'onboarding completo: proponilo quando il cliente le chiede."
  else
    echo "ONBOARDING NON COMPLETATO per questo profilo."
    echo "Prima di qualsiasi altra attività: spiega in due righe cosa fa questo agent e chiedi cosa vuole fare."
    echo "Se vuole solo farsi conoscere (follower, copertura, visite al profilo, promuovere i suoi post): skill notorieta, percorso rapido. Altrimenti: skill onboarding."
    exit 0
  fi
fi

ids=$(account_del_profilo "$profilo" | paste -sd " " -)
echo "Account pubblicitari del profilo: ${ids:-nessuno}. Ogni chiamata a Meta usa solo questi."

fase=$(sed -n 's/^fase:[[:space:]]*\([a-z_]*\).*/\1/p' "$config")
fine=$(sed -n 's/^fine_sola_lettura:[[:space:]]*"\{0,1\}\([0-9-]*\).*/\1/p' "$config")
echo "Fase: ${fase:-sconosciuta}."

if [ "$fase" = "sola_lettura" ] && [ -n "$fine" ] && [[ ! "$oggi" < "$fine" ]]; then
  echo "Il periodo di sola lettura è finito il $fine: proponi al cliente di passare a gestione_con_conferma (serve il suo consenso esplicito)."
fi

if grep -Eq '^blocco_lanci:[[:space:]]*true' "$config"; then
  echo "ATTENZIONE: blocco_lanci è attivo (crisi in corso). Nessuna nuova creatività o campagna finché il cliente non lo toglie."
fi

# Schede prodotto attive senza conferma o confermate da troppo tempo
validita=$(sed -n 's/^[[:space:]]*scheda_prodotto_valida_giorni:[[:space:]]*\([0-9]*\).*/\1/p' "$config")
validita=${validita:-90}
epoca() { date -j -f %F "$1" +%s 2>/dev/null || date -d "$1" +%s 2>/dev/null; }
adesso=$(epoca "$oggi")
awk '
  /^prodotti:/ { dentro=1; next }
  dentro && /^[^[:space:]#]/ { dentro=0 }
  dentro && /etichetta:/ { if (e != "") print e, s, a; e=$0; sub(/^[^:]*:[[:space:]]*/, "", e); sub(/[[:space:]#].*/, "", e); s=""; a="" }
  dentro && /^[[:space:]]+stato:/ { s=$2 }
  dentro && /aggiornato_il:/ { a=$2; gsub(/"/, "", a) }
  END { if (e != "") print e, s, a }
' "$config" | while read -r etichetta stato aggiornato; do
  [ "$stato" = "attivo" ] && [ "$etichetta" != "\"\"" ] || continue
  if [ -z "$aggiornato" ] || [ "$aggiornato" = "#" ]; then
    echo "La scheda prodotto $etichetta non è mai stata confermata dal cliente: chiedi conferma alla prima occasione."
  elif [ -n "$adesso" ] && quando=$(epoca "$aggiornato") && [ -n "$quando" ] && [ $(( (adesso - quando) / 86400 )) -gt "$validita" ]; then
    echo "La scheda prodotto $etichetta è stata confermata l'ultima volta il $aggiornato: prima di nuove campagne o creatività chiedi se i numeri valgono ancora."
  fi
done

if [ ! -f "$dir/report/briefing/$oggi.md" ]; then
  ultimo=$(ls -1 "$dir/report/briefing/"*.md 2>/dev/null | tail -1)
  if [ -n "$ultimo" ]; then
    echo "Il briefing di oggi non è ancora stato fatto (ultimo: $(basename "$ultimo" .md)). Proponilo al cliente."
  else
    echo "Non c'è ancora nessun briefing per questo profilo. Proponi il primo al cliente."
  fi
fi
exit 0
