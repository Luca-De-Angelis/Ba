# Le regole che toccano il codice

Le regole di prodotto che chi scrive il codice deve rispettare, in forma operativa: che cosa si fa e che cosa non si fa, **con il rimando alla decisione** e, dove esiste, al punto del codice che la fa rispettare. Non sono decisioni nuove: ogni riga viene da [`DECISIONS.md`](../DECISIONS.md), da `BaRegole` in [`tokens.dart`](../../app/lib/design_system/tokens.dart) o da [`CLAUDE.md`](../../CLAUDE.md). Una decisione non si cambia: se una regola ti sembra sbagliata, ci si ferma e si chiede.

Torna all'[indice](README.md). Le ipotesi che ancora non sono regole sono in [aperte](aperte.md).

**Una avvertenza onesta.** Molte regole riguardano parti dell'app che **non esistono ancora** (connessione, audio, superfici di sistema, accesso): per quelle la colonna «Nel codice oggi» lo dice. La regola vale comunque per chi le costruirà.

## Le otto regole di `BaRegole`

`BaRegole` è una classe senza codice: contiene solo i commenti con le otto regole «che nessun valore può portare da solo». Il file dice che cinque non si possono più violare perché manca lo strumento per violarle (3, 4, 6, 7, 8), due diventano irrappresentabili nel livello dei widget (1 e 5) e una resta convenzione (la 2).

| N. | Che cosa si fa | Nel codice oggi |
| --- | --- | --- |
| 1 | **La pillola «chiara» solo dove l'app non può proseguire senza quel gesto**, che nessun altro può fare al posto dell'utente («Sali sul palco», «Accendi il microfono»). **Una per schermata.** Tutto il resto è hairline | `BaVariantePillola.chiara` ([`pillola.dart`](../../app/lib/design_system/pillola.dart)). `BaBarraAzioni` ha un assert in debug se ce n'è più di una; `BaFoglio.richiesta` la usa per la prima azione. «Spegni il microfono» è `attiva`, non chiara |
| 2 | **Mai il solo colore.** Nessuna informazione affidata solo alla tinta | È la convenzione che non si può imporre con un tipo: va guardata in revisione. Esempi nel codice: il microfono spento è un **disco con un glifo** (forma, non colore); l'errore ha filetto, segno «!» e testo ([`messaggio.dart`](../../app/lib/design_system/messaggio.dart)); la voce ha un anello |
| 3 | **Il tempo è un fatto fermo, mai un conto alla rovescia.** Si mostra l'ora d'inizio, non i minuti trascorsi; nessun contatore che accumula. In alpha le memorie dichiarate sono tre (il blocco che dai, il profilo derivato alla registrazione, il testo trascritto di chi parla) | Non esiste un formattatore di durate: c'è solo `BaOra.hhmm`. `BaCodaTokens.oraDelPosto` dà un'ora e non promette mai più del reale (troncata al minuto; sotto i due minuti non dà nessuna ora) |
| 4 | **Fuori dall'app l'anello sta sulla stanza, fermo; dentro sta sulla persona e segue la voce** | `BaPayloadStanza` **non ha** un campo «chi parla»: fuori dall'app quel dato non si aggiorna abbastanza spesso per essere vero |
| 5 | **Il palco ha una dimensione sola per volta**: dimensioni diverse fra le persone sono rango | `BaPresenza` non ha un parametro di diametro: lo eredita dal palco con `BaDiametro` |
| 6 | **L'errore non ha una variante riempita, e non esiste un colore «successo»** | `BaColorTokens` ha `erroreTesto` ed `erroreFiletto`, nessun `erroreFondo`; `messaggio_test.dart` prova che l'errore non ha fondo |
| 7 | **Nessuna ombra, nessuna elevazione**: le superfici si distinguono per fondo e filetto. L'unica profondità è l'alone dietro il palco | Niente Material né Cupertino nel design system: la CI lo controlla con un grep ([produzione](produzione.md)) |
| 8 | **Le sagome non cedono mai.** Quando lo spazio non basta cedono, in ordine: alone e margini, la scala, le iniziali | `BaPalco` non ha un parametro «quante disegnarne»: prende le persone sul palco e le disegna tutte, anche se la scatola è troppo piccola (`sfora`); il palco non scorre mai |

## Le altre regole, dalle decisioni

| Regola operativa | Decisione | Nel codice oggi |
| --- | --- | --- |
| **Si entra sempre nel pubblico**, e si sale sul palco se c'è posto | D-006 | Solo nei prototipi di design: nessuna logica di ingresso |
| **Si sale sul palco sempre a microfono spento**, anche dalla coda e con l'ingresso automatico | D-007 | Nel design (stato «sta salendo» del 002); `BaMovimentoTokens.salitaAttesaMax` (8 s) dice dopo quanto la salita torna a «Mettiti in coda». Nessuna logica |
| **Ingresso morbido: si arriva senza essere annunciati, ma capendo di essere arrivati.** Chi entra o esce non è mai annunciato | brief v2.1 (vincolo fermo); D-034 | `BaMovimentoTokens.attesaIngresso` (4 s) e `attesaUscita` (6 s) sono le attese prima di riassettare il palco; `BaPalco` non ha movimento di ingresso (l'assestamento animato è rimandato) e c'è lo stato `scheletro` mentre si entra |
| **Lo screen reader annuncia i cambi di stato di chi usa l'app** (il proprio microfono, la salita sul palco, la parola ricevuta o revocata, la linea persa e ripresa) e **mai l'ingresso o l'uscita di altre persone né il loro stato**: si leggono sul palco | D-034 (sostituisce «ogni cambio di stato del palco viene annunciato») | Nel codice non c'è **nessun annuncio** (nessuna chiamata a `SemanticsService.announce`): l'unico annuncio è la regione viva di `BaMessaggio` quando è un errore. Gli annunci dei propri cambi di stato sono da costruire |
| **Da lock screen e notifica Android il microfono si può solo spegnere, mai riaccendere.** Lo stato spento è informativo; resta «Esci» | D-025 | Nessun codice: riguarda le superfici di sistema (Live Activity, Dynamic Island, notifica), che non esistono ancora. Il payload `BaPayloadStanza` non porta azioni |
| **Quando cade la connessione il microfono si spegne, e alla ripresa resta spento**: lo stato del microfono appartiene alla connessione. Per questo suono e vibrazione di connessione persa sono sicuri | D-029 | `BaApticaTokens.connessioneRipresa` è la firma di «spento»; `BaStatoPalco.congelato` e la presenza «persa» mostrano la linea persa. Nessuna logica di connessione |
| **Un suono mentre il microfono è aperto finisce nella stanza**: i tre suoni valgono solo a microfono spento (nel sotto-DEN, con almeno uno dei due microfoni aperto, nessun suono) | D-029 e `suono-e-vibrazione.md` | `BaSuonoTokens.consentito({microfonoAcceso})` rende il caso contrario irrappresentabile. Nessun codice di suono né di vibrazione esiste: solo i token ([produzione](produzione.md)) |
| **Si diventa partecipante dal palco**: «Sali sul palco», avviso su voce e testo, consenso, e si sale a microfono spento. L'account di base è da ascoltatore, con codice via email | D-024, D-031 (sostituisce D-002) | Solo i token di accesso (`BaAccessoTokens`) e il prototipo 013: nessuna logica |
| **«Torna ascoltatore»** ritira il consenso a parlare: non si parla più e, se si sta parlando, si esce dalla stanza | D-003 | Nessun codice |
| **Nessuna conversazione si può riascoltare.** La voce si salva per poco tempo per trascriverla, poi si cancella; il testo resta per un periodo. L'interfaccia lo dichiara all'onboarding, quando si diventa partecipante e nelle impostazioni | D-004, D-013 | Nessun codice; le memorie dichiarate sono le tre della regola 3 |
| **La rimozione di una persona da un DEN non è in alpha** ma esisterà nei DEN privati: non va preclusa | D-005 | Nessun codice |
| **Moderazione interamente AI**, in differita, anche nei DEN pubblici | D-011 | Nessun codice |
| **Se il design diverge da una decisione di prodotto, vince il brief**; le scelte estetiche restano del design | D-001 | — |
| **`tokens.dart` vince sui documenti**; ogni valore citato in un documento esiste lì, con nome e impiego | D-009, D-010 | [architettura](architettura.md) |

## Regole di accessibilità e di layout

| Regola | Decisione o fonte | Nel codice oggi |
| --- | --- | --- |
| **Ogni presenza ha un'etichetta per lo screen reader**; ogni controllo ha la sua, dal chiamante | `CLAUDE.md` | `semanticsLabel` obbligatorio in `BaPresenza`, `BaPersonaPalco`, `BaTouchable`, `BaPillola`; `BaPalco` mette l'ordine di lettura con `OrdinalSortKey` |
| **Aree toccabili di almeno 44** | `CLAUDE.md` | `BaControlloTokens.areaMinima`; `BaTouchable` la porta a 44 nel hit test; le altezze dei controlli sono **minimi, non misure** |
| **Contrasto AA** | `CLAUDE.md` | Nei token di colore; il rispetto va verificato in revisione (**da verificare**: nessun test lo misura) |
| **Rispetto della riduzione delle animazioni**: con «riduci movimento» il movimento è immediato | `CLAUDE.md` | Letto da `MediaQuery` (`disableAnimations`) in `BaTouchable`, `BaAnello`, `BaGlifo`, `BaFoglio` e `BaPresenza`. `BaMovimentoTokens.statico(context)` (che vale anche con la navigazione accessibile) esiste ma oggi nessun componente lo chiama: **da verificare** quale dei due criteri vale |
| **Il testo di sistema arriva fino a 2,0** (il marcatore fino a 1,6): nulla si taglia, ciò che sta sopra le azioni scorre, le azioni restano in basso. Le iniziali non scalano mai | Inventario C6 (Dynamic Type), `token.md` | `BaScalaTokens.maxTesto`, `maxMarcatore`; test a 2,0 in ogni componente |
| **Mobile first, 360 dp il telefono più stretto; il tablet si decide sulla larghezza dello schermo, da 600 dp, mai sull'orientamento** | D-020, D-022, D-027 | `BaLayoutTokens`; per ora solo verticale |
| **Stati critici** (microfono acceso o spento, chi ti sente, parola ricevuta) **mai affidati solo alla vista o solo al colore** | `CLAUDE.md` | Disco e glifo per il microfono spento; vedi la regola 2 |

## Regole di lavoro sul codice

| Regola | Fonte |
| --- | --- |
| Il lessico è quello di [`GLOSSARY.md`](../GLOSSARY.md): mai «Loggia» (si dice sotto-DEN), «abbassa/abbassata» (si dice muta/mutata), «Mutami» (si dice spegni il microfono) | D-008 |
| `Ba<Componente>` per i widget, `…Tokens` per le classi di token; `BaOra`, `BaPayloadStanza`, `BaRegole` restano senza suffisso | D-021, D-028 |
| Nessuna stringa fissa nell'interfaccia: tutto in `app/lib/l10n/`, in cinque lingue; il tedesco allunga fino al 30% | `CLAUDE.md` |
| Nessun audio con voci vere nella repo (i test usano file sintetici); chiavi e credenziali solo in `.env`, mai committate | `CLAUDE.md`; `.gitignore` |
| Un branch per task, mai commit diretti su `main`; piano prima del codice; commit piccoli; report prima della pull request | `CLAUDE.md`, `README.md` della radice |
| Il web serve solo come galleria di sviluppo; i target restano iOS e Android | D-030 |
| Se un task chiede di cambiare una decisione, **ci si ferma e si chiede** | `CLAUDE.md` |
