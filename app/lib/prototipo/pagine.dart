// Dalla rotta alla pagina (task 024): l'elenco di tutte le pagine intere del
// prototipo. Una pagina nuova si aggiunge qui e nell'enum `Pagina`.
import 'package:flutter/widgets.dart';

import 'pagina_elenco.dart';
import 'pagina_stanza.dart';
import 'pagine_accesso.dart';
import 'pagine_impostazioni.dart';
import 'pagine_persone.dart';
import 'pagine_richiamo.dart';
import 'stato.dart';

Widget costruisciPagina(Rotta r) => switch (r.pagina) {
      Pagina.email => const PaginaEmail(),
      Pagina.codice => const PaginaCodice(),
      Pagina.onboarding => const PaginaOnboarding(),
      Pagina.termini => const PaginaTermini(),
      Pagina.nickname => const PaginaNickname(),
      Pagina.elenco => const PaginaElenco(),
      Pagina.stanza => PaginaStanza(den: r.den!),
      Pagina.impostazioni => const PaginaImpostazioni(),
      Pagina.bloccate => const PaginaBloccate(),
      Pagina.aggiungiPersone => const PaginaAggiungiPersone(),
      Pagina.rubrica => const PaginaRubrica(),
      Pagina.chiPuoTrovarmi => const PaginaChiPuoTrovarmi(),
      Pagina.chiPuoiAvvisare => const PaginaChiPuoiAvvisare(),
      Pagina.chiPuoAvvisarti => const PaginaChiPuoAvvisarti(),
    };
