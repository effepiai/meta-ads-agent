#!/bin/bash
# Estrae fotogrammi da un video per guardarlo (analisi di una creatività) o per usarne uno come copertina.
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Uso: $0 <video> <cartella_uscita> [ogni_n_secondi] [larghezza]"
  echo "Predefiniti: un fotogramma ogni 2 secondi, larghezza 540 (per guardarli). Per una copertina usa larghezza 1080."
  exit 1
fi

video="$1"; out="$2"; ogni="${3:-2}"; larghezza="${4:-540}"
[ -f "$video" ] || { echo "File non trovato: $video" >&2; exit 1; }
mkdir -p "$out"
nome=$(basename "${video%.*}")

# Il primo fotogramma (l'hook) sempre, poi uno ogni N secondi.
ffmpeg -hide_banner -loglevel error -y -i "$video" -frames:v 1 -vf "scale=${larghezza}:-2" "$out/${nome}_00_inizio.jpg"
ffmpeg -hide_banner -loglevel error -y -i "$video" -vf "fps=1/${ogni},scale=${larghezza}:-2" "$out/${nome}_%03d.jpg"
ls -1 "$out"/"${nome}"_*.jpg
