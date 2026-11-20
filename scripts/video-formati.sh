#!/bin/bash
# Crea le versioni 9:16, 4:5 e 1:1 di un video con ritaglio centrato.
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Uso: $0 <video> <cartella_uscita> [formati]"
  echo "Formati (predefinito tutti): 9x16 4x5 1x1, separati da virgola. Esempio: $0 spot.mp4 profili/<nome>/creativita/2026-10-27-spot 9x16,4x5"
  exit 1
fi

in="$1"
out="$2"
formati="${3:-9x16,4x5,1x1}"
[ -f "$in" ] || { echo "File non trovato: $in" >&2; exit 1; }
mkdir -p "$out"
nome=$(basename "${in%.*}")

for tag in ${formati//,/ }; do
  case "$tag" in
    9x16) w=1080; h=1920 ;;
    4x5)  w=1080; h=1350 ;;
    1x1)  w=1080; h=1080 ;;
    *) echo "Formato sconosciuto: $tag (usa 9x16, 4x5 o 1x1)" >&2; exit 1 ;;
  esac
  dest="$out/${nome}_${tag}.mp4"
  ffmpeg -hide_banner -loglevel error -y -i "$in" \
    -vf "scale=${w}:${h}:force_original_aspect_ratio=increase,crop=${w}:${h},setsar=1" \
    -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
    -c:a aac -b:a 128k -movflags +faststart "$dest"
  echo "$dest"
done
