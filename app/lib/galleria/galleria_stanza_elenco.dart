// La galleria della stanza e dell'elenco (task 029): l'intestazione, la riga di
// stato e l'alone della stanza (C2), le righe dell'elenco dei DEN, delle
// impostazioni e delle persone bloccate (C4) e la schermata dell'account chiuso
// (027: B1, B1 bis, B2). Strumento di sviluppo: testi fissi in italiano, presi
// dai prototipi 001, 002, 004, 013 e 027, niente l10n (D-030). Solo token per
// colori, misure e durate; 360 e 744 sono i dispositivi di riferimento (D-022,
// D-027), 1,0 e 2,0 i due testi di sistema da provare (C6).
//
// Il design system non sa quale schermata viene dopo e non ha logica: qui, e solo
// qui, i tocchi fanno da macchina a stati di prova («Sblocca» passa a «Sblocco…»,
// «Richiedi revisione» a «Richiesta inviata»). L'account chiuso copre tutta la
// schermata finta: si sceglie con il controllo «Account chiuso».
import 'package:flutter/widgets.dart';

import '../design_system/alone.dart';
import '../design_system/foglio_passi.dart';
import '../design_system/intestazione.dart';
import '../design_system/riga_bloccata.dart';
import '../design_system/riga_den.dart';
import '../design_system/riga_impostazione.dart';
import '../design_system/riga_stato.dart';
import '../design_system/schermata_copertura.dart';
import '../design_system/tokens.dart';
import 'comuni.dart';

const double _telefono = 360;
const double _tablet = 744;
const double _testoNormale = 1.0;
const double _testoGrande = BaScalaTokens.maxTesto;

/// L'altezza della schermata finta: un telefono alto.
const double _altezzaSchermata = 760;

/// L'altezza dei riquadri dell'alone.
const double _altezzaAlone = 160;

enum _Copertura { nessuna, b1, b1bis, b2 }

class GalleriaStanzaElenco extends StatefulWidget {
  const GalleriaStanzaElenco({super.key});

  @override
  State<GalleriaStanzaElenco> createState() => _GalleriaStanzaElencoState();
}

class _GalleriaStanzaElencoState extends State<GalleriaStanzaElenco> {
  double _larghezza = _telefono;
  double _testo = _testoNormale;
  bool _riduciMovimento = false;
  _Copertura _copertura = _Copertura.nessuna;
  bool _richiestaInviata = false;
  BaStatoRigaBloccata _sblocco = BaStatoRigaBloccata.bloccata;
  bool _avvisami = false;

  static const _nomiCopertura = {
    _Copertura.nessuna: 'nessuno',
    _Copertura.b1: 'B1',
    _Copertura.b1bis: 'B1 bis',
    _Copertura.b2: 'B2',
  };

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    const sezione = BaSpazioTokens.xxl;

    return ColoredBox(
      color: BaColorTokens.fondoApp,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(BaSpazioTokens.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stanza ed elenco', style: BaTestoTokens.stanza),
                const SizedBox(height: BaSpazioTokens.s),
                Text(
                  "Tutti i componenti nei loro stati, sulla schermata finta. «Sblocca» e «Richiedi revisione» passano agli stati "
                  "successivi solo qui. «Account chiuso» copre tutta la schermata finta (B1, B1 bis, B2). "
                  "Strumento di sviluppo: non fa parte dell'app.",
                  style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                ),
                const SizedBox(height: sezione),
                _comandi(),
                const SizedBox(height: sezione),
                Container(
                  width: _larghezza,
                  height: _altezzaSchermata,
                  decoration: BoxDecoration(
                    color: BaColorTokens.fondoApp,
                    border: Border.all(color: BaColorTokens.filettoBase),
                  ),
                  child: MediaQuery(
                    data: base.copyWith(
                      size: Size(_larghezza, _altezzaSchermata),
                      textScaler: TextScaler.linear(_testo),
                      disableAnimations: _riduciMovimento,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(child: _componenti()),
                        if (_copertura != _Copertura.nessuna) Positioned.fill(child: _accountChiuso()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _comandi() {
    return Wrap(
      spacing: BaControlloTokens.gapCoppia,
      runSpacing: BaControlloTokens.gapCoppia,
      children: [
        galleriaInterruttore(
          'Larghezza ${_larghezza.toInt()}',
          _larghezza == _tablet,
          () => setState(() => _larghezza = _larghezza == _telefono ? _tablet : _telefono),
        ),
        galleriaInterruttore(
          'Testo ${_testo == _testoNormale ? '1,0' : '2,0'}',
          _testo == _testoGrande,
          () => setState(() => _testo = _testo == _testoNormale ? _testoGrande : _testoNormale),
        ),
        galleriaInterruttore(
          'Riduci movimento',
          _riduciMovimento,
          () => setState(() => _riduciMovimento = !_riduciMovimento),
        ),
        galleriaInterruttore(
          'Account chiuso: ${_nomiCopertura[_copertura]}',
          _copertura != _Copertura.nessuna,
          () => setState(() {
            _copertura = _Copertura.values[(_copertura.index + 1) % _Copertura.values.length];
            // B2 è lo stato dopo il tocco; B1 e B1 bis ripartono da «Richiedi revisione».
            _richiestaInviata = _copertura == _Copertura.b2;
          }),
        ),
      ],
    );
  }

  // --------------------------------------------------------- i componenti

  Widget _componenti() {
    final margine = BaLayoutTokens.margine(_larghezza);
    const gap = BaSpazioTokens.l;
    return SingleChildScrollView(
      padding: EdgeInsets.all(margine),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          galleriaTitolo('Intestazione della stanza (C2)'),
          // L'etichetta dice lo stato in italiano (non il nome nel codice: «suInvito», «inIngresso»).
          for (final (stato, etichetta, marcatore) in const [
            (BaStatoIntestazione.pubblica, 'pubblica', 'entra chiunque'),
            (BaStatoIntestazione.suInvito, 'su invito', 'su invito'),
            (BaStatoIntestazione.viva, 'viva', '5 sul palco'),
            (BaStatoIntestazione.inIngresso, 'in ingresso', 'sto entrando'),
            (BaStatoIntestazione.disconnessa, 'disconnessa', 'linea persa'),
          ]) ...[
            _etichetta(etichetta),
            BaIntestazione(nome: 'Serata sul balcone', marcatore: marcatore, stato: stato),
            const SizedBox(height: gap),
          ],
          galleriaTitolo('Riga di stato (C2)'),
          _etichetta('fatti e preferenze'),
          const BaRigaStato(fatti: '3 sul palco', mie: 'Sei in coda'),
          const SizedBox(height: gap),
          _etichetta('solo i fatti'),
          const BaRigaStato(fatti: '8 sul palco · pieno'),
          const SizedBox(height: gap),
          _etichetta('solo le preferenze'),
          const BaRigaStato(mie: 'Sto salendo…'),
          const SizedBox(height: gap),
          _etichetta('nessuna: non lascia spazio'),
          const BaRigaStato(),
          const SizedBox(height: gap),
          galleriaTitolo('Alone (C2)'),
          _etichetta('acceso'),
          _alone(acceso: true),
          const SizedBox(height: gap),
          _etichetta('spento (linea persa, ingresso)'),
          _alone(acceso: false),
          const SizedBox(height: gap),
          galleriaTitolo('Elenco dei DEN (C4)'),
          const BaRigaDen(
            nome: 'Cucina di notte',
            marcatore: 'Entra chiunque · 5 sul palco · 14 in ascolto',
            frase: 'Marta sta parlando',
            presenze: 5,
            tinte: [0, 1, 2],
            sagome: [0, 1, 2],
          ),
          const BaRigaDen(
            nome: 'Fra due turni',
            marcatore: 'Entra chiunque · 2 sul palco',
            presenze: 2,
            tinte: [2, 3],
            sagome: [2, 3],
          ),
          const BaRigaDen(
            nome: 'Corridoio lungo',
            marcatore: 'Su invito · 2 sul palco',
            presenze: 2,
            tinte: [1, 4],
            sagome: [1, 4],
            stato: BaStatoRigaDen.suInvito,
          ),
          const BaRigaDen(
            nome: 'Radio insonni',
            marcatore: 'Entra chiunque · vuoto',
            frase: 'Vuoto. Puoi restare e ti avviso.',
            stato: BaStatoRigaDen.spenta,
          ),
          const SizedBox(height: gap),
          galleriaTitolo('Impostazioni (C4)'),
          BaRigaImpostazione.valore(titolo: 'Lingua', valore: 'Italiano', onTap: () {}),
          BaRigaImpostazione.valore(titolo: 'Persone bloccate', valore: '3 persone', onTap: () {}),
          BaRigaImpostazione.interruttore(
            titolo: 'Avvisami se si libera',
            descrizione: 'Una notifica quando c\'è un posto.',
            acceso: _avvisami,
            parolaAcceso: 'Acceso',
            parolaSpento: 'Spento',
            onCambia: (v) => setState(() => _avvisami = v),
          ),
          BaRigaImpostazione.azione(
            titolo: 'Torna ascoltatore',
            conseguenza: 'Non potrai più parlare. Se stai parlando, esci dalla stanza.',
            onTap: () {},
          ),
          BaRigaImpostazione.negata(
            titolo: 'Notifiche',
            frase: 'Negate — senza queste non posso avvisarti',
            apri: 'Apri',
            onApri: () {},
            apriSemanticsLabel: 'Apri le impostazioni del telefono',
          ),
          BaRigaImpostazione.negata(
            titolo: 'Microfono',
            frase: 'Negato — senza il microfono non puoi parlare',
            apri: 'Apri',
            onApri: () {},
            apriSemanticsLabel: 'Apri le impostazioni del telefono',
          ),
          const SizedBox(height: gap),
          galleriaTitolo('Persone bloccate (C4)'),
          galleriaInterruttore(
            'Dario V.: ${_sblocco.name}',
            _sblocco != BaStatoRigaBloccata.bloccata,
            () => setState(() => _sblocco = BaStatoRigaBloccata.values[(_sblocco.index + 1) % BaStatoRigaBloccata.values.length]),
          ),
          const SizedBox(height: BaSpazioTokens.s),
          BaRigaBloccata(
            nome: 'Dario V.',
            iniziali: 'DV',
            tinta: 1,
            sagoma: 2,
            data: 'in aprile',
            stato: _sblocco,
            sbloccaTesto: 'Sblocca',
            sbloccoInCorsoTesto: 'Sblocco…',
            onSblocca: () => setState(() => _sblocco = BaStatoRigaBloccata.sbloccoInCorso),
          ),
          const BaRigaBloccata(
            nome: 'Giulio R.',
            iniziali: 'GR',
            tinta: 3,
            sagoma: 4,
            data: 'stasera',
            sbloccaTesto: 'Sblocca',
          ),
        ],
      ),
    );
  }

  Widget _etichetta(String testo) => Padding(
        padding: const EdgeInsets.only(bottom: BaSpazioTokens.xs),
        child: Text(
          testo,
          style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoTerzo),
        ),
      );

  /// Un riquadro con l'alone dietro un finto palco: l'alone riempie il riquadro.
  Widget _alone({required bool acceso}) => SizedBox(
        height: _altezzaAlone,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: BaColorTokens.fondoApp,
            border: Border.all(color: BaColorTokens.filettoBase),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: BaAlone(acceso: acceso)),
              Center(
                child: Text(
                  'il palco',
                  style: BaTestoTokens.minore.copyWith(color: BaColorTokens.testoSecondo),
                ),
              ),
            ],
          ),
        ),
      );

  // ------------------------------------------------------- account chiuso

  Widget _accountChiuso() {
    final bis = _copertura == _Copertura.b1bis;
    final b2 = _copertura == _Copertura.b2;
    return BaSchermataCopertura(
      titolo: bis ? "L'accesso a BA è sospeso" : 'Questo account non può più usare BA',
      paragrafi: b2
          ? const [
              BaParagrafoPasso(
                "Abbiamo ricevuto la richiesta di revisione. Ti scriviamo all'email dell'account.",
                evidenza: true,
              ),
            ]
          : const [
              BaParagrafoPasso('Un contenuto non rispetta le regole di BA.'),
              BaParagrafoPasso('Se pensi che sia un errore, puoi chiedere una revisione.', evidenza: true),
            ],
      riga: bis ? 'Potrai rientrare il 21 novembre alle 21:40.' : null,
      richiedi: 'Richiedi revisione',
      onRichiedi: () => setState(() => _richiestaInviata = true),
      richiestaInviata: _richiestaInviata,
      inviata: 'Richiesta inviata',
    );
  }
}
