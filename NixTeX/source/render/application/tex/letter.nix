{ core, letters, phonenumbers, symbols, toTex, urls, ... }:
{
  body,
  closing,
  configuration,
  copies      ? null,
  customer    ? null,
  date,
  enclosures  ? null,
  invoice     ? null,
  language    ? "eng",
  logo        ? null,
  my          ? {},
  opening,
  place,
  recipient,
  sender,
  signature   ? null,
  subject,
  your        ? {},
  ...
}:
  let
    inherit(core) indentation list string time;
    inherit(sender) name social;
    inherit(social) address;
    inherit(symbols.forkAwesome) email-bulk fax globe gnupg mobile phone;

    country'
    =   if address.country or null != null
        then
          "${address.country}\\,"
        else
          "";

    fluent
    =   {
          deu
          =   {
                cellPhone               =   "Mobil";
                copies                  =   "Verteiler";
                email                   =   "E-Mail";
                enclosures              =   "Anlagen";
                homePage                =   "Homepage";
                pgpKey                  =   "PGP-Schlüssel";
                teleFax                 =   "Fax";
                telePhone               =   "Telefon";
              };
          eng
          =   {
                cellPhone               =   "Cellphone";
                copies                  =   "Copies";
                email                   =   "Email";
                enclosures              =   "Enclosures";
                homePage                =   "Homepage";
                pgpKey                  =   "PGP-Key";
                teleFax                 =   "Telefax";
                telePhone               =   "Telephone";
              };
        };

    signatureHeight                     =   "1.2cm";

    formatEmail
    =   label:
        address:
          list.ifOrEmpty
            (address != null)
            "${label}: & ${urls.formatEmailTeXboxed address "\\texttt{${address}}"} \\\\";

    formatPhoneNumber
    =   label:
        number:
          list.ifOrEmpty
            (number != null)
            "${label}: & ${phonenumbers.formatTeX number} \\\\";

    formatURL
    =   label:
        url:
          list.ifOrEmpty
            (url != null)
            "${label}: & ${urls.formatHttpsTeXboxed url "\\texttt{${url}}"} \\\\";


    cellPhone                           =   social.phone.cell or null;
    email                               =   social.email      or null;
    homePage                            =   social.homepage   or null;
    pgpURL                              =   social.pgpURL     or null;
    teleFax                             =   social.phone.fax  or null;
    telePhone                           =   social.phone.home or null;

    opening'
    =   if recipient.name or null != null
        then
          letters.openingFromName recipient.name language
        else
          opening;

    recipientToList
    =   { institute ? null, municipality ? null, name ? null, street ? null, ... }:
          let
            institute'
            =   institute;

            name'
            =   let
                  honorific
                  =   if name.honorific or null != null
                      then
                        "${name.honorific}~"
                      else
                        "";
                  title
                  =   if name.title or null != null
                      then
                        "${name.title}~"
                      else
                        "";
                  actualName
                  =   if  name.given or null != null
                      &&  name.family or null != null
                      then
                        "${name.given}~${name.family}"
                      else
                        name.given or name.family or name;
                in
                  "${honorific}${title}${actualName}";

            street'
            =   if  street.name or null != null
                &&  street.number or null != null
                then
                  "${street.name}~${string street.number}"
                else
                  street.name or street;

            municipality'
            =   let
                  country
                  =   if municipality.country or null != null
                      then
                        if postalCode != ""
                        then
                          "${municipality.country}\\,"
                        else
                          "${municipality.country}~"
                      else
                        "";
                  postalCode
                  =   if municipality.code or null != null
                      then
                        "${string municipality.code}~"
                      else
                        "";
                in
                  "${country}${postalCode}${municipality.name or municipality}";
          in  []
          ++  (list.ifOrEmpty (institute     != null) institute'   )
          ++  (list.ifOrEmpty (name          != null) name'        )
          ++  (list.ifOrEmpty (street        != null) street'      )
          ++  (list.ifOrEmpty (municipality  != null) municipality');

    recipient'
    =   if list.isInstanceOf recipient
        then
          recipient
        else
          recipientToList recipient;
  in
    [
      #"\\addsectiontocentry{}{Anschreiben}"
      "\\setkomavar{backaddress}{" indentation.more
      "${name.given}\\ ${name.family} \\\\"
      "${address.street.name}~${address.street.number} \\\\"
    ]
    ++  (
          list.ifOrEmpty
            (address.street.extra or null != null)
            "${address.street.extra} \\\\"
        )
    ++  [
          "${country'}${address.postalCode}~${address.municipality}"
          indentation.less "}%"
          "\\setkomavar{backaddressseparator}{\\,·\\,}"
          "\\KOMAoptions{" indentation.more
          "foldmarks = H,"
          "subject = titled,"
          "pagenumber = off,"
          indentation.less "}%"
        ]
    ++  (
          list.ifOrEmpty
            (customer != null)
            "\\setkomavar{customer}[${customer.name or "Kunden\\-nummer"}]{${customer.value or customer}}%"
        )
    ++  [
          "\\setkomavar{date}{${time.formatDate date language}}%"
        ]
    ++  (
          list.ifOrEmpty' (logo != null)
          [
            "\\KOMAoptions{fromlogo=true}"
            "\\setkomavar{fromlogo}{\\includegraphics[width=${logo.width}]{\\source/${logo.file}}}"
          ]
        )
    ++  (
          list.ifOrEmpty
            (invoice != null)
            "\\setkomavar{custominvoiceer}[${invoice.name or "Rechnungs\\-nummer"}]{${invoice.value or invoice}}%"
        )
    ++  [
          "\\setkomavar{location}{{" indentation.more
          "\\scriptsize"
          "\\begin{tabular}{r@{\\,}ll}" indentation.more
          "\\multicolumn{3}{l}{${name.given}\\ ${name.family}} \\\\"
          "\\multicolumn{3}{l}{${address.street.name}~${address.street.number}} \\\\"
        ]
    ++  (
          list.ifOrEmpty
            (address.street.extra or null != null)
            "\\multicolumn{3}{l}{${address.street.extra}} \\\\"
        )
    ++  [ "\\multicolumn{3}{l}{${country'}${address.postalCode}~${address.municipality}} \\\\" ]
    ++  ( formatPhoneNumber "${phone} & ${fluent.${language}.telePhone}"    telePhone )
    ++  ( formatPhoneNumber "${fax} & ${fluent.${language}.teleFax}"        teleFax   )
    ++  ( formatPhoneNumber "${mobile} & ${fluent.${language}.cellPhone}"   cellPhone )
    ++  ( formatEmail       "${email-bulk} & ${fluent.${language}.email}"        email     )
    ++  ( formatURL         "${gnupg} & ${fluent.${language}.pgpKey}"       pgpURL    )
    ++  ( formatURL         "${globe} & ${fluent.${language}.homePage}"  homePage  )
    ++  [
          indentation.less "\\end{tabular}"
          indentation.less "}}%"
        ]
    ++  (
          list.ifOrEmpty
            (my.ref or null != null)
            "\\setkomavar{myref}[${my.ref.name or "Mein Zeichen"}]{${my.ref.value or my.ref}}%"
        )
    ++  [
          "\\setkomavar{place}{${place}}%"
          "\\makeatletter%"
          "\\@setplength{lochpos}{1.0cm}%"
          "\\@setplength{locwidth}{7.5cm}%"
          "\\makeatother%"
          "\\setkomavar{signature}{" indentation.more
        ]
    ++  (
          list.ifOrEmpty' (signature != null)
          [
            "\\vspace{-${signatureHeight}}%"
            "\\includegraphics[height=${signatureHeight}]{\\source/${signature}}\\\\[-.3\\normalbaselineskip]%"
          ]
        )
    ++  [
          "${name.given}~${name.family}"
          indentation.less "}%"
          "\\setkomavar{subject}{${subject}}%"
        ]
    ++  (
          list.ifOrEmpty
            (your.mail or null != null)
            "\\setkomavar{yourref}[${your.mail.name or "Ihr Zeichen"}]{${your.ref.value or your.ref}}%"
        )
    ++  (
          list.ifOrEmpty
            (your.ref or null != null)
            "\\setkomavar{yourmail}[${your.ref.name or "Ihr Schreiben vom"}]{${your.ref.value or your.ref}}%"
        )
    ++  [
          "\\begin{letter}{" indentation.more
        ]
    ++  (list.map (line: "${line}\\\\") recipient')
    ++  [
          indentation.less "}" indentation.more
          "\\opening{${opening'}}"
        ]
    ++  (toTex body)
    ++  [
          "\\closing{${closing}}"
          "\\vfill"
        ]
    ++  (
          list.ifOrEmpty'
          (
            enclosures != null
            && enclosures != []
            && (configuration.application or {}).enclosures or true
          )
          (
            [
              "\\setkomavar*{enclseparator}{${fluent.${language}.enclosures}}%"
              "\\encl{%" indentation.more
            ]
            ++  (
                  list.map
                    ({ title, ... }: "${title},")
                    (list.body enclosures)
                )
            ++  [
                  "${(list.foot enclosures).title}"
                  indentation.less "}%"
                ]
          )
        )
    ++  (
          list.ifOrEmpty'
          (
            copies != null
            && copies != []
            && (configuration.application or {}).copies or true
          )
          [
            "\\setkomavar*{ccseparator}{${fluent.${language}.copies}}%"
            "\\cc{%" indentation.more
            indentation.less "}%"
          ]
        )
    ++  [ indentation.less "\\end{letter}" ]
