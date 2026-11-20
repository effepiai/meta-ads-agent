#!/bin/bash
# Mette un nuovo inizio (hook) davanti a un video. Normalizza misura, fotogrammi e audio
# così i due pezzi si uniscono senza errori, anche se uno dei due non ha audio.
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Uso: $0 <hook.mp4> <corpo.mp4> <uscita.mp4> [secondi_da_togliere_al_corpo] [formato]"
  echo "Formato: 9x16 (predefinito), 4x5 o 1x1."
  echo "Esempio: $0 pezzo-forte.mp4 spot.mp4 profili/<nome>/creativita/2026-10-27-hook/idea1_9x16.mp4 2.5"
  exit 1
fi

hook="$1"; corpo="$2"; uscita="$3"; taglio="${4:-0}"; formato="${5:-9x16}"
for f in "$hook" "$corpo"; do [ -f "$f" ] || { echo "File non trovato: $f" >&2; exit 1; }; done
case "$formato" in
  9x16) w=1080; h=1920 ;;
  4x5)  w=1080; h=1350 ;;
  1x1)  w=1080; h=1080 ;;
  *) echo "Formato sconosciuto: $formato" >&2; exit 1 ;;
esac

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
vf="scale=${w}:${h}:force_original_aspect_ratio=increase,crop=${w}:${h},setsar=1,fps=30,format=yuv420p"

ha_audio() { [ -n "$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$1")" ]; }

normalizza() {
  local in="$1" out="$2" inizio="$3"
  if ha_audio "$in"; then
    ffmpeg -hide_banner -loglevel error -y -ss "$inizio" -i "$in" -vf "$vf" \
      -af "aresample=48000" -ac 2 -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 160k "$out"
  else
    ffmpeg -hide_banner -loglevel error -y -ss "$inizio" -i "$in" -f lavfi -i anullsrc=r=48000:cl=stereo \
      -vf "$vf" -map 0:v -map 1:a -shortest -c:v libx264 -crf 18 -preset medium -c:a aac -b:a 160k "$out"
  fi
}

normalizza "$hook" "$tmp/a.mp4" 0
normalizza "$corpo" "$tmp/b.mp4" "$taglio"

mkdir -p "$(dirname "$uscita")"
ffmpeg -hide_banner -loglevel error -y -i "$tmp/a.mp4" -i "$tmp/b.mp4" \
  -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" \
  -c:v libx264 -crf 20 -preset medium -pix_fmt yuv420p -c:a aac -b:a 160k -movflags +faststart "$uscita"
echo "$uscita"
