#!/bin/bash
# Lancia il briefing del mattino senza nessuno davanti (da launchd, cron o a mano), un profilo
# alla volta, e salva il log in profili/<nome>/report/briefing/log/. Le scritture su Meta non sono
# possibili in questa modalità: i tool di scrittura chiedono conferma e, senza una persona, vengono negati.
# Uso: ./scripts/briefing-programmato.sh [nome-profilo ...]
# Senza nomi fa il briefing di tutti i profili con l'onboarding completato.
set -uo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
claude_bin="${CLAUDE_BIN:-$(command -v claude || true)}"
if [ -z "$claude_bin" ] || [ ! -x "$claude_bin" ]; then
  echo "Comando claude non trovato. Imposta CLAUDE_BIN con il percorso completo (es. \$HOME/.local/bin/claude)." >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
  profili=("$@")
else
  profili=()
  for d in profili/*/; do
    grep -Eq '^(onboarding_completato|onboarding_rapido):[[:space:]]*true' "$d/cliente/config.yaml" 2>/dev/null && profili+=("$(basename "$d")")
  done
fi

if [ "${#profili[@]}" -eq 0 ]; then
  echo "Nessun profilo con l'onboarding completato: niente briefing da fare." >&2
  exit 0
fi

for p in "${profili[@]}"; do
  if [ ! -f "profili/$p/cliente/config.yaml" ]; then
    echo "Profilo \"$p\" non trovato: saltato." >&2
    continue
  fi
  mkdir -p "profili/$p/report/briefing/log"
  log="profili/$p/report/briefing/log/$(date +%F).log"
  {
    echo "=== Briefing programmato $(date '+%F %T'), profilo $p ==="
    META_PROFILO="$p" "$claude_bin" -p "Esegui il briefing del mattino con la skill briefing per il profilo $p, in modalità programmata: il profilo è già scelto, non fare domande, non proporre né eseguire scritture su Meta, usa solo l'account del profilo, salva il report di oggi in profili/$p/report/briefing/ e chiudi con la sintesi in tre righe." --output-format text
    echo "=== Fine (codice $?) ==="
  } >> "$log" 2>&1
done
