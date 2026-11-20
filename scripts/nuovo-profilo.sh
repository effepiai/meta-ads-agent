#!/bin/bash
# Crea la cartella di lavoro per un nuovo account pubblicitario, copiando modello-profilo/.
# Uso: ./scripts/nuovo-profilo.sh <nome>
# Il nome è breve, minuscolo, con trattini al posto degli spazi (es. pizzeria-da-mario).

. "$(cd "$(dirname "$0")/.." && pwd)/.claude/hooks/profili.sh"

profilo="$1"

if ! nome_valido "$profilo"; then
  echo "Nome non valido: \"$profilo\". Usa lettere minuscole, numeri e trattini, senza spazi (es. pizzeria-da-mario)." >&2
  exit 1
fi
if [ -e "$cartella_profili/$profilo" ]; then
  echo "Il profilo \"$profilo\" esiste già. Per lavorarci: ./scripts/usa-profilo.sh $profilo <id-sessione>" >&2
  exit 1
fi

mkdir -p "$cartella_profili"
cp -R "$radice/modello-profilo" "$cartella_profili/$profilo"
echo "Creato il profilo \"$profilo\" in profili/$profilo/."
echo "Ora sceglilo per questa sessione con ./scripts/usa-profilo.sh $profilo <id-sessione> e fai l'onboarding."
