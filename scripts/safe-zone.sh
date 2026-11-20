#!/bin/bash
# Crea un'immagine di controllo della safe zone su un'immagine o sul primo fotogramma di un video.
# Formato verticale (9:16): fascia verde = sicura (y 420-1500, margine 60 px),
#   rosso = ritaglio 4:5, giallo = ritaglio 1:1.
# Altri formati: riquadro verde con margine del 6% su ogni lato.
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Uso: $0 <immagine_o_video> <uscita.png>"
  exit 1
fi

in="$1"; out="$2"
[ -f "$in" ] || { echo "File non trovato: $in" >&2; exit 1; }
mkdir -p "$(dirname "$out")"

dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$in")
w=${dim%x*}; h=${dim#*x}

if [ $((h * 100 / w)) -ge 170 ]; then
  vf="scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1"
  vf="$vf,drawbox=x=60:y=420:w=960:h=1080:color=green@0.18:t=fill"
  vf="$vf,drawbox=x=60:y=420:w=960:h=1080:color=green:t=6"
  vf="$vf,drawbox=x=0:y=285:w=1080:h=1350:color=red:t=4"
  vf="$vf,drawbox=x=0:y=420:w=1080:h=1080:color=yellow:t=4"
  echo "Formato verticale: verde = safe zone, rosso = ritaglio 4:5, giallo = ritaglio 1:1."
else
  vf="scale=1080:-2,setsar=1"
  vf="$vf,drawbox=x=iw*0.06:y=ih*0.06:w=iw*0.88:h=ih*0.88:color=green@0.15:t=fill"
  vf="$vf,drawbox=x=iw*0.06:y=ih*0.06:w=iw*0.88:h=ih*0.88:color=green:t=6"
  echo "Formato ${w}x${h}: verde = area con margine del 6%."
fi

ffmpeg -hide_banner -loglevel error -y -i "$in" -frames:v 1 -vf "$vf" "$out"
echo "$out"
