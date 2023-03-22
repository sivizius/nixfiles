
taxa
=   {
      list                              =   { },
      ranks                             =   { },
    }

local ctrRank                           =   0
local function newRank  ( eng, deu )
  ctrRank                               =   ctrRank + 1
  return  {
            level                       =   ctrRank,
            name
            =   {
                  eng                   =   eng,
                  deu                   =   deu or eng,
                },
          }
end

taxa.ranks
=   {
      Domain                            =   newRank ( "Domain",       "Domäne"        ),
      SubDomain                         =   newRank ( "Subdomain",    "Unterdomäne"   ),
      Realm                             =   newRank ( "Realm",        "Bereich"       ),
      SubRealm                          =   newRank ( "Subrealm",     "Unterbereich"  ),
      HyperKingdom                      =   newRank ( "Hyperkingdom", "Reich"         ),
      Kingdom                           =   newRank ( "Kingdom",      "Reich"         ),
      SubKingdom                        =   newRank ( "Subkingdom",   "Unterreich"    ),
      Phylum                            =   newRank ( "Phylum",       "Stamm"         ),
      SubPhylum                         =   newRank ( "Subphylum",    "Unterstamm"    ),
      InfraPhylum                       =   newRank ( "Infraphylum",  "Infrastamm"    ),
      SuperClass                        =   newRank ( "Superclass",   "Überklasse"    ),
      Class                             =   newRank ( "Class",        "Klasse"        ),
      SubClass                          =   newRank ( "Subclass",     "Unterklasse"   ),
      InfraClass                        =   newRank ( "Infraclass",   "Infraklasse"   ),
      SubterClass                       =   newRank ( "Subterclass",  "Subterklasse"  ),
      ParvClass                         =   newRank ( "Parvclass",    "Parvklasse"    ),
      Order                             =   newRank ( "Order",        "Ordnung"       ),
      SubOrder                          =   newRank ( "Suborder",     "Unterordnung"  ),
      SubSubOrder                       =   newRank ( "???",          "Teilordnung"   ),
      SuperFamily                       =   newRank ( "Superfamily",  "Überfamilie"   ),
      Family                            =   newRank ( "Family",       "Familie"       ),
      SubFamily                         =   newRank ( "Subfamily",    "Unterfamilie"  ),
      Tribe                             =   newRank ( "Tribe",        "Tribus"        ),
      SubTribe                          =   newRank ( "Subtribe",     "Untertribus"   ),
      Genus                             =   newRank ( "Genus",        "Gattung"       ),
      Species                           =   newRank ( "Species",      "Art"           ),
      SubSpecies                        =   newRank ( "Subspecies",   "Unterart"      ),
      Strain                            =   newRank ( "Strain",       "Strain"        ),
    }
