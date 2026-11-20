#!/bin/bash
# Elenca i profili (uno per account pubblicitario) con il cliente e gli account collegati.
# Uso: ./scripts/profili.sh

. "$(cd "$(dirname "$0")/.." && pwd)/.claude/hooks/profili.sh"

elenco=$(elenca_profili)
if [ -z "$elenco" ]; then
  echo "Nessun profilo. Creane uno con ./scripts/nuovo-profilo.sh <nome>"
else
  echo "$elenco"
fi
