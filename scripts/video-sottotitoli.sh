#!/bin/bash
# Imprime i sottotitoli (.srt) nel video, nella fascia sicura in basso (sopra y=1500 su 1920).
# Serve un ffmpeg compilato con libass (filtro "subtitles").
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Uso: $0 <video> <sottotitoli.srt> <uscita.mp4> [font] [dimensione]"
  echo "Esempio: $0 idea1_9x16.mp4 idea1.srt idea1_9x16_sub.mp4 \"Helvetica\" 14"
  exit 1
fi

video="$1"; srt="$2"; uscita="$3"; font="${4:-Helvetica}"; dim="${5:-14}"
for f in "$video" "$srt"; do [ -f "$f" ] || { echo "File non trovato: $f" >&2; exit 1; }; done

if ! ffmpeg -hide_banner -filters 2>/dev/null | grep -q " subtitles "; then
  echo "Questo ffmpeg non ha il filtro per i sottotitoli (libass)." >&2
  echo "Su Mac: installa una versione completa, per esempio 'brew install ffmpeg-full', oppure carica il file .srt insieme al video in Ads Manager." >&2
  exit 2
fi

# Le misure dello stile sono riferite a un'altezza virtuale di 288: MarginV 66 ≈ 440 px su 1920,
# così il testo resta sopra l'interfaccia di Reels e Storie.
stile="FontName=${font},FontSize=${dim},Bold=1,PrimaryColour=&H00FFFFFF,BackColour=&H99000000,BorderStyle=3,Outline=6,Shadow=0,Alignment=2,MarginV=66,MarginL=20,MarginR=20"
srt_esc=$(printf '%s' "$srt" | sed "s/[\\\\':]/\\\\&/g")

mkdir -p "$(dirname "$uscita")"
ffmpeg -hide_banner -loglevel error -y -i "$video" \
  -vf "subtitles='${srt_esc}':force_style='${stile}'" \
  -c:v libx264 -crf 20 -preset medium -pix_fmt yuv420p -c:a copy -movflags +faststart "$uscita"
echo "$uscita"
