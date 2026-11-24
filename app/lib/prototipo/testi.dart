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
  static const String t3Titolo = 'Ne sei sicuro?';
  static const String t3Frase = 'Per parlare di nuovo dovrai dare di nuovo il consenso.';

  static const String bloccateNome = 'Persone bloccate';
  static const String bloccateTitolo = 'Persone bloccate';
  static const String bloccateGruppo = 'bloccate da te';
  static const String bloccateNota = 'Restano finché non le sblocchi.';
  static const String sblocca = 'Sblocca';

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
