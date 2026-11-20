# Testi per Meta: regole

*Adattato da: marketingskills `ad-creative` (Corey Haines, MIT) e meta-ads-skill `reference/creative.md` (Boring Marketing, MIT).*

## Lunghezze

| Campo | Limite pratico | Note |
|---|---|---|
| Testo principale (`message` / `primary_texts`) | ~125 caratteri visibili prima di "Altro" | L'essenziale nella prima riga. Può continuare dopo, se serve. |
| Titolo (`headline` / `headlines`) | 40 caratteri | Spesso troncato da mobile oltre i 27-30 |
| Descrizione (`description`) | 30 caratteri | In molti posizionamenti non si vede |
| Alternative | Fino a 5 per testo, titolo e descrizione | Nel formato multi-media, Meta sceglie la combinazione |

## Stile in italiano

- Scrivi come parla il cliente ideale: parole sue, prese da recensioni e messaggi.
- Una frase, un'idea. Frasi brevi e verbi concreti.
- Numeri veri e specifici ("in 14 giorni", "1.240 clienti") invece di aggettivi.
- Emoji: solo se fanno parte del tono del brand, al massimo 1-2.

**Formule da evitare**, perché fanno sembrare il testo scritto da un'AI o da una pubblicità vecchia:
- "Non è solo X, è Y" e "Non X. Non Y. Solo Z."
- "Scopri…", "Immagina…", "In un mondo in cui…", "Sei pronto a…?"
- "Rivoluzionario", "game changer", "il segreto che…", "cambierà la tua vita"
- Domande retoriche in fila, trattini lunghi ovunque, tre aggettivi di seguito
- "Stop allo scroll!", "Attenzione!", maiuscole per urlare

## Controlli prima di consegnare

1. **Promesse dimostrabili.** Ogni numero o risultato deve avere una fonte in `brand-profile.md` o nei dati. Niente garanzie di guadagno o di risultati di salute.
2. **Frasi vietate del brand** in `brand-profile.md`, sezione Vincoli.
3. **Attributi personali (policy Meta).** Non si può insinuare che la persona abbia una caratteristica: salute, peso, debiti, etnia, religione, orientamento. "Sei sovrappeso?" non va bene; "Un piano per chi vuole tornare in forma" sì.
4. **Categorie speciali** (lavoro, casa, servizi finanziari, politica): niente targeting per età e sesso, niente promesse di guadagno, regole di Meta più severe. Controlla `cliente.categoria_speciale`.
5. **Prima e dopo, salute, integratori, alcol, giochi**: regole aggiuntive di Meta. Se il settore è sensibile, cerca l'articolo di aiuto con `ads_get_help_article`.
6. **Niente finta interfaccia**: finti pulsanti, finte notifiche, finti messaggi della piattaforma vengono rifiutati.
7. **Coerenza con la landing**: offerta, prezzo e promessa devono essere gli stessi della pagina di destinazione.

## CTA

Usa solo i valori accettati da Meta (`call_to_action_type`), per esempio `SHOP_NOW`, `LEARN_MORE`, `SIGN_UP`, `BOOK_NOW`, `CONTACT_US`, `GET_OFFER`, `WHATSAPP_MESSAGE`. Nello stesso test la CTA resta uguale per tutte le varianti, così cambia una cosa sola.

## Link e tracciamento

Ogni variante ha un `utm_content` diverso nel link, per esempio `?utm_source=meta&utm_medium=paid&utm_campaign=<campagna>&utm_content=<cartella>_<idea>`. Annotalo in `testi.md`.
