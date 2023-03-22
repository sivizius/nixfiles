{ ... }:
let
  sources
  =   {
        gestis
        =   ''
              @online{gestis,
                title = {{GESTIS}-Stoffdatenbank},
                url = {http://gestis.itrust.de/nxt/gateway.dll/gestis_de/000000.xml?f=templates$fn=default.htm$vid=gestisdeu:sdbdeu$3.0},
                urldate = {2019-03-24}
              }
            '';
        Bromnaphthalene
        =   ''
              @online{ghs_1Bromnaphthalene,
                title = {1-Brom-naphthalin – Sigma-Aldrich},
                url = {https://www.sigmaaldrich.com/DE/de/substance/1bromonaphthalene2070790119},
                urldate = {2021-10-19},
              }
            '';
        MPTS
        =   ''
              @online{ghs_MPTS,
                title = {Trimethoxy-[3-(2-methoxyethoxy)propyl]silane},
                url = {https://pubchem.ncbi.nlm.nih.gov/compound/171723},
                urldate = {2018-12-09},
              }
            '';
        TFPTMS
        =   ''
              @online{ghs_TFPTMS,
                title = {Trimethoxy(3,3,3-trifluoropropyl)silane – Sigma-Aldrich},
                url = {https://www.sigmaaldrich.com/catalog/product/aldrich/91877},
                urldate = {2018-12-09},
              }
            '';
        liquidNitrogen
        =   ''
              @online{ghs_liquidNitrogen,
                title= {Stickstoff, tiefgekühlt, flüssig – Linde},
                url = {https://produkte.linde-gas.at/sdb_konform/LIN_10021831DE.pdf},
                urldate = {2020-02-10},
              }
            '';
        PFOTES
        =   ''
              @online{ghs_PFOTES,
                title = {1H,1H,2H,2H-Perfluorooctyltriethoxysilane 98\% – Sigma-Aldrich},
                url = {https://www.sigmaaldrich.com/catalog/product/aldrich/667420},
                urldate = {2019-01-16},
              }
            '';
      };
  hazard
  =   {
        class
        =   {
              explosive                 =   1;
            };
        compatibility
        =   {
              X                         =   1;
            };
      };
  ghs
  =   {
        pictogram
        =   {
              Explosive                 =   1;
              Flame                     =   2;
              OFlame                    =   3;
              Bottle                    =   4;
              Acid                      =   5;
              Skull                     =   6;
              Exclam                    =   7;
              Health                    =   8;
              Pollu                     =   9;
            };
        signal
        =   {
              None                      =   0;
              Warning                   =   1;
              Danger                    =   2;
            };
      };
  nfpa
  =   {
        None                            =   0;
        Asphyxiant                      =   1;
        NoWater                         =   2;
        Oxidiser                        =   3;
        Acid                            =   4;
        Alkaline                        =   5;
        BioHazard                       =   6;
        Cryogenic                       =   7;
        EcoHazard                       =   8;
        Etching                         =   9;
        Explosive                       =   10;
        Hot                             =   11;
        Radioactive                     =   12;
        Toxic                           =   13;
      };
in
{
  "1,1,2,2-Tetrachlorethane"
  =   {
        name
        =   {
              deu                       =   "1,1,2,2-Tetra|chlor||ethan";
              eng                       =   "1,1,2,2-Tetra|chlor||ethane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 310 330 341 351 411 ];
                    precautions         =   [ 260 284 320 361 405 501 ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Health ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "79-34-5";
              ec                        =   "201-197-8";
              un                        =   1897;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "1,1,2-Trichlorethene"
  =   {
        name
        =   {
              deu                       =   "1,1,2-Tri|chlor||ethen";
              eng                       =   "1,1,2-Tri|chlor||ethene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 350 341 319 315 336 412 ];
                    precautions         =   [ 201 261 273 280 "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "79-01-6";
              ec                        =   "201-167-4";
              un                        =   1710;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "1,2-Dichlorethane"
  =   {
        name
        =   {
              deu                       =   "1,2-Di|chlor||ethan";
              eng                       =   "1,2-Di|chlor||ethane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 350 302 319 335 315 ];
                    precautions         =   [ 201 210 "302+352" "304+340" "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "107-06-2";
              ec                        =   "203-458-1";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "1,4-Dioxane"
  =   {
        name
        =   {
              deu                       =   "1,4-Di|oxan";
              eng                       =   "1,4-Di|oxane";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "C4H8O2";
              density                   =   1.033;
              melting                   =   11.8;
              boiling                   =   101.1;
              nD20                      =   1.422;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 319 335 351 ];
                    euHazards           =   [ 19 66 ];
                    precautions         =   [ 210 261 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              iso7010
              =   {
                    warnings            =   [ ];
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   3;
                    reaction            =   1;
                    other               =   nfpa.None;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "123-91-1";
              ec                        =   "204-661-8";
              un                        =   1165;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-27";
      };
  "1-Bromonaphthalene"
  =   {
        name
        =   {
              deu                       =   "1-Brom||naphthalin";
              eng                       =   "1-Bromo||naphthalene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 319 ];
                    precautions         =   [ "301+312" 330 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "90-11-9";
              ec                        =   "201-965-2";
            };
        sources                         =   [ sources.Bromnaphthalene ];
        asof                            =   "2020-02-16";
      };
  "1-Butanol"
  =   {
        name
        =   {
              deu                       =   "1-Butanol";
              eng                       =   "1-Butanol";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H3C(CH2)3OH";
              density                   =   0.81;
              melting                   =   -89;
              boiling                   =   118;
              nD20                      =   1.3988;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 302 318 315 335 336 ];
                    precautions         =   [ 210 280 "302+352" "304+340" "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "71-36-3";
              ec                        =   "200-751-6";
              un                        =   1120;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-11";
      };
  "1-Propanol"
  =   {
        name
        =   {
              deu                       =   "1-Propanol";
              eng                       =   "1-Propanol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ "225‐318" 336 ];
                    precautions         =   [ 210 240 280 "305+351+338" 313 "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "71-23-8";
              ec                        =   "200-746-9";
              un                        =   1274;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "2-Butanol"
  =   {
        name
        =   {
              deu                       =   "2-Butanol";
              eng                       =   "2-Butanol";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H3CCH2(CHOH)CH3";
              density                   =   0.81;
              melting                   =   -115;
              boiling                   =   99;
              nD20                      =   1.3978;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 319 335 336 ];
                    precautions         =   [ 210 "304+340" "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "15892-23-6";
              ec                        =   "240-029-8";
              un                        =   1120;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-11";
      };
  "2-Methyl-1-propanol"
  =   {
        name
        =   {
              deu                       =   "2-Methyl-1-propanol";
              eng                       =   "2-Methyl-1-propanol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 335 315 318 336 ];
                    precautions         =   [ 210 280 "302+352" "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "78-83-1";
              ec                        =   "201-148-0";
              un                        =   1120;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "2-Propanol"
  =   {
        name
        =   {
              deu                       =   "2-Propanol";
              eng                       =   "2-Propanol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ "225​" "​319" 336 ];
                    precautions         =   [ 210 233 240 "305+351+338" "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "67-63-0";
              ec                        =   "200-661-7";
              un                        =   1219;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "2-Propyl acetate"
  =   {
        name
        =   {
              deu                       =   "2-Propyl||acetat";
              eng                       =   "2-Propyl acetate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 319 336 ];
                    euHazards           =   [ 66 ];
                    precautions         =   [ 210 "305+351+338" { id = "370+378"; dots = { deu = "Löschpulver oder Trockensand"; }; } "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "108-21-4";
              ec                        =   "203-561-1";
              un                        =   1220;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "3-Methyl-1-butanol"
  =   {
        name
        =   {
              deu                       =   "3-Methyl-1-butanol";
              eng                       =   "3-Methyl-1-butanol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 332 315 319 335 ];
                    euHazards           =   [ 66 ];
                    precautions         =   [ 210 280 "304+340" "302+352" "332+313" "337+313" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "123-51-3";
              ec                        =   "204-633-5";
              un                        =   1105;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "3-Nitrotoluene"
  =   {
        name
        =   {
              deu                       =   "3-Nitro||toluen";
              eng                       =   "3-Nitro||toluene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 311 332 373 411 ];
                    precautions         =   [ 280 273 "308+313" "302+352" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Health ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "99-08-1";
              ec                        =   "202-728-6";
              un                        =   3446;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Acetic acid"
  =   {
        name
        =   {
              deu                       =   "Ethan||säure";
              eng                       =   "Ethanoic acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 290 314 ];
                    precautions         =   [ 210 280 "301+330+331" "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   83;
            };
        identifiers
        =   {
              cas                       =   "64-19-7";
              ec                        =   "200-580-7";
              un                        =   2789;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Acetone"
  =   {
        name
        =   {
              deu                       =   "Aceton";
              eng                       =   "Acetone";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H3CCOCH3";
              density                   =   0.79;
              melting                   =   -95;
              boiling                   =   56;
              nD20                      =   1.3588;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 319 336 ];
                    euHazards           =   [ 66 ];
                    precautions         =   [ 210 240 "305+351+338" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              iso7010
              =   {
                    warnings            =   [ ];
                  };
              nfpa
              =   {
                    fire                =   1;
                    health              =   3;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "67-64-1";
              ec                        =   "200-662-2";
              un                        =   1090;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-22";
      };
  "Acetonitrile"
  =   {
        name
        =   {
              deu                       =   "Aceto||nitril";
              eng                       =   "Aceto||nitrile";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 332 302 312 319 ];
                    precautions         =   [ 210 240 "302+352" "305+351+338" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "75-05-8";
              ec                        =   "200-835-2";
              un                        =   1648;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Ammonia solvated"
  =   {
        name
        =   {
              deu                       =   "Ammoniak, wässrige Lösung";
              eng                       =   "Ammonia, aqueous solution";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 290 314 335 400 ];
                    precautions         =   [ 260 273 280 "301+330+331" "303+361+353" "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   268;
            };
        identifiers
        =   {
              cas                       =   "1336-21-6";
              ec                        =   "215-647-6";
              un                        =   3318;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Anthracene"
  =   {
        name
        =   {
              deu                       =   "Anthracen";
              eng                       =   "Anthracene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 315 410 ];
                    precautions         =   [ 273 280 "302+352" "332+313" 501 ];
                    pictograms          =   [ ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "120-12-7";
              ec                        =   "204-371-1";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Argon"
  =   {
        name
        =   {
              deu                       =   "Argon";
              eng                       =   "Argon";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 280 ];
                    precautions         =   [ 403 ];
                    pictograms          =   [ ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   20;
            };
        identifiers
        =   {
              cas                       =   "7440-37-1";
              ec                        =   "231-147-0";
              un                        =   1006;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Benzaldehyde"
  =   {
        name
        =   {
              deu                       =   "Benzaldehyd";
              eng                       =   "Benzaldehyde";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 ];
                    precautions         =   [ 262 ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   90;
            };
        identifiers
        =   {
              cas                       =   "100-52-7";
              ec                        =   "202-860-4";
              un                        =   1990;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Benzene"
  =   {
        name
        =   {
              deu                       =   "Benzen";
              eng                       =   "Benzene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 304 315 319 340 350 372 412 ];
                    precautions         =   [ 201 210 280 "308+313" { id = "370+378"; dots = { deu = "Löschpulver oder Trockensand"; }; } "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "71-43-2";
              ec                        =   "200-753-7";
              un                        =   1114;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Benzoic acid"
  =   {
        name
        =   {
              deu                       =   "Benzoe||säure";
              eng                       =   "Benzoic acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 315 318 "372:orgDE=inhalativ die Lunge;orgEN=the lungs by inhalation;" ];
                    precautions         =   [ 280 "302+352" "305+351+338" 314 ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "65-85-0";
              ec                        =   "200-618-2";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Bromine"
  =   {
        name
        =   {
              deu                       =   "Brom";
              eng                       =   "Bromine";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 330 314 400 ];
                    precautions         =   [ 210 273 "304+340" "305+351+338" "308+310" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Acid ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   886;
            };
        identifiers
        =   {
              cas                       =   "7726-95-6";
              ec                        =   "231-778-1";
              un                        =   1744;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Butane"
  =   {
        name
        =   {
              deu                       =   "Butan";
              eng                       =   "Butane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 220 350 340 280 ];
                    precautions         =   [ 210 202 "308+313" 377 381 405 403 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.None;
                  };
              kemler                    =   23;
            };
        identifiers
        =   {
              cas                       =   "106-99-0";
              ec                        =   "203-450-8";
              un                        =   1011;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Calcium acetylacetonate"
  =   {
        name
        =   {
              deu                       =   "Calcium||acetyl||acetonat";
              eng                       =   "Calcium acetyl||acetonate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 315 319 335 361 ];
                    precautions         =   [ 261 281 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "19372-44-2";
              ec                        =   "243-001-3";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Carbon monooxide insitu"
  =   {
        name
        =   {
              deu                       =   "Kohlenstoff||mono|oxid";
              eng                       =   "Carbon mono|oxide";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 220 331 "360D" 372 ];
                    precautions         =   [ 202 210 260 "304+340" "308+313" 315 377 381 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Skull ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "630-08-0";
              ec                        =   "211-128-3";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Chlorbenzene"
  =   {
        name
        =   {
              deu                       =   "Chlor||benzen";
              eng                       =   "Chlor||benzene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 332 315 411 ];
                    precautions         =   [ 260 262 273 403 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   30;
            };
        identifiers
        =   {
              cas                       =   "108-90-7";
              ec                        =   "203-628-5";
              un                        =   1134;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Chlorine"
  =   {
        name
        =   {
              deu                       =   "Chlor";
              eng                       =   "Chlorine";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 270 280 330 315 319 335 400 ];
                    euHazards           =   [ 71 ];
                    precautions         =   [ 260 220 280 244 273 "304+340" "305+351+338" "332+313" "370+376" "302+352" 315 405 403 ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.OFlame ghs.pictogram.Bottle ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   265;
            };
        identifiers
        =   {
              cas                       =   "7782-50-5";
              ec                        =   "231-959-5";
              un                        =   1017;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Chlorine (insitu)"
  =   {
        name
        =   {
              deu                       =   "Chlor in situ";
              eng                       =   "Chlorine in situ";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 270 330 315 319 335 400 ];
                    euHazards           =   [ 71 ];
                    precautions         =   [ 260 220 280 273 "304+340" "305+351+338" "332+313" "370+376" "302+352" 315 405 403 ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.OFlame ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "7782-50-5";
              ec                        =   "231-959-5";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Copper(I) cyanide"
  =   {
        name
        =   {
              deu                       =   "Kupfer(I)-cyanid";
              eng                       =   "Copper(I)-cyanide";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "CuCN";
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 300 310 330 410 ];
                    euHazards           =   [ 32 ];
                    precautions         =   [ 260 264 273 280 284 "301+310" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "544-92-3";
              ec                        =   "208-883-6";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Copper(II) sulfate"
  =   {
        name
        =   {
              deu                       =   "Kupfer(II)-sulfat";
              eng                       =   "Copper(II)-sulfate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.None;
                  };
              kemler                    =   66;
            };
        identifiers
        =   {
              cas                       =   "10257-54-2";
              ec                        =   "231-847-6";
              un                        =   2775;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Copper(II) sulfate pentahydrate"
  =   {
        name
        =   {
              deu                       =   "Kupfer(II)-sulfat||penta|hydrat";
              eng                       =   "Copper(II) sulfate penta|hydrate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 315 319 410 ];
                    precautions         =   [ 273 "305+351+338" 362 "301+312" "302+352" 501 ];
                    pictograms          =   [ ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.None;
                  };
              kemler                    =   66;
            };
        identifiers
        =   {
              cas                       =   "7732-18-5";
              ec                        =   "231-847-6";
              un                        =   2775;
            };
        sources                         =   [  ];
        asof                            =   "2020-02-16";
      };
  "Cyclohexane"
  =   {
        name
        =   {
              deu                       =   "Cyclo|hexan";
              eng                       =   "Cyclo|hexane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 304 315 336 410 ];
                    precautions         =   [ 210 240 273 "301+310" 331 "302+352" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "110-82-7";
              ec                        =   "203-806-2";
              un                        =   1145;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Cyclopropane"
  =   {
        name
        =   {
              deu                       =   "Cyclo|propan";
              eng                       =   "Cyclo|propane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 220 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   23;
            };
        identifiers
        =   {
              cas                       =   "75-19-4";
              ec                        =   "200-847-8";
              un                        =   1978;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Decalin"
  =   {
        name
        =   {
              deu                       =   "Decalin";
              eng                       =   "Decalin";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 331 304 314 411 ];
                    precautions         =   [ 261 273 280 "301+310" "305+351+338" 310 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Skull ghs.pictogram.Health ghs.pictogram.Acid ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   30;
            };
        identifiers
        =   {
              cas                       =   "91-17-8";
              ec                        =   "202-046-9";
              un                        =   1147;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Dichlormethane"
  =   {
        name
        =   {
              deu                       =   "Di|chlor||methan";
              eng                       =   "Di|chlor||methane";
            };
        label                           =   "acronyms:dcm";
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "CH2Cl2";
              density                   =   1.33;
              melting                   =   -97;
              boiling                   =   40;
              nD20                      =   1.4242;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 315 319 335 336 351 373 ];
                    precautions         =   [ 261 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              nfpa
              =   {
                    fire                =   1;
                    health              =   2;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "75-09-2";
              ec                        =   "200-838-9";
              un                        =   1593;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-03-05";
      };
  "Diethyl ether"
  =   {
        name
        =   {
              deu                       =   "Di|ethyl||ether";
              eng                       =   "Di|ethyl ether";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "(H3CCH2)2O";
              density                   =   0.7134;
              melting                   =   -116.3;
              boiling                   =   34.6;
              nD20                      =   1.353;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 224 302 336 ];
                    euHazards           =   [ 19 66 ];
                    precautions         =   [ 210 240 "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   4;
                    reaction            =   1;
                    other               =   nfpa.None;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "60-29-7";
              ec                        =   "200-467-2";
              un                        =   1155;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-11";
      };
  "Dimethyl sulfoxid"
  =   {
        name
        =   {
              deu                       =   "Di|methyl||sulfoxid";
              eng                       =   "Di|methyl sulfoxid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "67-68-5";
              ec                        =   "200-664-3";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Dimethylformamide"
  =   {
        name
        =   {
              deu                       =   "N,N-Di|methyl||formamid";
              eng                       =   "N,N-Di|methyl||formamide";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "(H3C)2NCHO";
              density                   =   0.95;
              melting                   =   -61;
              boiling                   =   153;
              nD20                      =   1.4305;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 312 332 319 "360D" ];
                    precautions         =   [ 201 210 "302+352" "304+340" "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   2;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   30;
            };
        identifiers
        =   {
              cas                       =   "68-12-2";
              ec                        =   "200-679-5";
              un                        =   2265;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-17";
      };
  "Diphenyl ether"
  =   {
        name
        =   {
              deu                       =   "Di|phenyl||ether";
              eng                       =   "Di|phenyl ether";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 319 411 ];
                    precautions         =   [ 280 273 264 "305+351+338" "337+313" 501 ];
                    pictograms          =   [ ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "101-84-8";
              ec                        =   "202-981-2";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Dry ice"
  =   {
        name
        =   {
              deu                       =   "Trockeneis (festes Kohlenstoff||di|oxid)";
              eng                       =   "Dry ice (solid carbon||di|oxide)";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 281 ];
                    precautions         =   [ 403 ];
                    signal              =   ghs.signal.Warning;
                  };
              iso7010
              =   {
                    warnings            =   [ 10 ];
                  };
            };
        identifiers
        =   {
              cas                       =   "124-38-9";
              ec                        =   "204-696-9";
              un                        =   1845;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Ethanol"
  =   {
        name
        =   {
              deu                       =   "Ethanol";
              eng                       =   "Ethanol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 319 ];
                    euHazards           =   [ 19 66 ];
                    precautions         =   [ 210 240 "305+351+338" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "64-17-5";
              ec                        =   "200-578-6";
              un                        =   1170;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Ethyl acetate"
  =   {
        name
        =   {
              deu                       =   "Ethyl||acetat";
              eng                       =   "Ethyl acetate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 319 336 ];
                    precautions         =   [ 210 233 240 "305+351+338" "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "141-78-6";
              ec                        =   "205-500-4";
              un                        =   1173;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Ethylene glycol"
  =   {
        name
        =   {
              deu                       =   "Ethylen||glycol";
              eng                       =   "Ethylen glycol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 373 ];
                    precautions         =   [ "301+312" 330 ];
                    pictograms          =   [ ghs.pictogram.Exclam ghs.pictogram.Health ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "107-21-1";
              ec                        =   "203-473-3";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Fluorescein"
  =   {
        name
        =   {
              deu                       =   "Fluorescein";
              eng                       =   "Fluorescein";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 319 ];
                    precautions         =   [ "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "2321-07-5";
              ec                        =   "219-031-8";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Fumaric acid"
  =   {
        name
        =   {
              deu                       =   "(2E)-But-2-en||di|säure (Fumar||säure)";
              eng                       =   "(2E)-But-2-ene||di|oic acid (Fumaric acid)";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 319 ];
                    precautions         =   [ "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "110-17-8";
              ec                        =   "203-743-0";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Helium"
  =   {
        name
        =   {
              deu                       =   "Helium";
              eng                       =   "Helium";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 280 ];
                    precautions         =   [ 403 ];
                    pictograms          =   [ ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   20;
            };
        identifiers
        =   {
              cas                       =   "7440-59-7";
              ec                        =   "231-168-5";
              un                        =   1046;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Heptane"
  =   {
        name
        =   {
              deu                       =   "Heptan";
              eng                       =   "Heptane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 304 315 336 410 ];
                    precautions         =   [ 210 240 273 "301+330+331" "302+352" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "142-82-5";
              ec                        =   "205-563-8";
              un                        =   1206;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Hexane"
  =   {
        name
        =   {
              deu                       =   "Hexan";
              eng                       =   "Hexane";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H3C(CH2)4CH3";
              density                   =   0.66;
              melting                   =   -95;
              boiling                   =   69;
              nD20                      =   1.3727;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 304 "361f" 373 315 335 336 411 ];
                    precautions         =   [ 210 240 273 "301+310" 331 "302+352" "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              nfpa
              =   {
                    fire                =   1;
                    health              =   2;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "110-54-3";
              ec                        =   "203-777-6";
              un                        =   1208;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-12";
      };
  "Hydrazine monohydrate"
  =   {
        name
        =   {
              deu                       =   "Hydrazin||mono|hydrat";
              eng                       =   "Hydrazine mono|hydrate";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H2NNH2.H2O";
              density                   =   1.03;
              melting                   =   -51.7;
              boiling                   =   120.5;
              nD20                      =   1.47;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 301 311 330 314 317 350 410 ];
                    precautions         =   [ 201 260 273 280 "304+340" 310 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Health ghs.pictogram.Acid ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              nfpa
              =   {
                    fire                =   4;
                    health              =   4;
                    reaction            =   3;
                    other               =   nfpa.None;
                  };
              kemler                    =   86;
            };
        identifiers
        =   {
              cas                       =   "7803-57-8";
              ec                        =   "206-114-9";
              un                        =   2030;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-13";
      };
  "Hydrochloric acid"
  =   {
        name
        =   {
              deu                       =   "Salz||säure";
              eng                       =   "Hydro||chloric acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 290 314 335 ];
                    precautions         =   [ 260 280 "303+361+353" "304+340" 310 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   80;
            };
        identifiers
        =   {
              cas                       =   "7647-01-0";
              ec                        =   "231-595-7";
              un                        =   1789;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Hydrofluoric acid"
  =   {
        name
        =   {
              deu                       =   "Fluss||säure";
              eng                       =   "Hydro||fluoric acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 300 310 330 314 ];
                    precautions         =   [ 260 280 "301+330+331" 310 "303+361+353" "304+340" "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   886;
            };
        identifiers
        =   {
              cas                       =   "7664-39-3";
              ec                        =   "231-634-8";
              un                        =   1790;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Hydrogen"
  =   {
        name
        =   {
              deu                       =   "Wasserstoff";
              eng                       =   "Hydrogen";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 220 280 ];
                    precautions         =   [ 210 377 381 403 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   23;
            };
        identifiers
        =   {
              cas                       =   "1333-74-0";
              ec                        =   "215-605-7";
              un                        =   1049;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Iodine"
  =   {
        name
        =   {
              deu                       =   "Iod";
              eng                       =   "Iodine";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "I2";
              density                   =   4.94;
              melting                   =   113.7;
              boiling                   =   184;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 312 332 315 319 335 372 400 ];
                    precautions         =   [ 273 "302+352" "305+351+338" 314 ];
                    pictograms          =   [ ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "7553-56-2";
              ec                        =   "231-442-4";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-11";
      };
  "Iron(II) sulfate"
  =   {
        name
        =   {
              deu                       =   "Eisen(II)-sulfat";
              eng                       =   "Iron(II) sulfate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 319 315 ];
                    precautions         =   [ "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "7720-78-7";
              ec                        =   "231-753-5";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Iron(III) chloride"
  =   {
        name
        =   {
              deu                       =   "Eisen(III)-chlorid";
              eng                       =   "Iron(III) chloride";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 290 302 315 318 317 ];
                    precautions         =   [ 280 "302+352" "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   80;
            };
        identifiers
        =   {
              cas                       =   "7705-08-0";
              ec                        =   "231-729-4";
              un                        =   1773;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "MPTS"
  =   {
        name
        =   {
              deu                       =   "3-(Methoxy(poly|ethylenoxy)||propyl)||tri|methoxy||silan";
              eng                       =   "";
            };
        label                           =   "acronym:mpts";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 315 319 335 ];
                    precautions         =   [ 261 "305+351+338" 280 271 264 "302+352" "304+340" 312 321 "332+313" "337+313" 362 "403+233" 405 501 ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "65994-07-2";
              ec                        =   "";
            };
        sources                         =   [ sources.MPTS ];
        asof                            =   "2020-02-16";
      };
  "Mesitylene"
  =   {
        name
        =   {
              deu                       =   "Mesitylen";
              eng                       =   "Mesitylene";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "C9H12";
              density                   =   0.87;
              melting                   =   -45;
              boiling                   =   165;
              nD20                      =   1.4994;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 304 315 319 335 411 ];
                    precautions         =   [ 210 273 "301+310" 331 "302+352" "304+340" 312 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              iso7010
              =   {
                    warnings            =   [ ];
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   2;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   30;
            };
        identifiers
        =   {
              cas                       =   "108-67-8";
              ec                        =   "203-604-4 2";
              un                        =   2325;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-24";
      };
  "Methanoic acid"
  =   {
        name
        =   {
              deu                       =   "Methan||säure";
              eng                       =   "Methanoic acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 302 314 331 ];
                    euHazards           =   [ 71 ];
                    precautions         =   [ 210 280 "303+361+353" "304+340" 310 "305+351+338" "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Skull ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   83;
            };
        identifiers
        =   {
              cas                       =   "64-18-6";
              ec                        =   "200-579-1";
              un                        =   1779;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Methanol"
  =   {
        name
        =   {
              deu                       =   "Methanol";
              eng                       =   "Methanol";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H3COH";
              density                   =   0.79;
              melting                   =   -98;
              boiling                   =   65;
              nD20                      =   1.3288;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 331 311 301 370 ];
                    precautions         =   [ 210 233 280 "302+352" "304+340" "308+313" "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Skull ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
              nfpa
              =   {
                    fire                =   1;
                    health              =   2;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   336;
            };
        identifiers
        =   {
              cas                       =   "67-56-1";
              ec                        =   "200-659-6";
              un                        =   1230;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-12";
      };
  "Nickel(II)-nitrate-hexahydrate"
  =   {
        name
        =   {
              deu                       =   "Nickel(II)-nitrat||hexa|hydrat";
              eng                       =   "Nickel(II) nitrate hexa|hydrate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ "351i" 341 "360D" 372 272 332 302 315 318 334 317 410 ];
                    pictograms          =   [ ghs.pictogram.OFlame ghs.pictogram.Acid ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   50;
            };
        identifiers
        =   {
              cas                       =   "13478-00-7";
              ec                        =   "238-076-4";
              un                        =   2725;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Nitric acid"
  =   {
        name
        =   {
              deu                       =   "Salpeter||säure";
              eng                       =   "Nitric acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 272 290 314 ];
                    euHazards           =   [ 71 ];
                    precautions         =   [ 280 "301+330+331" "304+340" "305+351+338" 310 ];
                    pictograms          =   [ ghs.pictogram.OFlame ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   885;
            };
        identifiers
        =   {
              cas                       =   "7697-37-2";
              ec                        =   "231-714-2";
              un                        =   2031;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Nitrobenzene"
  =   {
        name
        =   {
              deu                       =   "Nitro||benzen";
              eng                       =   "Nitro||benzene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ "360F" 301 311 331 351 372 412 ];
                    precautions         =   [ 201 273 280 "302+352" "304+340" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "98-95-3";
              ec                        =   "202-716-0";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Nitrogen"
  =   {
        name
        =   {
              deu                       =   "Stickstoff";
              eng                       =   "Nitrogen";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 280 ];
                    precautions         =   [ 403 ];
                    pictograms          =   [ ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   20;
            };
        identifiers
        =   {
              cas                       =   "7727-37-9";
              ec                        =   "231-783-9";
              un                        =   1066;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Nitrogen (liquid)"
  =   {
        name
        =   {
              deu                       =   "Flüssig||stickstoff";
              eng                       =   "Liquid Nitrogen";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 280 281 ];
                    precautions         =   [ 282 336 315 403 ];
                    pictograms          =   [ ghs.pictogram.Bottle ];
                    signal              =   ghs.signal.Warning;
                  };
              iso7010
              =   {
                    warnings            =   [ 10 ];
                  };
              kemler                    =   22;
            };
        identifiers
        =   {
              cas                       =   "7727-37-9";
              ec                        =   "231-783-9";
              un                        =   1977;
            };
        sources                         =   [ sources.liquidNitrogen ];
        asof                            =   "2020-02-16";
      };
  "ODES"
  =   {
        name
        =   {
              deu                       =   "n-Octadecyl||tri|ethoxy||silan";
              eng                       =   "";
            };
        label                           =   "acronym:odes";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 315 319 ];
                    precautions         =   [ "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "7399-00-0";
              ec                        =   "230-995-9";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "PFOTES"
  =   {
        name
        =   {
              deu                       =   "1H,1H,2H,2H-Per|fluor||octyl||tri|ethoxy||silan";
              eng                       =   "Tri|ethoxy(1H,1H,2H,2H-per|fluoro-1-octyl)silane";
            };
        label                           =   "acronym:pfotes";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 315 319 335 413 ];
                    precautions         =   [ 280 "305+351+338" 313 ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "51851-37-7";
              ec                        =   "257-473-3";
            };
        sources                         =   [ sources.PFOTES ];
        asof                            =   "2020-02-16";
      };
  "PMMA"
  =   {
        name
        =   {
              deu                       =   "Poly|methyl||methacrylat";
              eng                       =   "Poly(methyl methacrylate)";
            };
        label                           =   "acronym:pmma";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "9011-14-7";
              ec                        =   "";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "PTFE"
  =   {
        name
        =   {
              deu                       =   "Poly|tetra|fluor||ethylen";
              eng                       =   "Poly(tetra|fluor||ethylene)";
            };
        label                           =   "acronym:ptfe";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "9002-84-0";
              ec                        =   "";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Petroleum ether"
  =   {
        name
        =   {
              deu                       =   "Petrolether";
              eng                       =   "Petroleum ether";
            };
        availability
        =   {
            };
        physical
        =   {
              density                   =   0;
              melting                   =   0;
              boiling                   =   0;
              decompose                 =   0;
              nD20                      =   0;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 304 315 336 "361f" 373 411 ];
                    precautions         =   [ 201 210 "301+310" 331 "370+378" 501 ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              iso7010
              =   {
                    warnings            =   [ ];
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   4;
                    reaction            =   0;
                    other               =   nfpa.None;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "8032-32-4";
              ec                        =   "232-453-7";
              un                        =   3295;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-22";
      };
  "Phenol"
  =   {
        name
        =   {
              deu                       =   "Phenol";
              eng                       =   "Phenol";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 301 311 331 314 341 373 411 ];
                    precautions         =   [ 260 280 "301+330+331" "303+361+353" "304+340" 310 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Acid ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "108-95-2";
              ec                        =   "203-632-7";
              un                        =   1671;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Phenolphthalein"
  =   {
        name
        =   {
              deu                       =   "Phenol||phthalein";
              eng                       =   "3,3-Bis(4-hydroxyphenyl)-2-benzofuran-1(3H)-one (Phenol||phthalein)";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 341 350 "361f" ];
                    precautions         =   [ 201 280 "308+313" ];
                    pictograms          =   [ ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "77-09-8";
              ec                        =   "201-004-7";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Phthalic acid"
  =   {
        name
        =   {
              deu                       =   "Benzen-1,2-di|carbon||säure (o-Phthal||säure)";
              eng                       =   "Benzene-1,2-di|carboxylic acid (o-Phthalic acid)";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 335 315 319 ];
                    precautions         =   [ 280 "301+330+331" "304+340" "305+351+338" "308+310" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "88-99-3";
              ec                        =   "201-873-2";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Pivalic acid"
  =   {
        name
        =   {
              deu                       =   "Pivalin||säure";
              eng                       =   "Pivalic acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 312 315 318 ];
                    precautions         =   [ 280 "302+352" "305+351+338" 313 ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "75-98-9";
              ec                        =   "200-922-5 ";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium bromide"
  =   {
        name
        =   {
              deu                       =   "Kalium||bromid";
              eng                       =   "Potassium bromide";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 319 ];
                    precautions         =   [ "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "7758-02-3";
              ec                        =   "231-830-3";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium chloride"
  =   {
        name
        =   {
              deu                       =   "Kalium||chlorid";
              eng                       =   "Potassium chloride";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "7447-40-7";
              ec                        =   "231-211-8";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium fluoride"
  =   {
        name
        =   {
              deu                       =   "Kalium||fluorid";
              eng                       =   "Potassium fluoride";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ "301+311+331" ];
                    precautions         =   [ 280 "302+352" "304+340" "308+310" ];
                    pictograms          =   [ ghs.pictogram.Skull ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "7789-23-3";
              ec                        =   "232-151-5";
              un                        =   1812;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium hydroxide"
  =   {
        name
        =   {
              deu                       =   "Kalium||hydroxid";
              eng                       =   "Potassium hydroxide";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 290 302 314 ];
                    precautions         =   [ 280 "301+330+331" "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   80;
            };
        identifiers
        =   {
              cas                       =   "1310-58-3";
              ec                        =   "215-181-3";
              un                        =   1813;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium iodide"
  =   {
        name
        =   {
              deu                       =   "Kalium||iodid";
              eng                       =   "Potassium iodid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "7681-11-0";
              ec                        =   "231-659-4";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium nitrate"
  =   {
        name
        =   {
              deu                       =   "Kalium||nitrat";
              eng                       =   "Potassium nitrate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 272 ];
                    precautions         =   [ 210 221 ];
                    pictograms          =   [ ghs.pictogram.OFlame ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   50;
            };
        identifiers
        =   {
              cas                       =   "7757-79-1";
              ec                        =   "231-818-8";
              un                        =   1486;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium persulfate"
  =   {
        name
        =   {
              deu                       =   "Kalium||per|oxodi|sulfat";
              eng                       =   "Potassium per|sulfate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 272 302 315 317 319 334 335 ];
                    precautions         =   [ 220 261 280 "305+351+338" "342+311" ];
                    pictograms          =   [ ghs.pictogram.OFlame ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   50;
            };
        identifiers
        =   {
              cas                       =   "7727-21-1";
              ec                        =   "231-781-8";
              un                        =   1492;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Potassium sulfate"
  =   {
        name
        =   {
              deu                       =   "Kalium||sulfat";
              eng                       =   "Potassium sulfate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "7778-80-5";
              ec                        =   "231-915-5";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Propane-1,2,3-triol"
  =   {
        name
        =   {
              deu                       =   "Propan-1,2,3-tri|ol (Glycerin)";
              eng                       =   "Propane-1,2,3-tri|ol (Glycerol)";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "56-81-5";
              ec                        =   "200-289-5";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Pyridine"
  =   {
        name
        =   {
              deu                       =   "Pyridin";
              eng                       =   "Pyridine";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 332 302 312 319 315 ];
                    precautions         =   [ 210 280 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "110-86-1";
              ec                        =   "203-809-9";
              un                        =   1282;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Rhodamine B"
  =   {
        name
        =   {
              deu                       =   "Rhodamin B";
              eng                       =   "Rhodamine B";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 318 412 ];
                    precautions         =   [ 260 273 280 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "81-88-9";
              ec                        =   "201-383-9";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Salicylic acid"
  =   {
        name
        =   {
              deu                       =   "2-Hydroxy||benzoe||säure (Salicyl||säure)";
              eng                       =   "2-Hydroxy||benzoic acid (Salicylic acid)";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 318 ];
                    precautions         =   [ 270 280 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "69-72-7";
              ec                        =   "200-712-3";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Silver nitrate"
  =   {
        name
        =   {
              deu                       =   "Silber||nitrat";
              eng                       =   "Silver nitrate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 272 290 314 410 ];
                    precautions         =   [ 210 220 260 280 "305+351+338" { id = "370+378"; dots = { deu = "Löschpulver oder Trockensand"; }; } 308 310 ];
                    pictograms          =   [ ghs.pictogram.OFlame ghs.pictogram.Acid ghs.pictogram.Pollu ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   50;
            };
        identifiers
        =   {
              cas                       =   "7761-88-8";
              ec                        =   "231-853-9";
              un                        =   1493;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Sodium dodecyl sulfate"
  =   {
        name
        =   {
              deu                       =   "Natrium||dodecyl||sulfat";
              eng                       =   "Sodium dodecyl sulfate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 228 302 332 315 318 335 412 ];
                    precautions         =   [ 210 261 280 "301+312" "301+330+331" "305+351+338" 310 { id = "370+378"; dots = { deu = "Löschpulver oder Trockensand"; }; } ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Acid ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
            };
        identifiers
        =   {
              cas                       =   "151-21-3";
              ec                        =   "205-788-1";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Sodium hydroxide"
  =   {
        name
        =   {
              deu                       =   "Natrium||hydroxid";
              eng                       =   "Sodium hydroxide";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 290 314 ];
                    precautions         =   [ 280 "301+330+331" "305+351+338" "308+313" ];
                    pictograms          =   [ ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   80;
            };
        identifiers
        =   {
              cas                       =   "1310-73-2";
              ec                        =   "215-185-5";
              un                        =   1823;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Sodium thiosulfate"
  =   {
        name
        =   {
              deu                       =   "Natrium||thio||sulfat";
              eng                       =   "Sodium thio||sulfate";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "7772-98-7";
              ec                        =   "231-867-5";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Sulfuric acid"
  =   {
        name
        =   {
              deu                       =   "Schwefel||säure";
              eng                       =   "Sulfuric acid";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 290 314 ];
                    precautions         =   [ 280 "301+330+331" "305+351+338" 308 310 ];
                    pictograms          =   [ ghs.pictogram.Acid ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   80;
            };
        identifiers
        =   {
              cas                       =   "7664-93-9";
              ec                        =   "231-639-5";
              un                        =   1830;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "TEOS"
  =   {
        name
        =   {
              deu                       =   "Tetra|ethyl||ortho|silicat";
              eng                       =   "Tetra|ethyl ortho|silicate";
            };
        label                           =   "acronym:teos";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 332 319 335 ];
                    precautions         =   [ 210 261 280 "303+361+353" "304+340" 312 "370+378" "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
              kemler                    =   30;
            };
        identifiers
        =   {
              cas                       =   "78-10-4";
              ec                        =   "201-083-8";
              un                        =   1292;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "TFPTMS"
  =   {
        name
        =   {
              deu                       =   "Tri|methoxy(3,3,3-tri|fluor||propyl)||silan";
              eng                       =   "";
            };
        label                           =   "acronym:tfptms";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 226 315 319 335 ];
                    precautions         =   [ 261 "305+351+338" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
            };
        identifiers
        =   {
              cas                       =   "429-60-7";
              ec                        =   "215-647-6";
            };
        sources                         =   [ sources.TFPTMS ];
        asof                            =   "2020-02-16";
      };
  "TPM"
  =   {
        name
        =   {
              deu                       =   "3-(Tri|methoxy||silyl)||propyl||methacrylat";
              eng                       =   "";
            };
        label                           =   "acronym:tpm";
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "2530-85-0";
              ec                        =   "219-785-8";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Tetrahydrofuran"
  =   {
        name
        =   {
              deu                       =   "Tetra|hydro||furan";
              eng                       =   "Tetra|hydro||furan";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "C4H8O";
              density                   =   0.8876;
              melting                   =   -108.4;
              boiling                   =   66;
              nD20                      =   1.4073;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 302 319 335 351 ];
                    euHazards           =   [ 19 ];
                    precautions         =   [ 210 280 "301+312" 330 "305+351+338" { dots = "Löschpulver oder Trockensand"; id = "370+378"; } "403+235" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Exclam ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
              iso7010
              =   {
                    warnings            =   [ 10 ];
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   3;
                    reaction            =   1;
                    other               =   nfpa.None;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "109-99-9";
              ec                        =   "203-726-8";
              un                        =   2056;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-23";
      };
  "Toluene"
  =   {
        name
        =   {
              deu                       =   "Toluen";
              eng                       =   "Toluene";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 225 "361d" 304 373 315 336 ];
                    precautions         =   [ 210 240 "301+310" "301+330+331" "302+352" "308+313" 314 "403+233" ];
                    pictograms          =   [ ghs.pictogram.Flame ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   33;
            };
        identifiers
        =   {
              cas                       =   "108-88-3";
              ec                        =   "203-625-9";
              un                        =   1294;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Trichlormethane"
  =   {
        name
        =   {
              deu                       =   "Tri|chlor||methan";
              eng                       =   "Tri|chlor||methane";
            };
        availability
        =   {
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 331 315 319 351 "361d" 336 372 ];
                    precautions         =   [ 261 280 "305+351+338" 311 ];
                    pictograms          =   [ ghs.pictogram.Skull ghs.pictogram.Health ];
                    signal              =   ghs.signal.Danger;
                  };
              kemler                    =   60;
            };
        identifiers
        =   {
              cas                       =   "67-66-3";
              ec                        =   "200-663-8";
              un                        =   1888;
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
  "Triphenylphosphane"
  =   {
        name
        =   {
              deu                       =   "Tri|phenyl||phosphan";
              eng                       =   "Tri|phenyl||phosphane";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "PPh3";
              density                   =   1.19;
              melting                   =   80;
              boiling                   =   360;
            };
        hazmat
        =   {
              ghs
              =   {
                    hazards             =   [ 302 317 373 ];
                    precautions         =   [ 280 "301+312" "301+330+331" "333+313" ];
                    pictograms          =   [ ghs.pictogram.Health ghs.pictogram.Exclam ];
                    signal              =   ghs.signal.Warning;
                  };
              nfpa
              =   {
                    fire                =   2;
                    health              =   1;
                    reaction            =   2;
                    other               =   nfpa.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "603-35-0";
              ec                        =   "210-036-0";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-07-11";
      };
  "Water"
  =   {
        name
        =   {
              deu                       =   "Wasser";
              eng                       =   "Water";
            };
        availability
        =   {
            };
        physical
        =   {
              formula                   =   "H2O";
              density                   =   1;
              melting                   =   0;
              boiling                   =   100;
              nD20                      =   1.3325;
            };
        hazmat
        =   {
              ghs
              =   {
                    signal              =   ghs.signal.None;
                  };
            };
        identifiers
        =   {
              cas                       =   "7732-18-5";
              ec                        =   "231-791-2";
            };
        sources                         =   [ sources.gestis ];
        asof                            =   "2020-02-16";
      };
}
