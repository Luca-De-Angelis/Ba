// I testi del prototipo navigabile (task 024): tutti qui, in italiano, fissi,
// presi dai prototipi 001, 002, 013, 014 e 027. Il prototipo è uno strumento di
// sviluppo e di dimostrazione (D-030): niente l10n, e un solo file per i testi, così
// si leggono e si correggono insieme. Nessun numero di telefono vero: 320 000 0000.
//
// I testi dei componenti del design system arrivano da qui: il design system non
// conosce le traduzioni.

/// I testi, per gruppo. Una classe sola, tutta statica.
abstract final class T {
  // ------------------------------------------------------------- generale
  static const String nonOra = 'Non ora';
  static const String indietro = 'Indietro';
  static const String chiudi = 'Chiudi';
  static const String continua = 'Continua';
  static const String esci = 'Esci';

  // ------------------------------------------------------------- accesso (013)
  static const String emailNome = 'Accesso: email';
  static const String emailTitolo = 'La tua email';
  static const String emailEtichetta = 'Email';
  static const String emailSegnaposto = 'nome@esempio.it';
  static const String emailAiuto = 'Ti mandiamo un codice. Niente password.';
  static const String emailErrore = 'Questa email non sembra giusta. Controllala e riprova.';
  static const String emailAzione = 'Ricevi il codice';
  static const String continuaConTitolo = 'Qui, dopo l\'alpha: «Continua con…»';
  static const String continuaConSottotitolo = 'punto di aggancio';

  static const String codiceNome = 'Accesso: codice';
  static const String codiceTitolo = 'Il codice';
  static String codiceFrase(String email) => 'Mandato a $email.';
  static String codiceFraseNuovo(String email) => 'Nuovo codice mandato a $email.';
  static const String codiceEtichetta = 'Codice di sei cifre';
  static const String codiceSbagliato = 'Il codice non è giusto. Controlla l\'email e riprova.';
  static const String codiceScaduto = 'Il codice è scaduto. Te ne mandiamo uno nuovo.';
  static const String codiceAttesa = 'Ne puoi chiedere un altro fra poco.';
  static const String mandaDiNuovo = 'Mandalo di nuovo';
  static const String conferma = 'Conferma';
  static const String mandaNuovoCodice = 'Manda un nuovo codice';

  static const String onboardingNome = 'Accesso: prima di entrare';
  static const String onboardingTitolo = 'Prima di entrare';
  static const String onboarding1 = 'Nessuna conversazione si può riascoltare.';
  static const String onboarding2 =
      'Quando qualcuno parla, la sua voce si salva per poco tempo, solo per trascriverla. Poi si cancella.';
  static const String onboarding3 = 'Il testo trascritto resta per un periodo.';
  static const String hoCapito = 'Ho capito';

  static const String terminiNome = 'Accesso: termini e privacy';
  static const String terminiTitolo = 'Termini e privacy';
  static const String termini1 = 'Per usare BA servono i termini d\'uso e l\'informativa sulla privacy.';
  static const String leggiTermini = 'Leggi i termini';
  static const String leggiInformativa = 'Leggi l\'informativa';
  static const String termini2 =
      'Toccando «Accetto» dichiari di avere almeno 18 anni e accetti i termini e l\'informativa.';
  static const String termini3 = 'Per parlare, ti chiediamo il consenso quando sali sul palco.';
  static const String accetto = 'Accetto';

  static const String nicknameNome = 'Accesso: nickname';
  static const String nicknameTitolo = 'Scegli un nickname';
  static const String nicknameEtichetta = 'Nickname';
  static const String nicknameSegnaposto = 'nickname';
  static const String nicknameFrase = 'Lo vedono le altre persone. Può essere uguale a quello di altre persone.';
  static const String nicknameErrore = 'Scegli un nickname per continuare.';

  // ------------------------------------------------------------- elenco (013, 014)
  static const String elencoNome = 'Elenco dei DEN';
  static const String elencoTitolo = 'DEN';
  static const String seiAscoltatore = 'sei ascoltatore';
  static const String seiPartecipante = 'sei partecipante';
  static const String creaUnDen = 'Crea un DEN';
  static const String impostazioniRiga = 'Impostazioni';

  // ------------------------------------------------------------- stanza (002)
  static String stanzaEtichettaPalco(int n) => n == 0 ? 'Palco vuoto' : 'Palco, $n persone';
  static const String palcoLibero = 'Il palco è libero.';
  static const String palcoInvito = 'Puoi salire quando vuoi.';
  static const String saliSulPalco = 'Sali sul palco';
  static const String accendiMic = 'Accendi il microfono';
  static const String spegniMic = 'Spegni il microfono';
  static const String scendiDalPalco = 'Scendi dal palco';
  static const String altro = 'Altro';
  static const String saliraiMicSpento = 'Salirai a microfono spento.';
  static const String seiInAscolto = 'Sei in ascolto';
  static const String tuMicSpento = 'Tu · microfono spento';
  static const String tuMicAcceso = 'Tu · microfono acceso';
  static String suIlPalco(int n) => n == 0 ? 'Nessuno sul palco' : '$n sul palco';
  static String inAscolto(int n) => '$n in ascolto';
  static String marcatoreDen(String base, int sulPalco) =>
      sulPalco == 0 ? '$base · vuoto' : '$base · $sulPalco sul palco';

  // La scheda di una persona (002 · 6)
  static const String schedaMuta = 'Muta questa voce';
  static const String schedaMutaNonDisponibile = 'Si può mutare solo mentre parla';
  static const String schedaBlocca = 'Blocca';
  static const String schedaSegnala = 'Segnala';
  static const String schedaSulPalco = 'Sul palco';
  static const String schedaSulPalcoMicSpento = 'Sul palco · microfono spento';

  // ------------------------------------------------------------- diventa partecipante (013, 014)
  static const String partecipanteNome = 'Diventa partecipante';
  static const String paAvvisoTitolo = 'Vuoi salire sul palco?';
  static const String paAvvisoCreaTitolo = 'Per creare un DEN bisogna diventare partecipante';
  static const String paAvvisoSali =
      'Per parlare bisogna diventare partecipante. Servono un numero di telefono verificato e il consenso a parlare.';
  static const String paAvvisoCrea = 'Servono un numero di telefono verificato e il consenso a parlare.';
  static const String paAvviso2 =
      'Mentre parli, la tua voce si registra per poco tempo e si trascrive; il testo serve alla moderazione e a costruire il tuo profilo.';
  static const String paAvviso3 =
      'Nessuna conversazione si può riascoltare. La voce si cancella dopo la trascrizione, il testo resta per un periodo.';
  static const String paNumeroTitolo = 'Il tuo numero';
  static const String paNumeroEtichetta = 'Numero di telefono';
  static const String paNumeroPrefisso = '+39';
  static const String paNumeroSegnaposto = '320 000 0000';
  static const String paNumeroNota = 'Ti mandiamo un codice per SMS. Il numero serve solo per parlare.';
  static const String paNumeroErrore = 'Scrivi il tuo numero di telefono.';
  static const String paNumeroAzione = 'Ricevi il codice';
  static const String paCodiceTitolo = 'Il codice';
  static const String paCodiceFrase = 'Mandato al +39 ••• ••• 0000.';
  static const String paCodiceSbagliato = 'Il codice non è giusto. Controlla gli SMS e riprova.';
  static const String paConsensoTitolo = 'Vuoi parlare?';
  static const String paConsenso1 = 'Acconsenti che, mentre parli, la tua voce si registri per poco tempo e si trascriva.';
  static const String paConsenso2 = 'Con il consenso il tuo account passa da ascoltatore a partecipante.';
  static const String paConsensoSali = 'Acconsento e salgo';
  static const String paConsensoCrea = 'Acconsento e continuo';
  static const String indietroDiProva = 'Indietro (di prova)';

  // ------------------------------------------------------------- impostazioni (001, 013)
  static const String impostazioniNome = 'Impostazioni';
  static const String impostazioniTitolo = 'Impostazioni';
  static const String lingua = 'Lingua';
  static const String italiano = 'Italiano';
  static const String microfono = 'Microfono';
  static const String consentito = 'Consentito';
  static const String personeBloccate = 'Persone bloccate';
  static String nPersone(int n) => n == 1 ? '1 persona' : '$n persone';
  static const String tornaAscoltatore = 'Torna ascoltatore';
  static const String tornaConseguenza =
      'Cambia il tipo di account: da partecipante ad ascoltatore. Non potrai più parlare. Se stai parlando, esci dalla stanza.';
  static const String seiAscoltatoreRiga = 'Sei ascoltatore';
  static const String seiAscoltatoreNota = 'Per parlare di nuovo, sali sul palco di un DEN e dai il consenso.';
  static const String esciDaBa = 'Esci da BA';

  static const String t2Titolo = 'Tornare ascoltatore?';
  static const String t2Frase1 = 'Il tuo account passa da partecipante ad ascoltatore. Non potrai più parlare.';
  static const String t2Frase2 = 'Se stai parlando, esci dalla stanza.';
  static const String t3Titolo = 'Confermi?';
  static const String t3Frase = 'Per parlare di nuovo dovrai dare di nuovo il consenso.';

  static const String bloccateNome = 'Persone bloccate';
  static const String bloccateTitolo = 'Persone bloccate';
  static const String bloccateGruppo = 'bloccate da te';
  static const String bloccateNota = 'Restano finché non le sblocchi.';
  static const String sblocca = 'Sblocca';

  // ------------------------------------------------------------- la coda (015)
  static const String mettitiInCoda = 'Mettiti in coda';
  static const String mettitiFrase = 'Il palco è pieno. Se si libera un posto, te lo diciamo.';
  static const String ingressoTitolo = 'Fammi entrare automaticamente';
  static const String ingressoSpento = 'Quando si libera un posto, la notifica ti porta alla stanza.';
  static const String ingressoAcceso = 'Quando si libera un posto, sali da solo.';
  static const String aspettaTitolo = 'Aspetta con altri';
  static const String aspettaDescrizione = 'Un gruppo di chi aspetta, fino a 8. Non è il palco.';
  static const String acceso = 'Acceso';
  static const String spento = 'Spento';
  static const String aspettaP1 =
      'Un gruppo di chi aspetta come te, fino a 8. Sentite il DEN e parlate fra voi. Dal palco nessuno vi sente.';
  static const String aspettaP2 = 'Quando si libera un posto, lasci il gruppo e sali sul palco, a microfono spento.';
  static const String entraNelGruppo = 'Entra nel gruppo';
  static const String fasciaAttesa = 'Parli al gruppo di chi aspetta. Il palco non ti sente.';
  static const String lasciaIlGruppo = 'Lascia il gruppo';
  static const String codeTitolo = 'Le tue code';
  static const String codeFrase = 'Ti avvisiamo quando si libera un posto.';
  static const String codeStato = 'In coda · entri a microfono spento';
  static const String esciDallaCoda = 'Esci dalla coda';
  static const String codaPienaTitolo = 'La coda è piena adesso';
  static const String codaPienaFrase = 'Resti nel pubblico e ascolti. Riprova fra poco.';
  static const String inCoda = 'In coda';

  // Il posto offerto (K4, K4 bis, K5) e «Vuoi passare di qua?» (K6)
  static const String postoOfferto = 'Si è liberato un posto sul palco. Hai pochi secondi per salire. Salirai a microfono spento.';
  static const String postoScaduto = 'Il posto è passato alla persona dopo di te. Resti in coda.';
  static String bannerPosto(String den) => '$den · Si è liberato un posto sul palco. Hai pochi secondi per salire.';
  static String passaTitolo(String den) => 'Si è liberato un posto in $den';
  static const String passaP1 = 'Vuoi passare di qua? Salirai a microfono spento.';
  static const String passaP2 = 'Hai pochi secondi per decidere.';
  static const String passa = 'Passa';
  static const String restaQui = 'Resta qui';
  static String bannerRichiamo(String chi, String den) => "In $den c'è $chi · vuoi passare?";
  static String richiamoTitolo(String chi, String den) => "In $den c'è $chi";
  static const String richiamoP1 = 'Vuoi passare di qua? Entri ad ascoltare.';
  static const String ciccio = 'Ciccio';
  static const String seiInCoda = 'Sei in coda';

  // La linea persa (015 P1–P3)
  static const String lineaPersaBanda = 'Hai perso la linea. Il posto resta tuo ancora per un momento.';
  static const String lineaPersaSotto = 'Il microfono è spento.';
  static const String sentoDiNuovo = 'Sto riprovando…';
  static const String ritornoP2 = 'Sei di nuovo in linea. Il tuo posto c\'era: sei sul palco, a microfono spento.';
  static const String ritornoP3 = 'Sei di nuovo in linea. Il tuo posto sul palco è stato preso: sei fra il pubblico.';

  // ------------------------------------------------------------- creare un DEN (014)
  static const String creaNome = 'Crea un DEN';
  static const String creaTipoTitolo = 'Che DEN vuoi creare?';
  static const String creaPrivato = 'Privato';
  static const String creaPrivatoDescr = 'Entra chi inviti.';
  static const String creaPubblico = 'Pubblico';
  static const String creaPubblicoDescr = 'Entra chiunque. Si trova nell\'elenco.';
  static const String creaTipoSotto = 'Lo gestisci tu, con i co-amministratori che scegli.';
  static const String creaNomeTitolo = 'Come si chiama?';
  static const String creaNomeEtichetta = 'Nome del DEN';
  static const String creaNomeSegnaposto = 'Cena senza fretta';
  static const String creaNomeErrore = 'Scrivi un nome per il DEN.';
  static const String creaQuando = 'Quando';
  static const String creaQuandoTitolo = 'Adesso';
  static const String creaQuandoSotto = 'Spento. Si accende più avanti, per chi crea DEN programmati.';
  static const String creaDettagliTitolo = 'Descrizione, tema e lingua';
  static const String creaDescrizione = 'Descrizione';
  static const String creaDescrizioneSegnaposto = 'Due chiacchiere dopo cena, senza un argomento fisso.';
  static const String creaTema = 'Tema';
  static const String creaLingua = 'Lingua';
  static const List<String> temi = ['Chiacchiere', 'Musica', 'Libri', 'Cucina', 'Notte', 'Sport', 'Lavoro', 'Imparare'];
  static const List<String> lingue = ['Italiano', 'Deutsch'];
  static const String creaInvitatiTitolo = 'Chi inviti?';
  static const String creaInvitatiFrase = 'Un DEN privato si apre solo a chi inviti.';
  static const String invita = 'Invita';
  static const String nellInvito = 'Nell\'invito';
  static const String cerca = 'Cerca';
  static const String cercaSegnaposto = 'Nickname, alias, email o numero';
  static const String invitatiNessuno = 'Nessuno nell\'invito. Puoi invitare anche dopo.';
  static String invitatiN(int n) => n == 1 ? '1 persona nell\'invito.' : '$n persone nell\'invito.';
  static const String personeAggiunte = 'Persone che hai aggiunto';
  static const String creaRiepilogoTitolo = 'Tutto pronto?';
  static const String tipo = 'Tipo';
  static const String nome = 'Nome';
  static const String invitati = 'Invitati';
  static const String creaIlDen = 'Crea il DEN';
  static const String nonCreatoTitolo = 'Il DEN non è stato creato';
  static const String nonCreatoErrore = 'Non è stato possibile aprirlo. Controlla la connessione e riprova.';
  static const String nonCreatoNota = 'Quello che hai scritto è ancora qui.';
  static const String riprova = 'Riprova';
  static String seiAmministratore(String den) => 'Hai creato $den. Sei amministratore.';

  // «Gestisci» (014 G1–G5) e il sotto-DEN (D1)
  static const String gestisci = 'Gestisci';
  static const String gestisciTitolo = 'Gestisci il DEN';
  static const String descrizione = 'Descrizione';
  static const String coAmministratori = 'Co-amministratori';
  static const String coAmministratoriSotto = 'Chi ti aiuta a gestire il DEN';
  static String limiteDi(int n, int max) => '$n di $max';
  static const String personeNelDen = 'Persone nel DEN';
  static const String personeNelDenSotto = 'Rimuovi chi non deve restare';
  static const String terminaDen = 'Termina il DEN';
  static const String terminaSotto = 'Tutte le persone escono dalla stanza.';
  static const String salva = 'Salva';
  static const String coAmmFrase = 'Un co-amministratore gestisce il DEN con te. Puoi averne uno.';
  static const String coAmmFraseSelettore = 'Puoi averne uno. Sceglilo fra le persone che hai aggiunto.';
  static String coAmmLimite(String nome) => 'Hai raggiunto il limite di co-amministratori. Per aggiungerne un altro, togli $nome.';
  static String coAmmLimiteSceglie(String nome) => 'Hai raggiunto il limite di co-amministratori. Per sceglierne un altro, togli $nome.';
  static const String aggiungiCoAmm = 'Aggiungi un co-amministratore';
  static const String scegli = 'Scegli';
  static const String scelto = 'Scelto';
  static const String togli = 'Togli';
  static const String rimuovi = 'Rimuovi';
  static String rimuoviTitolo(String nome) => 'Rimuovere $nome?';
  static String rimuoviFrase(String nome) => '$nome esce dal DEN.';
  static const String terminaTitolo = 'Terminare il DEN?';
  static const String terminaFrase = 'Tutte le persone escono dalla stanza.';
  static const String coAmministratore = 'co-amministratore';
  static const String sulPalco = 'sul palco';
  static const String sottoDenNuovo = 'Nuovo sotto-DEN';
  static const String sottoDenEtichetta = 'Nome del sotto-DEN';
  static const String sottoDenSegnaposto = 'Tavolo 2';
  static const String sottoDenErrore = 'Scrivi un nome per il sotto-DEN.';
  static const String sottoDenFrase = 'Fino a 8 persone. Sente il DEN e parla al proprio gruppo.';
  static const String sottoDenNota = 'Chi ne fa parte lo scegli dopo, dalla stanza.';
  static const String creaSottoDen = 'Crea il sotto-DEN';
  static String sottoDenCreato(String nome) => 'Sotto-DEN: $nome';

  // ------------------------------------------------------------- il permesso del microfono (001, Fase 2)
  static const String micNegata = 'Negato — senza il microfono non puoi parlare';
  static const String apri = 'Apri';
  static const String micFaseTitolo = 'Senza microfono non posso farti parlare';
  static const String micFaseP1 =
      'Il permesso è chiuso nelle impostazioni del telefono, non qui. Puoi restare ad ascoltare quanto vuoi: per gli altri non cambia niente.';
  static const String apriLeImpostazioni = 'Apri le impostazioni';
  static const String restoAdAscoltare = 'Resto ad ascoltare';

  // ------------------------------------------------------------- l'account chiuso (027 B1, B1 bis, B2)
  static const String chiusoTitolo = 'Questo account non può più usare BA';
  static const String chiusoP1 = 'Un contenuto non rispetta le regole di BA.';
  static const String chiusoP2 = 'Se pensi che sia un errore, puoi chiedere una revisione.';
  static const String sospesoTitolo = 'L\'accesso a BA è sospeso';
  static const String sospesoP1 = 'Un contenuto non rispetta le regole di BA.';
  static const String sospesoRiga = 'Potrai rientrare il 21 novembre alle 21:40.';
  static const String sospesoP2 = 'Se pensi che sia un errore, puoi chiedere una revisione.';
  static const String richiediRevisione = 'Richiedi revisione';
  static const String revisioneTitolo = 'Questo account non può più usare BA';
  static const String revisioneP1 = 'Abbiamo ricevuto la richiesta di revisione. Ti scriviamo all\'email dell\'account.';
  static const String richiestaInviata = 'Richiesta inviata';

  // ------------------------------------------------------------- lo schermo bloccato (027 L1–L4, D-050)
  static const String bloccatoSimulazione = 'Schermo bloccato · simulazione';
  static const String bloccatoNessunDen = 'Nessun DEN aperto.';
  static const String micSpentoBloccato = 'Microfono spento';
  static const String pausa = 'Pausa';
  static const String riprendiDalVivo = 'Riprendi dal vivo';
  static const String prossimoDen = 'Prossimo DEN';
  static const String sblocca2 = 'Sblocca';
  static const String inPausaFrase = 'In pausa';
  static const String inDirettaFrase = 'In diretta';

  // ------------------------------------------------------------- aggiungere persone (030 P1–P6)
  static const String aggiungiPersone = 'Aggiungi persone';
  static const String suggeriti = 'Chi hai frequentato di più';
  static String risultati(int n) => n == 1 ? '1 risultato' : '$n risultati';
  static String stessoNome(String nome) => 'Due persone si chiamano $nome: l\'alias le distingue.';
  static String nessunRisultato(String q) => 'Nessuna persona trovata per «$q».';
  static const String senzaBa = 'Se non ha BA, puoi invitarla con un link: entrerà ad ascoltare.';
  static const String invitaConUnLink = 'Invita con un link';
  static const String aggiungi = 'Aggiungi';
  static const String aggiunta = 'In lista';
  static const String erroreRete = 'Non riusciamo a cercare adesso. Controlla la connessione e riprova.';
  static const String dallaRubrica = 'Dalla rubrica';
  static const String linkTitolo = 'Invita con un link';
  static const String linkFrase = 'Mandi un link: chi lo apre entra ad ascoltare, anche senza BA.';

  // La rubrica (030 R1–R3)
  static const String rubricaTitolo = 'Trovare chi conosci';
  static const String rubricaP1 = 'BA può leggere la rubrica per mostrarti chi c\'è già su BA. Si usa solo per questo.';
  static const String rubricaP2 = 'Puoi cambiare idea quando vuoi, dalle impostazioni del telefono.';
  static const String consentiAccesso = 'Consenti l\'accesso';
  static const String rubricaNonCollegata = 'Rubrica non collegata';
  static const String rubricaR2P1 = 'Va bene così. Puoi cercare le persone per nickname, alias, email o numero.';
  static const String rubricaR2P2 = 'Se cambi idea, lo trovi nelle impostazioni del telefono.';
  static const String cercaUnaPersona = 'Cerca una persona';
  static const String suBa = 'Su BA';
  static const String nonAncoraSuBa = 'Non ancora su BA';
  static const String dallaTuaRubrica = 'dalla tua rubrica';

  // «Chi può trovarmi» (030 V1–V2)
  static const String chiPuoTrovarmi = 'Chi può trovarmi';
  static const String visNessuno = 'Nessuno';
  static const String visNessunoFrase = 'Nessuno ti trova. Chi vuole invitarti non può farlo; tu puoi ancora cercare e invitare.';
  static const String visConosco = 'Chi conosco';
  static const String visConoscoFrase = 'Ti trovano le persone che hai aggiunto e quelle che hanno il tuo numero o la tua email.';
  static const String visTutti = 'Tutti';
  static const String visTuttiFrase = 'Ti trova chiunque cerchi il tuo nickname o il tuo alias. Si vedono solo nickname e alias.';

  // Il richiamo (030 C1–C5)
  static const String richiamo = 'Richiamo';
  static const String richiamoSpentoFrase =
      'Un avviso quando una persona che hai scelto entra in un DEN pubblico e ti chiede di passare. Parte spento.';
  static const String richiamoAccesoFrase =
      'Un avviso quando una persona che hai scelto entra in un DEN pubblico e ti chiede di passare.';
  static const String chiPuoiAvvisare = 'Chi puoi avvisare';
  static const String chiPuoiAvvisareSotto = 'Persone che avvisi quando entri in un DEN pubblico';
  static const String chiPuoAvvisarti = 'Chi può avvisarti';
  static const String chiPuoAvvisartiSotto = 'Persone che hanno scelto di avvisarti';
  static const String richiamoRassicura = 'Nessuno sa che sei online o in un DEN se non lo scegli tu.';
  static const String avvisareFrase =
      'Una persona che scegli riceve un avviso quando entri in un DEN pubblico. Chi non scegli non sa nulla di te.';
  static String avvisareTitolo(String nome) => 'Avvisare $nome?';
  static String avvisareConferma(String nome) =>
      '$nome riceve un avviso solo quando entri in un DEN pubblico. Non vede se sei online. Puoi toglierlo quando vuoi.';
  static String avvisaNome(String nome) => 'Avvisa $nome';
  static const String avvisartiFrase = 'Solo chi ha scelto di avvisarti. Tu decidi se ricevere l\'avviso.';
  static const String avvisartiNota = 'Non vedi quando queste persone sono online.';
  static const String nessunaPersona = 'Nessuna persona aggiunta: aggiungile da «Aggiungi persone».';

  // ------------------------------------------------------------- «Hai un invito» (030 I1–I6)
  static String bannerInvito(String den, String chi) => '$den · Invito di $chi.';
  static String invitoTitolo(String chi, String den) => 'Invito di $chi a $den';
  static const String invitoFrase = 'Entri ad ascoltare.';
  static const String entra = 'Entra';
  static const String invitoScadutoTitolo = 'Questo invito è scaduto';
  static String invitoScadutoFrase(String chi) => 'Chiedi a $chi di invitarti di nuovo.';
  static const String invitoAnnullatoTitolo = 'Questo invito non è più valido';
  static const String invitoAnnullatoFrase = 'Chi lo ha mandato lo ha annullato.';
  static const String invitoPassaP1 = 'Vuoi passare di qua? Entri ad ascoltare.';
  static String seiEntratoSuInvito(String chi) => 'Sei dentro, su invito di $chi. Ascolti.';

  // Fuori dall'app (I4, I5): la mail e la pagina d'arrivo
  static const String fuoriApp = 'fuori dall\'app · simulazione';
  static const String mailMarcatore = 'Email · da BA';
  static const String mailFrase = 'BA è un posto dove si parla dal vivo. Per entrare ad ascoltare ti basta questa email.';
  static const String apriLInvito = 'Apri l\'invito';
  static const String paginaMarcatore = 'Pagina web · fuori dall\'app';
  static const String paginaP1 = 'Per entrare crei un account da ascoltatore con la tua email. Non serve altro.';
  static const String paginaP2 = 'Per parlare, ti chiederemo il numero e il consenso quando vorrai salire sul palco.';
  static const String continuaConLaEmail = 'Continua con la email';

  // ------------------------------------------------------------- simulazioni (strumento, non è il prodotto)
  static const String simInvitoBa = 'arriva un invito (ho BA)';
  static const String simInvitoSenzaBa = 'arriva un invito (non ho BA)';
  static const String simInvitoScaduto = 'l\'invito è scaduto';
  static const String simInvitoAnnullato = 'l\'invito è annullato';
  static const String simulazioniTitolo = 'Simulazioni';
  static const String simParla = 'qualcuno parla';
  static const String simLiberaPosto = 'si libera un posto';
  static const String simPostoScade = 'il posto scade';
  static const String simPerdoLinea = 'perdo la linea';
  static const String simTornoInLinea = 'torno in linea';
  static const String simRichiamo = 'una persona che ho scelto entra in un DEN pubblico';
  static const String simRicerca = 'la ricerca non riesce';
  static const String simRichiamoNota = 'il richiamo arriva solo da chi ti ha scelto e solo per DEN pubblici (proposta 030)';
  static const String simChiuso = 'l\'account viene chiuso';
  static const String simSospeso = 'blocco temporaneo';
  static const String simRiapri = 'riapri l\'account';
  static const String simCreazione = 'la creazione non riesce';
  static const String simMicConsentito = 'microfono consentito';
  static const String simMicNegato = 'microfono negato';
  static const String simBloccato = 'schermo bloccato';
  static const String simCapacita = 'capacità di aspettare con altri';

  // ------------------------------------------------------------- strumento (non è il prodotto)
  static const String strumentoTitolo = 'Strumento';
  static const String strumentoNota =
      'Il pannello non fa parte del prodotto: è lo strumento per provare il prototipo. Dati finti, niente persistenza: ricaricare riparte dal login.';
  static const String strumentoCodici = 'codice giusto: 123456 · scaduto: 000000 · altri: sbagliato';
  static const String strumentoTorna = 'Torna all\'inizio';
  static const String strumentoTesto = 'Testo';
  static const String strumentoRiduci = 'Riduci movimento';
  static const String strumentoLarghezza = 'Larghezza';
  static const String codiceGiusto = '123456';
  static const String codiceDiScaduto = '000000';
}
