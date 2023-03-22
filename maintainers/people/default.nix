{ Maintainer, GitHub, Fingerprint, ... }:
{ teams, ... }:
{
  _sivizius
  =   Maintainer "Sebastian Walz"
      {
        contact
        =   {
              e-mail                    =   "sivizius@sivizius.eu";
              matrix                    =   "@sivizius:matrix.org";
            };
        github                          =   GitHub "sivizius" 1690450;
        keys
        =   [
              (Fingerprint "…")
            ];
        teams                           =   with teams; [];
      };
}
