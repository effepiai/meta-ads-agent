#!/bin/bash
# PostToolUse sui tool Meta Ads: ogni scrittura eseguita finisce nel registro del profilo
# della sessione, in profili/<nome>/registro/azioni-meta.jsonl (una riga JSON per azione:
# quando, tool, parametri e risposta). Le letture non vengono registrate.

. "$(dirname "$0")/profili.sh"

input=$(cat | tr -d '\n')
tool=$(campo_json tool_name "$input")
nome="${tool##*__}"

case "$nome" in
  ads_get_*|ads_insights_*|ads_library_*|ads_account_get_*|ads_catalog_get_*|ads_catalog_list_*|ads_experiment_list_*|ads_experiment_*_get_test|ads_experiment_check_eligibility|ads_pixel_*_read|"")
    exit 0 ;;
esac

profilo=$(profilo_della_sessione "$(campo_json session_id "$input")")
if [ -n "$profilo" ]; then
  registro="$cartella_profili/$profilo/registro"
else
  registro="$radice/.stato"
fi

mkdir -p "$registro"
printf '{"quando":"%s","profilo":"%s","evento":%s}\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${profilo:-nessuno}" "$input" >> "$registro/azioni-meta.jsonl"
exit 0
