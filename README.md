# Agent Meta Ads

Un agent per Claude Code (e Codex) che lavora sui tuoi account Meta Ads (Facebook e Instagram) come un performance marketer dedicato, un account alla volta:
- ogni mattina ti dice cosa è successo e dove intervenire;
- prepara le modifiche e le creatività nuove;
- le pubblica in pausa.

Funziona per due lavori diversi:
- **vendere o raccogliere contatti**, con un costo per risultato da tenere sotto controllo;
- **farti conoscere**: più persone che vedono i tuoi contenuti, più visite al profilo, più follower, anche solo su Instagram e solo nella tua zona. Qui si parte in pochi minuti, promuovendo i post e i reel che hai già pubblicato.

**Le decisioni restano tue**: l'agent non attiva, non sposta budget, non spende crediti e non cancella nulla senza il tuo sì esplicito.

## Cosa sa fare

| Comando | Cosa fa |
|---|---|
| `/profili` | Su quale account lavorare: scegli un profilo, passa a un altro o aggiungine uno |
| `/onboarding` | Setup iniziale guidato di un profilo: obiettivi, numeri, brand e design system, come lavoriamo |
| `/briefing` | Briefing del mattino: ieri contro gli ultimi 7 e 28 giorni, con le priorità |
| `/interventi` | Trasforma le priorità in mosse (spegnere, scalare, aspettare, ruotare) e le applica una alla volta con il tuo sì |
| `/creativita` | Varianti delle inserzioni migliori o stanche, oppure creatività nuove: idee, testi, immagini, video |
| `/pubblica` | Carica e crea le inserzioni in pausa, poi le attiva solo con il tuo sì |
| `/revisione-settimanale` | Verdetto sulle mosse della settimana, report breve e piano della settimana dopo |
| `/emergenza` | Inserzioni rifiutate, account limitato, spesa anomala, tracciamento rotto, crisi |
| `/audit-mensile` | Controllo completo dell'account (circa 40 punti) |
| `/lancio-campagna` | Nuova campagna da zero, tutto in pausa |
| `/notorieta` | Campagne per farti conoscere: promuove i post e i reel che hai già pubblicato, anche solo su Instagram e solo nella tua zona, e li giudica su visualizzazioni, copertura, visite al profilo e follower |
| `/competitor` | Cosa fanno i concorrenti, dalla Libreria inserzioni di Meta |

Non serve ricordare i comandi: puoi scrivere normalmente ("com'è andata ieri?", "fammi due varianti di questa inserzione").

## Requisiti

- **Claude Code**, dall'app desktop di Claude o da terminale.
- **Accesso all'account pubblicitario Meta**, come amministratore o inserzionista. Va bene anche un account personale, senza Business Manager.
- **ffmpeg**, per lavorare sui video (su Mac: `brew install ffmpeg`). Per i sottotitoli impressi nei video serve una versione con libass, per esempio `brew install ffmpeg-full`.

## Installazione (circa 10 minuti)

1. **Copia la cartella** `meta-ads-agent` dove preferisci.
2. **Apri Claude Code nella cartella.**
   - Dall'app desktop: scegli la cartella come progetto.
   - Da terminale:
     ```bash
     cd percorso/meta-ads-agent
     claude
     ```
3. **Alla prima apertura** Claude Code ti chiede di fidarti della cartella e di approvare il server MCP `meta-ads` del progetto. Approva entrambi: servono per il collegamento a Meta e per i controlli di sicurezza.
4. **Collega Meta.**
   1. Scrivi `/mcp`, scegli `meta-ads` e poi l'autenticazione. Si apre il login di Meta nel browser.
   2. Scegli il business e gli account pubblicitari che vuoi gestire (tutti quelli per cui farai un profilo). Il livello di accesso:
      - **Lettura** basta per briefing, revisioni e audit;
      - **Gestione** serve perché l'agent possa creare inserzioni in pausa e attivarle con il tuo sì.

      Puoi cambiarlo quando vuoi da Impostazioni del Business → Integrazioni aziendali.
   3. Usa il connettore **di questo progetto** (`meta-ads`). Se aggiungi Meta in un altro modo, il nome cambia e i permessi di sicurezza preimpostati non si applicano.
5. **Scrivi "ciao"**: l'agent ti chiede come chiamare il primo profilo (di solito il nome del cliente o dell'account) e cosa vuoi fare. Per vendite e contatti parte l'onboarding completo; se vuoi solo farti conoscere, il percorso breve (vedi sotto).

**Apri sempre Claude Code dentro questa cartella.** I controlli automatici di sicurezza (quelli che bloccano le scritture in sola lettura, le cancellazioni e le chiamate sull'account sbagliato) si attivano solo se la sessione parte da qui. Se usi le skill o il connettore Meta da un'altra cartella, restano le istruzioni ma i blocchi automatici non ci sono.

Il connettore ufficiale Meta (`mcp.facebook.com/ads`) è gratuito durante la beta aperta, lanciata ad aprile 2026. Meta non ha ancora annunciato i costi futuri.

## Più account: un profilo per ciascuno

Ogni account pubblicitario ha il suo **profilo**, cioè una cartella di lavoro in `profili/<nome>/` con configurazione, brand, report, creatività e registro. Così puoi gestire più clienti o più account con lo stesso agent, senza che i dati si mescolino.

- **All'apertura** l'agent ti chiede su quale profilo lavorare. Da quel momento, in quella sessione, legge e scrive solo sull'account di quel profilo: un controllo automatico blocca qualsiasi chiamata su un altro account.
- **Più finestre insieme**: puoi aprire due sessioni su due profili diversi, ognuna resta sul suo.
- **Nuovo account**: dillo all'agent ("aggiungi un account", oppure `/profili`). Crea il profilo da `modello-profilo/` e fa l'onboarding solo per quello.
- **Cambiare account** durante una sessione: chiedilo ("passiamo a …"). L'agent chiude quello che sta facendo e riparte dai file dell'altro profilo.
- I profili restano sul tuo computer: la cartella `profili/` non viene mai caricata su GitHub.

Dal terminale: `./scripts/profili.sh` elenca i profili, `./scripts/nuovo-profilo.sh <nome>` ne crea uno.

## Solo farti conoscere: il percorso breve

Se non vendi online e non raccogli contatti, ma vuoi che più persone vedano i tuoi contenuti e inizino a seguirti, non serve l'onboarding completo. Scrivi per esempio "voglio farmi conoscere su Instagram nella mia zona" oppure `/notorieta`. L'agent ti chiede solo:

- quale account pubblicitario e quale profilo Instagram;
- cosa conta di più per te: follower, video guardati fino in fondo, persone raggiunte o visite al profilo;
- dove: tutto il paese oppure una zona, cioè una città e fin dove vuoi arrivare;
- quanto vuoi spendere al giorno e il massimo al mese;
- quali post o reel promuovere, tra quelli che hai già pubblicato.

Poi ti mostra il piano. Alcune cose da sapere prima:

- **I nomi che vedi in Gestione inserzioni.** L'agent parla per risultati, Meta per obiettivi. La corrispondenza:

  | Vuoi | In Gestione inserzioni si chiama |
  |---|---|
  | Più follower, più visite al profilo | **Traffico**, con destinazione il profilo Instagram |
  | Farti vedere da più persone possibile | **Notorietà**, con obiettivo di rendimento copertura |
  | Far guardare i tuoi reel | **Interazioni**, con le visualizzazioni del video |

  La copertura non è più un obiettivo a sé: oggi sta dentro Notorietà.
- **Una zona piccola è un pubblico piccolo.** Le stesse persone vedranno i tuoi contenuti più volte: è normale. La zona è un cerchio attorno a un punto, e vicino a un confine può comprendere un pezzo di un altro stato: l'agent te lo dice prima.
- **Con pochi euro al giorno** si parte con pochi contenuti (tre) e servono più di due settimane per avere numeri su cui ragionare.
- **Se un reel dice "commenta e ti mando…"**, sponsorizzarlo porta commenti nuovi sul post originale. Se rispondi con un automatismo, controlla che copra anche i post vecchi: molti seguono solo quelli recenti.
- **Contenuti fatti con l'AI**: l'agent ti chiede, per ogni contenuto, se dichiararlo. Dopo la creazione non si cambia.
- **Chi paga e chi beneficia**: nell'Unione Europea questi due nomi compaiono accanto all'inserzione. Se il tuo account non appartiene a un Business, l'agent te li chiede.
- **Modalità bozza.** Su alcuni account le inserzioni non nascono "in pausa" ma come bozza: in quel caso pubblicare vuol dire attivare, e la spesa parte. L'agent te lo dice prima di chiederti il sì.
- **Sola lettura.** Un profilo nuovo parte in sola lettura: l'agent prepara tutto ma non crea nulla. Per fargli creare la campagna devi dirgli tu "passiamo alla gestione con conferma". Da lì crea e attiva, sempre con un tuo sì per ogni passaggio. Se preferisci, resti in sola lettura e crei la campagna a mano seguendo il suo piano.

Nei report trovi, per ogni contenuto, quanto ha speso, quanti follower ha portato e il costo per follower. L'onboarding completo lo fai quando vorrai lanciare campagne di vendita.

## Usarlo con Codex

L'agent funziona anche con Codex: legge le stesse istruzioni (`AGENTS.md`), le stesse skill (`.agents/skills`, che punta a `.claude/skills`) e usa gli stessi controlli di sicurezza (`.codex/hooks.json`). Il connettore Meta è in `.codex/config.toml`. Avvia Codex **dalla cartella dell'agent**, perché i controlli si trovano a partire da lì.

## Il primo avvio di un profilo: l'onboarding (20-30 minuti)

L'agent ti fa domande a blocchi e legge da solo quello che può:
- l'azienda;
- obiettivo e numeri: costo per risultato o ritorno sulla spesa che vuoi ottenere, margine, budget;
- l'account Meta;
- pubblico, offerte e prove (recensioni, numeri, casi);
- brand e design system;
- strumenti per le creatività;
- come lavoriamo.

**Prepara prima, se puoi:**
- il materiale del brand in `profili/<nome>/cliente/brand/`: brand book, loghi, palette, font, inserzioni passate, recensioni (dettagli nel `LEGGIMI.md` della cartella);
- video e foto grezzi in `profili/<nome>/cliente/materiale/`;
- i tuoi numeri: margine medio, valore medio dell'ordine o del cliente, budget mensile.

La cartella del profilo la crea l'agent all'inizio dell'onboarding. Alla fine trovi tutto lì: `cliente/config.yaml` (obiettivi, soglie, account), `cliente/brand-profile.md` (il profilo del brand) e `report/onboarding.md` (la fotografia dell'account).

**I primi 14 giorni sono in sola lettura** (consigliato): l'agent fa i briefing e propone, ma non tocca nulla. Confronta i suoi numeri con Ads Manager. Quando ti fidi, digli "passiamo alla gestione con conferma". Puoi dirglielo anche prima: è una scelta tua, e l'agent non la fa mai al posto tuo.

## Come approvi le modifiche

Prima di ogni modifica l'agent ti mostra:
- cosa cambia;
- il valore attuale e quello nuovo;
- perché lo propone;
- il rischio;
- come tornare indietro.

Tu rispondi nominando cosa approvi, per esempio "sì alla mossa 1". Le creatività hanno due passaggi separati: prima si **creano in pausa** e vedi l'anteprima, poi si **attivano**.

## La sicurezza, in tre livelli

1. **Le istruzioni dell'agent** (`AGENTS.md`, che `CLAUDE.md` richiama): un account alla volta, un sì per ogni modifica, tutto in pausa, mai cancellare, budget con aumenti graduali, nessuna spesa di crediti senza preventivo.
2. **I permessi** (`.claude/settings.json`):
   - le letture sono libere;
   - ogni scrittura su Meta chiede conferma anche a Claude Code;
   - cancellazioni, liste clienti, pixel e cataloghi sono vietati.
3. **I controlli automatici** (`.claude/hooks/`):
   - finché non scegli un profilo bloccano ogni chiamata su un account;
   - bloccano le chiamate su account che non sono del profilo scelto;
   - in fase di sola lettura bloccano qualsiasi scrittura;
   - bloccano sempre cancellazioni e archiviazioni;
   - durante una crisi (`blocco_lanci: true`) bloccano i lanci.

   Ogni scrittura eseguita finisce in `profili/<nome>/registro/azioni-meta.jsonl`.

   Questo terzo livello funziona **solo se Claude Code (o Codex) è stato aperto nella cartella dell'agent**: i controlli sono file di questa cartella e vengono caricati all'avvio della sessione. Da un'altra cartella non partono.

## Briefing automatico ogni mattina (facoltativo)

Il computer deve essere acceso all'orario scelto, e il connettore Meta già autenticato.

- **App desktop di Claude**: crea un'attività programmata sul progetto, ogni mattina, con il prompt `/briefing del profilo <nome>`. Un'attività per profilo.
- **Mac, da terminale**: usa `scripts/briefing-programmato.sh` con launchd. Senza argomenti fa il briefing di tutti i profili pronti, uno alla volta; con dei nomi, solo di quelli. Le istruzioni sono in `scripts/briefing.plist.example`.
- **Linux**: una riga di cron, per esempio:
  ```bash
  45 7 * * * /percorso/meta-ads-agent/scripts/briefing-programmato.sh
  ```

Il report finisce in `profili/<nome>/report/briefing/AAAA-MM-GG.md`. Il briefing automatico **non può scrivere su Meta**: senza una persona che approva, le scritture vengono negate.

## Altri connettori utili (facoltativi)

- **Generazione immagini**: un connettore di un generatore di immagini che usi già. Aggiungilo a Claude Code e indica lo strumento nel `cliente/config.yaml` del profilo (`creativita.generatore_immagini`). L'agent ti mostrerà sempre il costo prima di generare.
- **Figma, Canva o Google Drive**: se il tuo design system è lì, l'agent lo legge durante l'onboarding.

Senza generatore di immagini l'agent lavora lo stesso. Prepara testi, idee, prompt e brief per il grafico, e monta i video dal materiale che hai.

## Caricare immagini e video su Meta

Il connettore Meta accetta i file solo da un link pubblico diretto. Puoi scegliere tre modi, impostati in `creativita.caricamento_media`:

1. **`manuale`** (predefinito): l'agent prepara i file in `profili/<nome>/creativita/`, tu li carichi nella libreria multimediale di Ads Manager e l'agent li ritrova per nome.
2. **`sito_cliente`**: metti i file in una cartella pubblica del tuo sito e indichi l'indirizzo base in `creativita.url_base_media`.
3. **`supabase`**: un bucket pubblico su Supabase.
   1. Copia `.env.example` in `.env` e compila i dati.
   2. L'agent usa `scripts/carica-media-supabase.sh`.

   Usa un progetto e un bucket dedicati: tutto quello che c'è dentro è pubblico.

## Com'è fatta la cartella

```
meta-ads-agent/
├── AGENTS.md              istruzioni dell'agent (CLAUDE.md le richiama)
├── .mcp.json              connettore Meta ufficiale
├── .claude/
│   ├── settings.json      permessi e controlli automatici
│   ├── hooks/             controlli di sicurezza e registro delle azioni
│   └── skills/            i flussi di lavoro (un comando ciascuno)
├── .agents/skills         le stesse skill, per Codex
├── .codex/                connettore e controlli per Codex
├── modello-profilo/       lo stampo di ogni nuovo profilo
├── profili/               un profilo per account pubblicitario (resta sul tuo computer)
│   └── <nome>/
│       ├── cliente/
│       │   ├── config.yaml        obiettivi, soglie, account, preferenze
│       │   ├── brand-profile.md   profilo del brand (lo scrive l'onboarding)
│       │   ├── brand/             il materiale di brand
│       │   └── materiale/         video e foto grezzi
│       ├── report/        briefing, report settimanali, audit, competitor
│       ├── creativita/    una cartella per ogni lotto di creatività, con anteprima
│       └── registro/      decisioni, creatività pubblicate, lezioni, azioni su Meta
└── scripts/               profili, strumenti video, caricamento media, briefing programmato
```

## Domande frequenti

**Posso gestire più account pubblicitari?**
Sì, con un profilo per ciascuno (vedi "Più account"). All'apertura scegli su quale lavorare.

**Posso cambiare le soglie (frequenza, costo massimo…)?**
Sì, nel `cliente/config.yaml` del profilo: ogni account ha le sue. I valori iniziali sono regole pratiche. Dopo 4 settimane di dati la revisione settimanale ti propone di tararle sul tuo account, prodotto per prodotto: per esempio quale frequenza è normale per il tuo pubblico. Le cambia solo con il tuo sì.

**La frequenza alta è sempre un problema?**
No. Su un pubblico piccolo (locale, di nicchia) è normale che la stessa persona veda l'inserzione 3 o 4 volte. L'agent considera stanca un'inserzione solo se, insieme alla frequenza, peggiorano anche i risultati: CTR in calo e costo per risultato in salita.

**Vendo prodotti o servizi diversi, con margini diversi. Come fa l'agent a giudicarli?**
Ogni prodotto ha una sua scheda nel `cliente/config.yaml` del profilo (sezione `prodotti`): risultato, valore medio, margine, costo di pareggio e obiettivo. Le campagne portano l'etichetta del prodotto nel nome, per esempio `[CORSI] Contatti`, e ognuna si giudica con l'obiettivo del suo prodotto. Quando lanci una campagna per un prodotto che ha già una scheda, l'agent non rifà le domande: ti mostra i numeri che conosce, con la data dell'ultima conferma, e ti chiede se valgono ancora.

**Voglio solo farmi conoscere e avere più follower, non contatti. Funziona lo stesso?**
Sì, con `/notorieta`, anche senza onboarding completo (vedi "Solo farti conoscere: il percorso breve"). Queste campagne non hanno un costo per contatto: l'agent promuove i contenuti che hai già pubblicato e li giudica su quanto vengono guardati e su quanto costa raggiungere una persona o guadagnare un follower. Tre cose da sapere:
- il costo obiettivo non si decide a tavolino: nelle prime due settimane l'agent misura i tuoi numeri, poi ti propone un riferimento da confermare;
- Meta non ha un'ottimizzazione "per follower": si ottimizza per visite al profilo, visualizzazioni o copertura, e i follower si contano dopo. L'agent vede quelli portati dalle inserzioni, non la crescita totale del profilo;
- per non mostrare i contenuti a chi ti segue già servono pubblici personalizzati, che crei tu in Gestione inserzioni: l'agent li usa ma non può crearli.

**Cerco l'obiettivo "Copertura" e non lo trovo. E "Traffico" non era per i siti?**
La copertura oggi è dentro l'obiettivo Notorietà. Traffico serve anche per portare persone sul profilo Instagram, ed è la strada per i follower. Di' all'agent cosa vuoi ottenere, con parole tue o con il nome di Meta: nel piano trovi tutti e due.

**Dove vedo cosa ha fatto l'agent?**
Nella cartella `registro/` di ogni profilo:
- `decisioni.md`: ogni mossa, con il verdetto;
- `azioni-meta.jsonl`: ogni scrittura su Meta, registrata in automatico;
- `creativita.md`: ogni creatività.

**L'agent può spendere soldi da solo?**
No:
- attivare inserzioni e cambiare budget richiedono il tuo sì;
- generare immagini con servizi a pagamento richiede un preventivo approvato;
- il limite di spesa dell'account non lo può toccare.

**Meta cambia spesso: e se il connettore cambia?**
Il connettore è in beta e i nomi dei comandi possono cambiare. L'agent legge sempre le istruzioni aggiornate del connettore. Se un comando cambia nome, va aggiornato l'elenco dei permessi in `.claude/settings.json`.

## Licenze

Alcune regole e procedure sono adattate da progetti open source con licenza MIT: l'elenco è in `THIRD_PARTY_LICENSES.md`.
