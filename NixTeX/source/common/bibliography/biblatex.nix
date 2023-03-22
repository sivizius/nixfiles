{ core, document, ... } @ libs:
let
  inherit(core)     debug list number path set string time type;
  inherit(document) escapeEncode;

  formatAuthors
  =   let
        formatParticle
        =   particle:
              if particle != null
              then
                "${particle} "
              else
                "";
        formatSuffix
        =   suffix:
              if suffix != null
              then
                ", ${suffix}"
              else
                "";
      in
        string.concatMappedWith
        (
          {
            dropping-particle ? null,
            family            ? "",
            given             ? "",
            suffix            ? null,
            ...
          }:
            "{${given}} {${formatParticle dropping-particle}${family}${formatSuffix suffix}}"
        )
        " and ";

  formatCommon
  =   { authors, doi, title, url, ... }:
      [
        ( toLine                  "author" ( formatAuthors authors ) )
        ( toLineEscapedAmpersand  "title"  title )
        ( toLine                  "doi"    doi   )
        ( toLine                  "url"    url   )
      ];

  formatDate
  =   { day, month, year, ... }:
        let
          year'                         =   "year = {${string year}}";
          month'                        =   "month = {${string month}}";
          day'                          =   "day = {${string day}}";
        in
          if day != null
          then
            [ year' month' day' ]
          else if month != null
          then
            [ year' month' ]
          else
            [ year' ];

  formatPages
  =   pages:
        if set.isInstanceOf pages
        then
          formatPagesFromTill pages
        else
          "pages = {${string pages}}";

  formatPagesFromTill
  =   { from, till }:
        if from != till
        then
          "pages = {${string from}–${string till}}"
        else
          "pages = {${string from}}";

  getType
  =   variant:
        {
          Book                          =   "book";
          BookChapter                   =   "incollection";
          ConferenceArticle             =   "inproceeding";
          JournalArticle                =   "article";
          Patent                        =   "patent";
          ReviewArticle                 =   "article";
        }.${variant}
        or (debug.panic "getType" "Invalid variant »${variant}«");

  getFormatter
  =   shortJournalNames:
      variant:
        let
          JournalArticle
          =   { issue, pages, ... }:
                let
                  journalName
                  =   if shortJournalNames
                      then
                        issue.journal.short
                      else
                        issue.journal.name;
                in
                  ( formatDate issue.date )
                  ++  [
                        ( toLineEscapedAmpersand  "journal"   journalName                   )
                        ( toLine                  "number"    issue.number                  )
                        ( formatPages                         pages                         )
                        ( toLineEscapedAmpersand  "publisher" issue.journal.publisher.name  )
                        ( toLine                  "volume"    issue.volume                  )
                      ];
        in
          {
            Book
            =   { date, isbn, publisher, series, ... }:
                  ( formatDate date )
                  ++  [
                        ( toLine                  "isbn"      isbn                      )
                        ( toLineEscapedAmpersand  "publisher" publisher.name            )
                        ( toLineEscapedAmpersand  "series"    series                    )
                      ];
            BookChapter
            =   { book, ... }:
                  []
                  ++  [
                        ( toLineEscapedAmpersand  "booktitle" book.title                )
                      ]
                  ++  ( formatDate book.date )
                  ++  [
                        ( toLine                  "isbn"      book.isbn                 )
                        ( toLineEscapedAmpersand  "publisher" book.publisher.name       )
                        ( toLineEscapedAmpersand  "series"    book.series               )
                      ];
            ConferenceArticle
            =   { conference, pages, ... }:
                  ( formatDate conference.date )
                  ++  [
                        ( toLineEscapedAmpersand  "booktitle" conference.title          )
                        ( formatPages                         pages                     )
                        ( toLineEscapedAmpersand  "publisher" conference.publisher.name )
                      ];
            inherit JournalArticle;
            Patent
            =   { date, number, type, ... }:
                  ( formatDate date )
                  ++  [
                        ( toLine                  "number"    number                    )
                        ( toLine                  "type"      type                      )
                      ];
            ReviewArticle               =   JournalArticle;
          }.${variant}
          or (debug.panic "getFormatter" "Invalid variant »${variant}«");

  toBibTeX
  =   { bibliography ? { }, ... }:
      name:
      {
        __type__ ? (debug.panic "toBibTeX" "Entries must be generated using constructors"),
        ...
      } @ entry:
        let
          keys
          =   list.filter
                (key: key != null)
                ((formatCommon entry) ++ (getFormatter (bibliography.shortJournalNames or false) __type__ entry));
        in
          ''
            @${getType __type__}{${name},
              ${string.concatWith ",\n  " keys}
            }
          '';

  toLine
  =   name:
      value:
        if value != null
        then
          "${name} = {${string value}}"
        else
          null;

  toLineEscapedAmpersand
  =   name:
      value:
        if value != null
        then
          let
            value'                      =   string.replace [ "&" ] [ "\\&" ] value;
          in
            "${name} = {${string value'}}"
        else
          null;
in
  { configuration, resources, ... }:
  { ... } @ references:
    let
      references'                       =   set.filterKeys (name: name != "__functor") references;
      bibFile                           =   path.fromSet "references.bib" (toBibTeX configuration) references';
    in
      debug.info "load" "BibTeX-File: ${bibFile}"
      {
        src                             =   bibFile;
        dst                             =   "generated/references.bib";
      }
