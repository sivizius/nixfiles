{ physical, ... }:
let
  inherit(physical) formatValue;
in
{
  boltzmannConstant = {
    section = "Variables";
    text = {
      deu = "\\person{Boltzmann}-Konstante";
    };
    description = {
      deu = ''
        ''${k_B = \Physical{1.380649}{-23}{joule}{}\Unit{kelvin}{-1}}$,
          benannt nach dem österreichischen Physiker \person (1844–1906)
      '';
    };
    data = {
      kind = "Math";
      short = "k_B";
      value = 1.380649e-23;
      unit = [ "joule" { name = "kelvin"; exp = -1; } ];
    };
  };
  elementaryCharge = {
    section = "Variables";
    text = {
      deu = "Elementar\\-ladung";
    };
    description = {
      deu = ''
        ''${e = \Physical{1.602176634}{-19}{coulomb}{}}$
      '';
    };
    data = {
      kind = "Math";
      short = "e";
      value = 1.602176634e-19;
      unit = "coulomb";
    };
  };
  faradayConstant = {
    section = "Variables";
    text = {
      deu = "\\person{Faraday}-Konstante";
    };
    description = {
      deu = ''
        ''${F = \Physical{9.648533289}{4}{ampere}{}\Unit{second}{}\Unit{mol}{-1}}$,
          benannt nach dem englischen Experimental\-physiker \person{Michael Faraday} (1791–1867)
      '';
    };
    data = {
      kind = "Math";
      short = "F";
      value = 9.648533289e4;
      unit = [ "ampere" { name = "mol"; exp = -1; } ];
    };
  };
  gasConstant = {
    section = "Variables";
    text = {
      deu = "Gas\\-konstante";
    };
    description = {
      deu = ''
        ''${R~=~\Physical{8.3144598}{}{joule}{}\Unit{mol}{-1}\Unit{kelvin}{-1}}$
      '';
    };
    data = {
      kind = "Math";
      short = "R";
      value = 8.3144598;
      unit = [ "joule" { name = "mol"; exp = -1; } { name = "kelvin"; exp = -1; } ];
    };
  };
  planckConstant = {
    section = "Variables";
    text = {
      deu = "\\person{Planck}sches Wirkungs\\-quantum";
    };
    description = {
      deu = ''
        ''${h = \Physical{6.62607015}{-34}{joule}{}\Unit{second}{}}$,
          benannt nach dem deutschen Physiker \person{Max Planck} (1858–1947)
      '';
    };
    data = {
      kind = "Math";
      short = "h";
      value = 6.62607015e-34;
      unit = [ "joule" "second" ];
    };
  };
  roomTemperature = {
    section = "Variables";
    text = {
      deu = "Raum\\-temperatur";
    };
    description = {
      deu = ''
        Eine unspezifizierte Temperatur von ${formatValue { from = 20; till = 30; } "celsius"},
          welche bei Reaktionen erreicht wird,
            wenn weder aktiv gekühlt noch aktiv erwärmt wird
      '';
    };
    data = {
      kind = "Default";
      short = "RT";
    };
  };
  speedOfLight = {
    section = "Variables";
    text = {
      deu = "Licht\\-geschwindigkeit";
    };
    description = {
      deu = ''
        ''${c = \Physical{299792458}{}{metre}{}\Unit{second}{-1}}$,
          Geschwindigkeit elektro\-magnetischer Wellen im Vakuum
      '';
    };
    data = {
      kind = "Math";
      short = "c";
      value = 299792458;
      unit = [ "metre" { name = "second"; exp = -1; } ];
    };
  };
}