{ glossaries, ... }:
let
#  inherit(glossaries.acronyms) Prefix;
in
{
  centi = {
    section = "Prefixes";
    text = {
      deu = "Hunderstel";
    };
    description = {
      deu = ''
        c-, Faktor: ''${10^{-2}}$, von \acrshort{latin} \Q{centum}: hundert
      '';
    };
    data = {
      kind = "Default";
      short = "c";
    };
    sortedBy = -2;
    bookmarkAs = "centi-";
  };
  kilo = {
    section = "Prefixes";
    text = {
      deu = "Tausend";
    };
    description = {
      deu = ''
        k-, Faktor: ''${10^{+3}}$, von \acrshort{greek} \Q{χίλιοι}: Tausend
      '';
    };
    data = {
      kind = "Default";
      short = "k";
    };
    sortedBy = 3;
    bookmarkAs = "kilo-";
  };
  micro = {
    section = "Prefixes";
    text = {
      deu = "Millionstel";
    };
    description = {
      deu = ''
        µ-, Faktor: ''${10^{-6}}$, von \acrshort{greek} \Q{μικρός}: klein
      '';
    };
    data = {
      kind = "Default";
      short = "µ";
    };
    sortedBy = -6;
    bookmarkAs = "micro-";
  };
  milli = {
    section = "Prefixes";
    text = {
      deu = "Tausendstel";
    };
    description = {
      deu = ''
        m-, Faktor: ''${10^{-3}}$, von \acrshort{latin} \Q{mille}: tausend
      '';
    };
    data = {
      kind = "Default";
      short = "m";
    };
    sortedBy = -3;
    bookmarkAs = "milli-";
  };
  nano = {
    section = "Prefixes";
    text = {
      deu = "Milliardstel";
    };
    description = {
      deu = ''
        n-, Faktor: ''${10^{-9}}$, von \acrshort{greek} \Q{νᾶνος}: Zwerg
      '';
    };
    data = {
      kind = "Default";
      short = "n";
    };
    sortedBy = -9;
    bookmarkAs = "nano-";
  };
}