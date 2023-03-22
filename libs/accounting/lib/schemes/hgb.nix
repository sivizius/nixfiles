{ common, core, double, ... }:
  let
    inherit(common) Account Section;
    inherit(core) debug time;

    Level
    =   {
          Kleinst                       =   0;
          Klein                         =   1;
          Mittel                        =   2;
          Gross                         =   3;
        };
  in
    {
      level   ? Level.Kleinst,
      method  ? "Umsatz",
      ...
    }:
    [
      #   Aktiva nach § 266 Abs. 2 HGB
      (
        Section "Aktiva" "Aktiva"
        [
          (
            if level >= Level.Klein
            then
              Section "A" "Anlagevermögen"
              [
                (
                  if level >= Level.Mittel
                  then
                    Section "I" "Immaterielle Vermögensgegenstände"
                    [
                      (Account "1" { title = "Selbst geschaffene gewerbliche Schutzrechte und ähnliche Rechte und Werte";                                                                })
                      (Account "2" { title = "Entgeltlich erworbene Konzessionen, gewerbliche Schutzrechte und ähnliche Rechte und Werte sowie Lizenzen an solchen Rechten und Werten";  })
                      (Account "3" { title = "Geschäfts- oder Firmenwert";                                                                                                               })
                      (Account "4" { title = "Geleistete Anzahlungen";                                                                                                                   })
                    ]
                  else
                    Account "I" { title = "Immaterielle Vermögensgegenstände"; }
                )
                (
                  if level >= Level.Mittel
                  then
                    Section "II" "Sachanlagen"
                    [
                      (Account "1" { title = "Grundstücke, grundstücksgleiche Rechte und Bauten einschließlich der Bauten auf fremden Grundstücken";  })
                      (Account "2" { title = "Technische Anlagen und Maschinen";                                                                      })
                      (Account "3" { title = "Andere Anlagen, Betriebs- und Geschäftsausstattung";                                                    })
                      (Account "4" { title = "Geleistete Anzahlungen und Anlagen im Bau";                                                             })
                    ]
                  else
                    Account "II" { title = "Sachanlagen"; }
                )
                (
                  if level >= Level.Mittel
                  then
                    Section "III" "Finanzanlagen"
                    [
                      (Account "1" { title = "Anteile an verbundenen Unternehmen";                                        })
                      (Account "2" { title = "Ausleihungen an verbundene Unternehmen";                                    })
                      (Account "3" { title = "Beteiligungen";                                                             })
                      (Account "4" { title = "Ausleihungen an Unternehmen, mit denen ein Beteiligungsverhältnis besteht"; })
                      (Account "5" { title = "Wertpapiere des Anlagevermögens";                                           })
                      (Account "6" { title = "Sonstige Ausleihungen";                                                     })
                    ]
                  else
                    Account "III" { title = "Finanzanlagen"; }
                )
              ]
            else
              Account "A" { title = "Anlagevermögen"; }
          )
          (
            if level >= Level.Klein
            then
              Section "B" "Umlaufvermögen"
              [
                (
                  if level >= Level.Mittel
                  then
                    Section "I" "Vorräte"
                    [
                      (Account "1" { title = "Roh-, Hilfs- und Betriebsstoffe";             })
                      (Account "2" { title = "Unfertige Erzeugnisse, unfertige Leistungen"; })
                      (Account "3" { title = "Fertige Erzeugnisse und Waren";               })
                      (Account "4" { title = "Geleistete Anzahlungen";                      })
                    ]
                  else
                    Account "I" { title = "Vorräte"; }
                )
                (
                  if level >= Level.Mittel
                  then
                    Section "II" "Forderungen"
                    [
                      (Account "1" { title = "Forderungen aus Lieferungen und Leistungen";                                  })
                      (Account "2" { title = "Forderungen gegen verbundene Unternehmen";                                    })
                      (Account "3" { title = "Forderungen gegen Unternehmen, mit denen ein Beteiligungsverhältnis besteht"; })
                      (
                        if level >= Level.Gross
                        then
                          Section "4" "Sonstige Vermögensgegenstände"
                          [
                            (Account "1" { title = "Abziehbare Vorsteuer"; })
                          ]
                        else
                          Account "4" { title = "Sonstige Vermögensgegenstände"; }
                      )
                    ]
                  else
                    Account "II" { title = "Forderungen"; }
                )
                (
                  if level >= Level.Mittel
                  then
                    Section "III" "Wertpapiere"
                    [
                      (Account "1" { title = "Anteile an verbundenen Unternehmen";  })
                      (Account "2" { title = "Sonstige Wertpapiere";                })
                    ]
                  else
                    Account "III" { title = "Wertpapiere"; }
                )
                (
                  if level >= Level.Gross
                  then
                    Section "IV" "Sonstiges Umlaufvermögen"
                    [
                      (Account "1" { title = "Kassenbestand";       })
                      (Account "2" { title = "Bundesbankguthaben";  })
                      (Account "3" { title = "Bank";                })
                      (Account "4" { title = "Schecks";             })
                    ]
                  else
                    Account "IV" { title = "Sonstiges Umlaufvermögen"; }
                )
              ]
            else
              Account "B" { title = "Umlaufvermögen"; }
          )
          (Account "C" { title = "Rechnungsabgrenzungsposten";                              })
          (Account "D" { title = "Aktive latente Steuern";                                  })
          (Account "E" { title = "Aktiver Unterschiedsbetrag aus der Vermögensverrechnung"; })
        ]
      )

      #   Passiva nach § 266 Abs. 3 HGB
      (
        Section "Passiva" "Passiva"
        [
          (
            if level >= Level.Klein
            then
              Section "A" "Eigenkapital"
              [
                (Account "I"  { title = "Gezeichnetes Kapital"; })
                (Account "II" { title = "Kapitalrücklage";      })
                (
                  if level >= Level.Mittel
                  then
                    Section "III" "Gewinnrücklagen"
                    [
                      (Account "1" { title = "Gesetzliche Rücklage";                                                                  })
                      (Account "2" { title = "Rücklage für Anteile an einem herrschenden oder mehrheitlich beteiligten Unternehmen";  })
                      (Account "3" { title = "Satzungsmäßige Rücklagen";                                                              })
                      (Account "4" { title = "Andere Gewinnrücklagen";                                                                })
                    ]
                  else
                    Account "III" { title = "Gewinnrücklagen"; }
                )
                (Account "IV" { title = "Gewinn-/Verlustvortrag";       })
                (Account "V"  { title = "Jahresüberschuß/-fehlbetrag";  })
              ]
            else
              Account "A" { title = "Eigenkapital"; }
          )
          (
            if level >= Level.Mittel
            then
              Section "B" "Rückstellungen"
              [
                (Account "1" { title = "Rückstellungen für Pensionen und ähnliche Verpflichtungen"; })
                (Account "2" { title = "Steuerrückstellungen";                                      })
                (Account "3" { title = "Sonstige Rückstellungen";                                   })
              ]
            else
              Account "B" { title = "Rückstellungen"; }
          )
          (
            if level >= Level.Mittel
            then
              Section "C" "Verbindlichkeiten"
              [
                (Account "1" { title = "Anleihen davon konvertibel";                                                              })
                (Account "2" { title = "Verbindlichkeiten gegenüber Kreditinstituten";                                            })
                (Account "3" { title = "Erhaltene Anzahlungen auf Bestellungen";                                                  })
                (Account "4" { title = "Verbindlichkeiten aus Lieferungen und Leistungen";                                        })
                (Account "5" { title = "Verbindlichkeiten aus der Annahme gezogener Wechsel und der Ausstellung eigener Wechsel"; })
                (Account "6" { title = "Verbindlichkeiten gegenüber verbundenen Unternehmen";                                     })
                (Account "7" { title = "Verbindlichkeiten gegenüber Unternehmen, mit denen ein Beteiligungsverhältnis besteht";   })
                (
                  if level >= Level.Gross
                  then
                    Section "8" "Sonstige Verbindlichkeiten, davon aus Steuern, davon im Rahmen der sozialen Sicherheit"
                    [
                      (Account "1" { title = "Umsatzsteuer"; })
                    ]
                  else
                    Account "8" { title = "Sonstige Verbindlichkeiten, davon aus Steuern, davon im Rahmen der sozialen Sicherheit"; }
                )
              ]
            else
              Account "C" { title = "Verbindlichkeiten"; }
          )
          (Account "D" { title = "Rechnungsabgrenzungsposten";  })
          (Account "E" { title = "Passive latente Steuern";     })
        ]
      )

      # Gewinn- und Verlustrechnung nach § 275 Abs. 5 HGB
      (
        Section "GuV" "Gewinn- und Verlustrechnung"
        (
          if level == Level.Kleinst
          then
          [
            (Account "1" { title = "Umsatzerlöse";          })
            (Account "2" { title = "Sonstige Erträge";      })
            (Account "3" { title = "Materialaufwand";       })
            (Account "4" { title = "Personalaufwand";       })
            (Account "5" { title = "Abschreibungen";        })
            (Account "6" { title = "Sonstige Aufwendungen"; })
            (Account "7" { title = "Steuern";               })
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
        )
      )
    ]


/*
      events
      =   {
            balance#: { ... } -> ~Transaction
            =   { ... } @ accounts:
                {
                  dateTime = 0;
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
            formatBalanceTitle
            =   { name, dateTime, ... }:
                  "Bilanz von ${name} am ${time.formatDate dateTime "deu"}";
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
                  "Gewinn- und Verlustrechnung von ${name} zwischen ${time.formatDate from "deu"} und ${time.formatDate till "deu"}";
            formatOutcomeTotal
            =   { ... }:
                  "Jahresüberschuss/-fehlbetrag";
            filterSection
            =   { level, ... }:
                  level <= 0;
            initialTransaction
            =   { dateTime, ... }:
                  { description = "Vorjahresbilanz ${time.formatDate dateTime "deu"}"; };
          };
*/