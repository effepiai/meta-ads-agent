#!/bin/bash
# Sceglie il profilo su cui lavora questa sessione. Da qui in poi gli hook permettono
# chiamate a Meta solo sugli account pubblicitari di quel profilo.
# Uso: ./scripts/usa-profilo.sh <nome-profilo> <id-sessione>
# L'id della sessione lo indica il messaggio di avvio.

. "$(cd "$(dirname "$0")/.." && pwd)/.claude/hooks/profili.sh"

profilo="$1"
sessione="$2"

if [ -z "$profilo" ] || [ -z "$sessione" ]; then
  echo "Uso: $0 <nome-profilo> <id-sessione>. L'id della sessione è nel messaggio di avvio." >&2
  exit 1
fi
if ! printf '%s' "$sessione" | grep -Eq '^[A-Za-z0-9_-]{1,100}$'; then
  echo "Id di sessione non valido: $sessione" >&2
  exit 1
fi
if ! nome_valido "$profilo" || [ ! -f "$cartella_profili/$profilo/cliente/config.yaml" ]; then
  echo "Il profilo \"$profilo\" non esiste. Profili disponibili:" >&2
  elenca_profili >&2
  echo "Per crearne uno nuovo: ./scripts/nuovo-profilo.sh <nome>" >&2
  exit 1
fi

mkdir -p "$cartella_sessioni"
printf '%s\n' "$profilo" > "$cartella_sessioni/$sessione"
"$radice/scripts/stato-profilo.sh" "$profilo"
