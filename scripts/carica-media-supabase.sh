#!/bin/bash
# Carica un file in un bucket pubblico di Supabase Storage e stampa l'URL pubblico diretto,
# da usare con ads_creative_upload_media (upload_source URL).
# Richiede nel file .env del progetto: SUPABASE_URL, SUPABASE_KEY, SUPABASE_BUCKET (vedi .env.example).
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Uso: $0 <file> [percorso_nel_bucket]"
  echo "Predefinito percorso: meta-ads/AAAAMMGG/<nome_file>"
  exit 1
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
if [ -f "$root/.env" ]; then
  set -a; . "$root/.env"; set +a
fi
: "${SUPABASE_URL:?Manca SUPABASE_URL nel file .env}"
: "${SUPABASE_KEY:?Manca SUPABASE_KEY nel file .env}"
: "${SUPABASE_BUCKET:?Manca SUPABASE_BUCKET nel file .env}"

file="$1"
[ -f "$file" ] || { echo "File non trovato: $file" >&2; exit 1; }
percorso="${2:-meta-ads/$(date +%Y%m%d)/$(basename "$file")}"
mime=$(file --mime-type -b "$file")
base="${SUPABASE_URL%/}"

risposta=$(mktemp)
trap 'rm -f "$risposta"' EXIT
stato=$(curl -sS -o "$risposta" -w '%{http_code}' -X POST \
  "$base/storage/v1/object/$SUPABASE_BUCKET/$percorso" \
  -H "Authorization: Bearer $SUPABASE_KEY" \
  -H "apikey: $SUPABASE_KEY" \
  -H "Content-Type: $mime" \
  -H "x-upsert: true" \
  --data-binary @"$file") || stato="000"

if [ "$stato" != "200" ]; then
  echo "Caricamento non riuscito (HTTP $stato): $(head -c 300 "$risposta")" >&2
  echo "Controlla chiave, nome del bucket e che il bucket sia pubblico." >&2
  exit 1
fi
echo "$base/storage/v1/object/public/$SUPABASE_BUCKET/$percorso"
