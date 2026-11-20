#!/bin/bash
# Funzioni comuni a hook e script per i profili: una cartella in profili/<nome>/ per ogni
# account pubblicitario. Ogni sessione lavora su un solo profilo, scritto in .stato/sessioni/<id>.
# Si include con: . "$(dirname "$0")/profili.sh" (dagli hook) o con il percorso dalla radice.

radice="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cartella_profili="$radice/profili"
cartella_sessioni="$radice/.stato/sessioni"

# Valore di una chiave stringa nel JSON ricevuto dall'hook (prima occorrenza).
campo_json() {
  printf '%s' "$2" | tr -d '\n' | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"
}

nome_valido() {
  printf '%s' "$1" | grep -Eq '^[a-z0-9][a-z0-9-]{0,49}$'
}

# Profilo della sessione: META_PROFILO (briefing programmato) o il file della sessione.
profilo_della_sessione() {
  local p=""
  if [ -n "${META_PROFILO:-}" ]; then
    p="$META_PROFILO"
  elif [ -n "$1" ] && [ -f "$cartella_sessioni/$1" ]; then
    p=$(head -1 "$cartella_sessioni/$1")
  fi
  if nome_valido "$p" && [ -f "$cartella_profili/$p/cliente/config.yaml" ]; then
    printf '%s' "$p"
  fi
}

# ID numerici degli account pubblicitari del profilo (meta.account_pubblicitari), uno per riga.
account_del_profilo() {
  awk '
    { sub(/#.*/, "") }
    /^  account_pubblicitari:/ { dentro = 1; print; next }
    dentro && /^ ? ?[^ -]/ { dentro = 0 }
    dentro { print }
  ' "$cartella_profili/$1/cliente/config.yaml" 2>/dev/null \
    | grep -oE 'id:[[:space:]]*"?(act_)?[0-9]+' | grep -oE '[0-9]+$' | sort -u
}

# Elenco dei profili: nome, nome del cliente e account.
elenca_profili() {
  local d p cliente ids
  for d in "$cartella_profili"/*/; do
    [ -f "$d/cliente/config.yaml" ] || continue
    p=$(basename "$d")
    cliente=$(awk '/^cliente:/ { c = 1; next } c && /^[^ ]/ { c = 0 } c && /^  nome:/ { sub(/^  nome:[[:space:]]*/, ""); gsub(/"/, ""); sub(/[[:space:]]*#.*/, ""); print; exit }' "$d/cliente/config.yaml")
    ids=$(account_del_profilo "$p" | paste -sd " " -)
    printf -- '- %s (cliente: %s; account: %s)\n' "$p" "${cliente:-da definire}" "${ids:-nessuno, onboarding da fare}"
  done
}
