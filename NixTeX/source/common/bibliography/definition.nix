{ core, document, ... }:
let
  inherit(core)   debug list number set string time type;

  adjustDate
  =   source:
      date:
        let
          panic                         =   debug.panic ( source ++ [ "adjustDate" ] );
          date'                         =   time.from date;
        in
          if date' != null
          then
            date'
          else
            panic "Invalid date: »${date}«";

  adjustPages
  =   source:
      pages:
        let
          panic                         =   debug.panic ( source ++ [ "adjustPages" ] );
        in
          type.matchPrimitiveOrPanic pages
          {
            "int"
            =   {
                  from                  =   pages;
                  till                  =   pages;
                };
            "set"
            =   {
                  from                  =   pages.from or ( panic "Pages need a from!" );
                  till                  =   pages.till or ( panic "Pages need a till!" );
                };
            "string"
            =   let
                  pages'                =   string.match "([^-]+)--?([^-]+)" pages;
                in
                  if pages' != null
                  then
                    {
                      from              =   list.get pages' 0;
                      till              =   list.get pages' 1;
                    }
                  else
                    let
                      page              =   number.toInteger' pages;
                    in
                      if page != null
                      then
                        {
                          from          =   page;
                          till          =   page;
                        }
                      else
                        let
                          page          =   string.match "!?(.*)" pages;
                        in
                          list.head page;
          };

  adjustWhitespace
  =   text:
        string.concatMapped
        (
          item:
            if string.isInstanceOf item
            then
              item
            else
              " "
        )
        ( string.trim' text );

  toChapterBook
  =   source:
        let
          source'                       =   source ++ [ "toChapterBook" ];
        in
          {
            date      ? ( debug.panic source'  "Need a date!"        ),
            isbn      ? null,
            publisher ? ( debug.panic source'  "Needs a publisher!"  ),
            series    ? null,
            title     ? ( debug.panic source'  "Needs a title!"      )
          }:
          {
            date                        =   adjustDate source' date;
            title                       =   adjustWhitespace title;
            series
            =   if series != null
                then
                  adjustWhitespace series
                else
                  null;
            inherit isbn publisher;
          };

  toConference
  =   source:
        let
          source'                       =   source ++ [ "toConference" ];
        in
          {
            date      ? ( debug.panic source'  "Need a date!"        ),
            publisher ? ( debug.panic source'  "Needs a publisher!"  ),
            title     ? ( debug.panic source'  "Needs a title!"      )
          }:
          {
            date                        =   adjustDate source' date;
            title                       =   adjustWhitespace title;
            inherit publisher;
          };

  toIssue
  =   source:
        let
          source'                       =   source ++ [ "toIssue" ];
        in
          {
            date    ? ( debug.panic source' "Need a date!"     ),
            journal ? ( debug.panic source' "Need a journal!"  ),
            number  ? null,
            volume  ? null
          }:
          {
            date                        =   adjustDate  source'  date;
            journal                     =   toJournal   source'  journal;
            inherit number volume;
          };

  toJournal
  =   source:
        let
          source'                       =   source ++ [ "toJournal" ];
        in
          {
            name      ? ( debug.panic source'  "Need a name!"      ),
            publisher ? ( debug.panic source'  "Need a publisher!" ),
            short     ? ""
          }:
          {
            name                        =   adjustWhitespace name;
            short                       =   adjustWhitespace short;
            publisher                   =   toPublisher source' publisher;
          };

  toPublisher
  =   source:
        let
          source'                       =   source ++ [ "toPublisher" ];
        in
          {
            name  ? ( debug.panic source'  "Needs a name!" ),
            ...
          } @ publisher:
            publisher
            //  {
                  name                  =   adjustWhitespace name;
                };
in
{
  Article
  =   {
        authors ? ( debug.panic "Article" "Need some authors!"  ),
        doi     ? null,
        issue   ? ( debug.panic "Article" "Need an issue!"      ),
        pages   ? ( debug.panic "Article" "Need pages!"         ),
        title   ? ( debug.panic "Article" "Need a title!"       ),
        url     ? null,
        ...
      } @ article:
        article
        //  {
              __type__                  =   "JournalArticle";
              title                     =   adjustWhitespace title;
              inherit authors doi url;

              pages                     =   adjustPages [ "Article" ] pages;
              issue                     =   toIssue     [ "Article" ] issue;
            };

  Book
  =   {
        authors   ? ( debug.panic "Book" "Need some authors!" ),
        date      ? ( debug.panic "Book" "Need a date!"       ),
        doi       ? null,
        isbn      ? null,
        publisher ? ( debug.panic "Book" "Need a publisher!"  ),
        series    ? null,
        title     ? ( debug.panic "Book" "Need a title!"      ),
        url       ? null,
        ...
      } @ book:
        book
        //  {
              __type__                  =   "Book";
              title                     =   adjustWhitespace title;
              inherit authors doi url;

              date                      =   adjustDate [ "Book" ] date;
              inherit isbn publisher series;
            };

  Chapter
  =   {
        authors ? ( debug.panic "Chapter" "Need some authors!"  ),
        book    ? ( debug.panic "Chapter" "Need a book!"        ),
        doi     ? null,
        title   ? ( debug.panic "Chapter" "Need a title!"       ),
        url     ? null,
        ...
      } @ chapter:
        chapter
        //  {
              __type__                  =   "BookChapter";
              title                     =   adjustWhitespace title;
              inherit authors doi url;

              book                      =   toChapterBook [ "Chapter" ] book;
            };

  ConferenceArticle
  =   {
        authors     ? ( debug.panic "ConferenceArticle" "Need some authors!"  ),
        conference  ? ( debug.panic "ConferenceArticle" "Need a conference!"  ),
        doi         ? null,
        title       ? ( debug.panic "ConferenceArticle" "Need a title!"       ),
        pages       ? ( debug.panic "ConferenceArticle" "Need pages!"         ),
        url         ? null,
        ...
      } @ paper:
        paper
        //  {
              __type__                  =   "ConferenceArticle";
              title                     =   adjustWhitespace title;
              inherit authors doi url;

              pages                     =   adjustPages   [ "ConferenceArticle" ] pages;
              conference                =   toConference  [ "ConferenceArticle" ] conference;
            };

  Patent
  =   {
        authors ? ( debug.panic "Patent" "Need some authors!" ),
        date    ? ( debug.panic "Patent" "Need a date!"       ),
        doi     ? null,
        number  ? ( debug.panic "Patent" "Need a Number!"     ),
        stage   ? null,
        title   ? ( debug.panic "Patent" "Need a title!"      ),
        type    ? ( debug.panic "Patent" "Need a type!"       ),
        url     ? null,
        ...
      } @ patent:
        patent
        //  {
              __type__                  =   "Patent";
              title                     =   adjustWhitespace title;
              inherit authors doi url;

              date                      =   adjustDate [ "Patent" ] date;
              inherit number stage type;
            };

  Review
  =   {
        authors ? ( debug.panic "Review"  "Need some authors!"  ),
        doi     ? null,
        issue   ? ( debug.panic "Review"  "Need an issue!"      ),
        pages   ? ( debug.panic "Review"  "Need pages!"         ),
        title   ? ( debug.panic "Review"  "Need a title!"       ),
        url     ? null,
        ...
      } @ review:
        review
        //  {
              __type__                  =   "ReviewArticle";
              title                     =   adjustWhitespace title;
              inherit authors doi url;

              pages                     =   adjustPages [ "Review" ] pages;
              issue                     =   toIssue     [ "Review" ] issue;
            };

  Journal                               =   toJournal   [ "Journal"   ];
  Publisher                             =   toPublisher [ "Publisher" ];
}
