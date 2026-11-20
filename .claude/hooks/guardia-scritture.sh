#!/bin/bash
# PreToolUse sui tool Meta Ads. Blocca (exit 2):
# - le chiamate su un account quando la sessione non ha ancora scelto un profilo;
# - le chiamate su un account pubblicitario che non è del profilo scelto;
# - le scritture in fase di sola lettura, i lanci durante una crisi, cancellare o archiviare.
# Il messaggio su stderr arriva all'agent.

. "$(dirname "$0")/profili.sh"

input=$(cat | tr -d '\n')
tool=$(campo_json tool_name "$input")
nome="${tool##*__}"
sessione=$(campo_json session_id "$input")
account=$(printf '%s' "$input" | grep -oE '"ad_account_id"[[:space:]]*:[[:space:]]*"?(act_)?[0-9]+' | head -1 | grep -oE '[0-9]+$')

case "$nome" in
  ads_get_*|ads_insights_*|ads_library_*|ads_account_get_*|ads_catalog_get_*|ads_catalog_list_*|ads_experiment_list_*|ads_experiment_*_get_test|ads_experiment_check_eligibility|ads_pixel_*_read)
    lettura=1 ;;
  *)
    lettura=0 ;;
esac

profilo=$(profilo_della_sessione "$sessione")

if [ -z "$profilo" ]; then
  # Senza profilo si possono solo consultare elenchi e guide che non riguardano un account
  if [ "$lettura" = 1 ] && [ -z "$account" ]; then
    exit 0
  fi
  echo "Bloccato: questa sessione non ha ancora scelto un profilo. Chiedi al cliente su quale profilo lavorare ed esegui ./scripts/usa-profilo.sh <nome> ${sessione:-<id-sessione>}." >&2
  exit 2
fi

config="$cartella_profili/$profilo/cliente/config.yaml"
ids=$(account_del_profilo "$profilo")

if [ -n "$account" ] && [ -n "$ids" ] && ! printf '%s\n' "$ids" | grep -qx "$account"; then
  echo "Bloccato: l'account $account non appartiene al profilo \"$profilo\" (account del profilo: $(printf '%s' "$ids" | tr '\n' ' ')). In questa sessione si lavora solo su quel profilo. Per un altro account il cliente deve scegliere un altro profilo." >&2
  exit 2
fi

[ "$lettura" = 1 ] && exit 0

if [ -z "$ids" ]; then
  echo "Bloccato: il profilo \"$profilo\" non ha ancora un account pubblicitario in cliente/config.yaml (meta.account_pubblicitari). Completa l'onboarding prima di scrivere su Meta." >&2
  exit 2
fi

if grep -Eq '^fase:[[:space:]]*sola_lettura' "$config"; then
  echo "Bloccato: il profilo \"$profilo\" è in fase di sola lettura (cliente/config.yaml, campo fase). Nessuna scrittura su Meta finché il cliente non decide di passare a gestione_con_conferma. Proponi la modifica come bozza." >&2
  exit 2
fi

if printf '%s' "$input" | grep -Eq '\\?"status\\?"[[:space:]]*:[[:space:]]*\\?"(DELETED|ARCHIVED)'; then
  echo "Bloccato: in questo progetto non si cancella e non si archivia. Usa la pausa (status PAUSED)." >&2
  exit 2
fi

if grep -Eq '^blocco_lanci:[[:space:]]*true' "$config"; then
  case "$nome" in
    ads_create_*|ads_activate_entity|ads_boost_*|ads_experiment_*_create_test)
      echo "Bloccato: blocco_lanci è attivo nel profilo \"$profilo\" (crisi in corso). Sono permesse solo le pause." >&2
      exit 2 ;;
  esac
fi

exit 0
