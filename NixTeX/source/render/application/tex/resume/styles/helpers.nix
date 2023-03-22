{ core, ... }:
  let
    inherit(core) debug list string time type;

    formatDate
    =   date:
        language:
          type.matchPrimitiveOrPanic date
          {
            int                         =   string date;
            string                      =   date;
            set
            =   let
                  from                  =   time.tryParseISO8601 date.from;
                  till                  =   time.tryParseISO8601 date.till;
                in
                  (debug.info "formatDate" { text = "from"; data = from; })
                  (debug.info "formatDate" { text = "till"; data = till; })
                  (
                    if  from != null
                    &&  till != null
                    &&  from.month != null
                    &&  till.month != null
                    then
                      "${time.formatYearShortMonth from language}–${time.formatYearShortMonth till language}"
                    else
                      "${string date.from}–${string date.till}"
                  );
          };
  in
  {
    inherit formatDate;
  }
