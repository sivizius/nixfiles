{ time, panic, ... }:
{ formatOutcome, Section, Transaction, ... }:
let
  inherit (time) formatDate;
  Level
  =   {
        Kleinst                         =   0;
        Klein                           =   1;
        Mittel                          =   2;
        Gross                           =   3;
      };
  method                                =   "Umsatz";
  maxLevel                              =   Level.Kleinst;
in
  "\n${
    formatOutcome { from = "2021-01-01"; till = "2021-12-31"; }
    {
      name                              =   "EDV Solutions UG";
      currency                          =   "€";
      events
      =   {
            balance#: { ... } -> ~Transaction
            =   { ... } @ accounts:
                {
                  inherit time;
                  credit                =   { "Passiva-A.I"   = betrag; };
                  debit                 =   { "Aktiva-B.IV.3" = betrag; };
                  description           =   "Jemand zahlt seinen*ihren Anteil ein";
                };
            formatAccountNames#: { ... } -> ...
            =   { ... }:
                {
                  balance               =   "Bestandskonten";
                  assets                =   "Aktive Konten";
                  liabilities           =   "Passive Konten";
                  outcome               =   "Erfolgskonten";
                  revenues              =   "Ertragskonten";
                  expenses              =   "Aufwandskonten";
                };
            formatBalanceTitle          =   { name, time, ... }:  "Bilanz von ${name} am ${formatDate time "deu"}";
            formatBalanceNames
            =   { ... }:
                {
                  credit                =   "Haben";
                  debit                 =   "Soll";
                  total                 =   "Gesamt";
                  difference            =   "Saldo";
                };
            formatOutcomeTitle
            =   { name, from, till, ... }:
                  "Gewinn- und Verlustrechnung von ${name} zwischen ${formatDate from "deu"} und ${formatDate till "deu"}";
            formatOutcomeTotal          =   { ... }:              "Jahresüberschuss/-fehlbetrag";
            filterSection               =   { level, ... }:       level <= maxLevel;
            initialTransaction          =   { time, ... }:        { description = "Vorjahresbilanz ${formatDate time "deu"}"; };
          };
      assets                            #   Aktiva nach § 266 Abs. 2 HGB
      =   Section { title = "Aktiva"; level = Level.Kleinst; }
          [
            (
              Section { title = "Anlagevermögen"; level = Level.Klein; }
              [
                (
                  Section { title = "Immaterielle Vermögensgegenstände"; level = Level.Mittel; }
                  [
                    { id = "Aktiva-A.I.1"; name = "Selbst geschaffene gewerbliche Schutzrechte und ähnliche Rechte und Werte"; }
                    { id = "Aktiva-A.I.2"; name = "Entgeltlich erworbene Konzessionen, gewerbliche Schutzrechte und ähnliche Rechte und Werte sowie Lizenzen an solchen Rechten und Werten"; }
                    { id = "Aktiva-A.I.3"; name = "Geschäfts- oder Firmenwert"; }
                    { id = "Aktiva-A.I.4"; name = "Geleistete Anzahlungen"; }
                  ]
                )
                (
                  Section { title = "Sachanlagen"; level = Level.Mittel; }
                  [
                    { id = "Aktiva-A.II.1"; name = "Grundstücke, grundstücksgleiche Rechte und Bauten einschließlich der Bauten auf fremden Grundstücken"; }
                    { id = "Aktiva-A.II.2"; name = "Technische Anlagen und Maschinen"; }
                    { id = "Aktiva-A.II.3"; name = "Andere Anlagen, Betriebs- und Geschäftsausstattung"; }
                    { id = "Aktiva-A.II.4"; name = "Geleistete Anzahlungen und Anlagen im Bau"; }
                  ]
                )
                (
                  Section { title = "Finanzanlagen"; level = Level.Mittel; }
                  [
                    { id = "Aktiva-A.III.1"; name = "Anteile an verbundenen Unternehmen"; }
                    { id = "Aktiva-A.III.2"; name = "Ausleihungen an verbundene Unternehmen"; }
                    { id = "Aktiva-A.III.3"; name = "Beteiligungen"; }
                    { id = "Aktiva-A.III.4"; name = "Ausleihungen an Unternehmen, mit denen ein Beteiligungsverhältnis besteht"; }
                    { id = "Aktiva-A.III.5"; name = "Wertpapiere des Anlagevermögens"; }
                    { id = "Aktiva-A.III.6"; name = "Sonstige Ausleihungen"; }
                  ]
                )
              ]
            )
            (
              Section { title = "Umlaufvermögen"; level = Level.Klein; }
              [
                (
                  Section { title = "Vorräte"; level = Level.Mittel; }
                  [
                    { id = "Aktiva-B.I.1"; name = "Roh-, Hilfs- und Betriebsstoffe"; }
                    { id = "Aktiva-B.I.2"; name = "Unfertige Erzeugnisse, unfertige Leistungen"; }
                    { id = "Aktiva-B.I.3"; name = "Fertige Erzeugnisse und Waren"; }
                    { id = "Aktiva-B.I.4"; name = "Geleistete Anzahlungen"; }
                  ]
                )
                (
                  Section { title = "Forderungen"; level = Level.Mittel; }
                  [
                    { id = "Aktiva-B.II.1"; name = "Forderungen aus Lieferungen und Leistungen"; }
                    { id = "Aktiva-B.II.2"; name = "Forderungen gegen verbundene Unternehmen"; }
                    { id = "Aktiva-B.II.3"; name = "Forderungen gegen Unternehmen, mit denen ein Beteiligungsverhältnis besteht"; }
                    (
                      Section { title = "Sonstige Vermögensgegenstände"; level = Level.Gross; }
                      [
                        { id = "Aktiva-B.II.4.1"; name = "Abziehbare Vorsteuer"; }
                      ]
                    )
                  ]
                )
                (
                  Section { title = "Wertpapiere"; level = Level.Mittel; }
                  [
                    { id = "Aktiva-B.III.1"; name = "Anteile an verbundenen Unternehmen"; }
                    { id = "Aktiva-B.III.2"; name = "Sonstige Wertpapiere"; }
                  ]
                )
                (
                  Section { title = "Sonstiges Umlaufvermögen"; level = Level.Gross; }
                  [
                    { id = "Aktiva-B.IV.1"; name = "Kassenbestand"; }
                    { id = "Aktiva-B.IV.2"; name = "Bundesbankguthaben"; }
                    { id = "Aktiva-B.IV.3"; name = "Bank"; }
                    { id = "Aktiva-B.IV.4"; name = "Schecks"; }
                  ]
                )
              ]
            )
            { id = "Aktiva-C"; name = "Rechnungsabgrenzungsposten"; }
            { id = "Aktiva-D"; name = "Aktive latente Steuern"; }
            { id = "Aktiva-E"; name = "Aktiver Unterschiedsbetrag aus der Vermögensverrechnung"; }
          ];
      liabilities                       #   Passiva nach § 266 Abs. 3 HGB
      =   Section { title = "Passiva"; level = Level.Kleinst; }
          [
            (
              Section { title = "Eigenkapital"; level = Level.Klein; }
              [
                { id = "Passiva-A.I"; name = "Gezeichnetes Kapital"; }
                { id = "Passiva-A.II"; name = "Kapitalrücklage"; }
                (
                  Section { title = "Gewinnrücklagen"; level = Level.Mittel; }
                  [
                    { id = "Passiva-A.III.1"; name = "Gesetzliche Rücklage"; }
                    { id = "Passiva-A.III.2"; name = "Rücklage für Anteile an einem herrschenden oder mehrheitlich beteiligten Unternehmen"; }
                    { id = "Passiva-A.III.3"; name = "Satzungsmäßige Rücklagen"; }
                    { id = "Passiva-A.III.4"; name = "Andere Gewinnrücklagen"; }
                  ]
                )
                { id = "Passiva-A.IV"; name = "Gewinn-/Verlustvortrag"; }
                { id = "Passiva-A.V"; name = "Jahresüberschuß/-fehlbetrag"; }
              ]
            )
            (
              Section { title = "Rückstellungen"; level = Level.Mittel; }
              [
                { id = "Passiva-B.1"; name = "Rückstellungen für Pensionen und ähnliche Verpflichtungen"; }
                { id = "Passiva-B.2"; name = "Steuerrückstellungen"; }
                { id = "Passiva-B.3"; name = "Sonstige Rückstellungen"; }
              ]
            )
            (
              Section { title = "Verbindlichkeiten"; level = Level.Mittel; }
              [
                { id = "Passiva-C.1"; name = "Anleihen davon konvertibel"; }
                { id = "Passiva-C.2"; name = "Verbindlichkeiten gegenüber Kreditinstituten"; }
                { id = "Passiva-C.3"; name = "Erhaltene Anzahlungen auf Bestellungen"; }
                { id = "Passiva-C.4"; name = "Verbindlichkeiten aus Lieferungen und Leistungen"; }
                { id = "Passiva-C.5"; name = "Verbindlichkeiten aus der Annahme gezogener Wechsel und der Ausstellung eigener Wechsel"; }
                { id = "Passiva-C.6"; name = "Verbindlichkeiten gegenüber verbundenen Unternehmen"; }
                { id = "Passiva-C.7"; name = "Verbindlichkeiten gegenüber Unternehmen, mit denen ein Beteiligungsverhältnis besteht"; }
                (
                  Section { title = "Sonstige Verbindlichkeiten, davon aus Steuern, davon im Rahmen der sozialen Sicherheit"; level = Level.Gross; }
                  [
                    { id = "Passiva-C.8.1"; name = "Umsatzsteuer"; }
                  ]
                )
              ]
            )
            { id = "Passiva-D"; name = "Rechnungsabgrenzungsposten"; }
            { id = "Passiva-E"; name = "Passive latente Steuern"; }
            ];
      outcome                           # Gewinn- und Verlustrechnung nach § 275 Abs. 5 HGB
      =   Section { title = "Jahresüberschuss/-fehlbetrag"; level = Level.Kleinst; }
          (
            if maxLevel == Level.Kleinst
            then
              [
                { id = "GuV-1"; name = "Umsatzerlöse"; }
                { id = "GuV-2"; name = "Sonstige Erträge"; }
                { id = "GuV-3"; name = "Materialaufwand"; }
                { id = "GuV-4"; name = "Personalaufwand"; }
                { id = "GuV-5"; name = "Abschreibungen"; }
                { id = "GuV-6"; name = "Sonstige Aufwendungen"; }
                { id = "GuV-7"; name = "Steuern"; }
              ]
            else if method == "Umsatz"
            then
              [
              ]
            else if method == "Gesamt"
            then
              [
              ]
            else
              debug.panic "GuV"
                ''
                  GuV kann entweder für eine Kleinstkapitalgesellschaften (§ 267a HGB) nach § 275 Abs. 5,
                  nach § 275 Abs. 2 im Gesamtkostenverfahren (method=Gesamt) oder
                  nach § 275 Abs. 2 Umsatzkostenverfahren (method=Umsatz) erstellt werden!
                ''
          );
      inventory                         # Materialien, Maschinen, Grundstücken, …
      =   Section "Inventar"
          [
            { id = "Inventar-1"; name = "Materialien"; }
          ];
      journal                           # Chronologische Liste aller Geschäftsvorfälle
      =   import ./journal.nix
          {
            Gesellschaftereinzahlung
            =   time:
                betrag:
                name:
                {
                  inherit time;
                  credit                =   { "Passiva-A.I"   = betrag; };
                  debit                 =   { "Aktiva-B.IV.3" = betrag; };
                  description           =   "${name} zahlt seinen*ihren Anteil ein";
                };
            Kontofuehrungsgebuehr
            =   time:
                betrag:
                {
                  inherit time;
                  credit                =   { "Aktiva-B.IV.3" = betrag; };
                  debit                 =   { "GuV-6"         = betrag; };
                  description           =   "Kontoführungsgebühren";
                };
            Forderung
            =   time:
                betrag:
                kunde:
                rechnungsnummer:
                  let
                    betrag'             =   betrag / 1.19;
                    steuer              =   betrag - betrag';
                  in
                  {
                    inherit time;
                    credit              =   { "GuV-1"         = betrag';  "Passiva-C.8.1" = steuer; };
                    debit               =   { "Aktiva-B.II.1" = betrag;                             };
                    description         =   "Rechnung an ${kunde} (${rechnungsnummer})";
                  };
            Rechnungsbegleichung
            =   time:
                betrag:
                rechnungsnummer:
                {
                  inherit time;
                  credit                =   { "Aktiva-B.II.1" = betrag; };
                  debit                 =   { "Aktiva-B.IV.3" = betrag; };
                  description           =   "Rechnung ${rechnungsnummer} beglichen";
                };
            Sachanlagen
            =   time:
                betrag:
                sache:
                  let
                    betrag'             =   betrag / 1.19;
                    steuer              =   betrag - betrag';
                  in
                  {
                    inherit time;
                    credit              =   { "Aktiva-B.IV.3" = betrag; };
                    debit               =   { "Aktiva-A.II.2" = betrag'; "Aktiva-B.II.4.1" = steuer; };
                    description         =   "Ankauf von ${sache}";
                  };
            Gewinnruecklage
            =   time:
                betrag:
                  {
                    inherit time;
                    credit              =   { "Passiva-A.III.4" = betrag; };
                    debit               =   { "Passiva-A.IV"    = betrag; };
                    description         =   "Gewinnrücklage";
                  };
          };
    }
  }"