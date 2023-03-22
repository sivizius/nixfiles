{ debug, float, integer, intrinsics, list, string, type, ... }:
  let
    daysPerYear                         =   365;
    secondsPerMinute                    =   60;
    secondsPerHour                      =   60 * secondsPerMinute;
    secondsPerDay                       =   24 * secondsPerHour;
    yearsPerEra                         =   400;
    yearsPerCentury                     =   100;
    yearsPerCycle                       =   4;
    monthsPerYear                       =   12;
    dayOfWeekOfEraBegin                 =   0; #0: Monday, 6: Sunday

    DateTime
    =   type "DateTime"
        {
          inherit secondsPerMinute secondsPerHour secondsPerDay
                  daysPerYear
                  monthsPerYear
                  yearsPerEra yearsPerCentury yearsPerCycle;

          inherit after before from fromSet
                  format formatDate formatDateTime formatYearMonth formatYearShortMonth
                  formatISO8601 formatISO8601'
                  getDayName getDayShortName getMonthName getMonthShortName
                  parseDateTime parseISO8601 parseUnixTime
                  tryParseISO8601;

          current                       =   from (intrinsics.currentTime or 0);
        };

    # DateTime -> DateTime -> bool:
    after
    =   left:
        right:
          let
            left'                       =   DateTime.expect left;
            right'                      =   DateTime.expect right;
            orZero                      =   value: if value != null then value else 0;
            lYear                       =   left'.year;
            rYear                       =   right'.year;
            lMonth                      =   orZero left'.month;
            rMonth                      =   orZero right'.month;
            lDay                        =   orZero left'.day;
            rDay                        =   orZero right'.day;
            lHour                       =   orZero left'.hour;
            rHour                       =   orZero right'.hour;
            lMinute                     =   orZero left'.minute;
            rMinute                     =   orZero right'.minute;
            lSecond                     =   orZero left'.second;
            rSecond                     =   orZero right'.second;
          in
            if lYear == rYear
            then
              if lMonth == rMonth
              then
                if lDay == rDay
                then
                  if lHour == rHour
                  then
                    if lMinute == rMinute
                    then
                      lSecond > rSecond
                    else
                      lMinute > rMinute
                  else
                    lHour > rHour
                else
                  lDay > rDay
              else
                lMonth > rMonth
            else
              lYear > rYear;

    # DateTime -> DateTime -> bool:
    before
    =   left:
        right:
          let
            left'                       =   DateTime.expect left;
            right'                      =   DateTime.expect right;
            orZero                      =   value: if value != null then value else 0;
            lYear                       =   left'.year;
            rYear                       =   right'.year;
            lMonth                      =   orZero left'.month;
            rMonth                      =   orZero right'.month;
            lDay                        =   orZero left'.day;
            rDay                        =   orZero right'.day;
            lHour                       =   orZero left'.hour;
            rHour                       =   orZero right'.hour;
            lMinute                     =   orZero left'.minute;
            rMinute                     =   orZero right'.minute;
            lSecond                     =   orZero left'.second;
            rSecond                     =   orZero right'.second;
          in
            if lYear == rYear
            then
              if lMonth == rMonth
              then
                if lDay == rDay
                then
                  if lHour == rHour
                  then
                    if lMinute == rMinute
                    then
                      lSecond < rSecond
                    else
                      lMinute < rMinute
                  else
                    lHour < rHour
                else
                  lDay < rDay
              else
                lMonth < rMonth
            else
              lYear < rYear;

    format#: D: ToDateTime @ D -> string -> string -> string
    =   dateTime:
        language:
        format:
          let
            date                        =   from dateTime;
            handle
            =   token:
                  if list.isInstanceOf token
                  then
                    let
                      parts
                      =   string.match
                            "%([-_0+^#])*([EO]?[A-Za-y%]|(:{0,3})z)"
                            (list.head token);
                      config
                      =   list.fold
                          (
                            state:
                            token:
                              {
                                "^"     =   state // { upper    = true;               };
                                "#"     =   state // { opposite = true;               };
                                "-"     =   state // { padding  = "";                 };
                                "_"     =   state // { padding  = " ";                };
                                "0"     =   state // { padding  = "0";                };
                                "+"     =   state // { padding  = "0";  plus = true;  };
                              }.${token}
                          )
                          {
                            opposite    =   false;
                            padding     =   null;
                            plus        =   false;
                            upper       =   false;
                          }
                          (list.get parts 0);
                      pad
                      =   value:
                          length:
                          default:
                            let
                              padding   =   if config.padding != null then config.padding else default;
                              text      =   if value != null then string value else string.repeat "?" length;
                              len       =   ( string.length text ) - length;
                              padding'  =   string.repeat padding len;
                            in
                              if      padding != "" &&  len > 0 then  "${padding'}${text}"
                              else if config.plus   &&  len < 0 then  "+${text}"
                              else                                    text;
                      adjustCase
                      =   text:
                          maybeLower:
                            if      maybeLower && config.opposite   then  string.toLowerCase text
                            else if config.upper                    then  string.toUpperCase text
                            else                                          text;
                      control           =   list.get parts 1;
                      suffix            =   list.get parts 2;
                      suffix'           =   string.length suffix;

                      modulo            =   y: x: x - ( x / y ) * y;
                      mod7              =   modulo 7;
                      mod12             =   modulo 12;
                      mod60             =   modulo 60;
                      mod100            =   modulo 100;

                      quarter           =   ( ( date.month - 1 ) / 4 ) + 1;
                      isAM              =   date.hour < 12;
                      dayOfWeekMonday   =   date.dayOfWeek;
                      dayOfWeekSunday   =   if date.dayOfWeek == 6 then 0 else date.dayOfWeek + 1;
                      startOfWeek       =   date.dayOfYear - dayOfWeekMonday;
                      startOfWeek'      =   date.dayOfYear - dayOfWeekSunday;
                      mondayWeek        =   if startOfWeek <= 0 then 0 else (startOfWeek  + 6) / 7;
                      sundayWeek        =   if startOfWeek <= 0 then 0 else (startOfWeek' + 6) / 7;
                      isoWeek           =   ( startOfWeek + 6 ) / 7 + 1;
                      isoYear
                      =   if startOfWeek <= 0
                          then
                            date.year - 1
                          else
                            date.year;

                      hour              =   pad date.hour             2 "0";
                      minute            =   pad date.minute           2 "0";
                      second            =   pad date.second           2 "0";
                      year              =   pad date.year             4 "0";
                      year'             =   pad (mod100 date.year)    2 "0";
                      month             =   pad date.month            2 "0";
                      day               =   pad date.day              2 "0";
                      day'              =   pad date.day              2 " ";

                      dayShortName      =   adjustCase ( getDayShortName    dayOfWeekMonday ) false;
                      monthShortName    =   adjustCase ( getMonthShortName  date.month      ) false;

                      zone              =   if date.zone != null then date.zone else 0;
                      zoneSign          =   if zone < 0 then "-" else "+";
                      zone'             =   if zone < 0 then 0 - zone else zone;
                      zoneSeconds       =   pad ( mod60 zone'                        ) 2 "0";
                      zoneMinutes       =   pad ( mod60 ( zone' / secondsPerMinute ) ) 2 "0";
                      zoneHours         =   pad ( mod60 ( zone' / secondsPerHour   ) ) 2 "0";
                      zoneHours'        =   "${zoneSign}${zoneHours}";

                      zone0             =   "${zoneSign}${pad ( zone' / secondsPerMinute ) 4 "0"}";
                      zone1             =   "${zoneHours'}:${zoneMinutes}";
                      zone2             =   "${zoneHours'}:${zoneMinutes}:${zoneSeconds}";
                      zone3
                      =   if      zoneSeconds != 0  then  zone2
                          else if zoneMinutes != 0  then  zone1
                          else                            zoneHours';
                    in
                      if suffix == null
                      then
                        {
                          "%"           =   "%";
                          "a"           =   dayShortName;
                          "A"           =   adjustCase ( getDayName   dayOfWeekMonday ) false;
                          "b"           =   monthShortName;
                          "B"           =   adjustCase ( getMonthName date.month      ) false;
                          "c"           =   "${dayShortName} ${monthShortName} ${day'} ${hour}:${minute}:${second} ${year}";
                          "C"           =   pad ( date.year / 100 )     2 "0";
                          "d"           =   day;
                          "D"           =   "${month}/${day}/${year'}";
                          "e"           =   day';
                          "F"           =   "${year}-${month}-${day}";
                          "g"           =   pad (mod100 isoYear)        2 "0";
                          "G"           =   pad isoYear                 4 "0";
                          "h"           =   adjustCase ( getMonthShortName date.month )     false;
                          "H"           =   hour;
                          "I"           =   pad ( mod12 date.hour )     2 "0";
                          "j"           =   pad date.dayOfYear          3 "0";
                          "k"           =   pad date.hour               2 " ";
                          "l"           =   pad ( mod12 date.hour )     2 " ";
                          "m"           =   month;
                          "M"           =   minute;
                          "n"           =   "\n";
                          "N"           =   pad date.nanosecond         9 "0";
                          "p"           =   if isAM then "AM" else "PM";
                          "P"           =   if isAM then "am" else "pm";
                          "q"           =   pad quarter                 1 "0";
                          "r"           =   null; # Locale 12-hour clock time, e.g. "%I:%M%S %p"
                          "R"           =   "${hour}:${minute}";
                          "s"           =   pad date.unix               2 "0";
                          "S"           =   second;
                          "t"           =   "\t";
                          "T"           =   "${hour}:${minute}:${second}";
                          "u"           =   pad ( dayOfWeekMonday + 1 ) 2 "0";
                          "U"           =   sundayWeek;
                          "V"           =   pad isoWeek                 2 "";
                          "w"           =   pad dayOfWeekSunday         2 "0";
                          "W"           =   mondayWeek;
                          "x"           =   null; # Locale Date
                          "X"           =   null; # Locale Time
                          "y"           =   year';
                          "Y"           =   year;
                          "z"           =   zone0;
                          ":z"          =   zone1;
                          "::z"         =   zone2;
                          ":::z"        =   zone3;
                          "Z"           =   null; # TZ
                        }.${control} or "%${control}"
                      else
                        ""
                  else
                    token;
          in
            if date != null
            then
              list.fold
              (
                result:
                token:
                  "${result}${handle token}"
              )
              ""
              ( string.split "%[-_0+^#]*([EO]?[A-Za-y%]|:{0,3}z)" format )
            else
              debug.panic "format" "Invalid date: ${date}";

    formatDate#: D -> string -> string
    # where D: ToDateTime
    =   dateTime:
        language:
          let
            date                        =   from dateTime;
          in
            if date != null
            then
              "${string date.day}. ${getMonthName date.month language} ${string date.year}"
            else
              debug.panic "formatDate" "Invalid date: ${date}";

    formatDateTime#: D -> string -> string
    # where D: ToDateTime
    =   dateTime:
        language:
          let
            date                        =   from dateTime;
            pad#: int -> string
            =   value:
                  if value < 10
                  then
                    "0${string value}"
                  else
                    string value;
          in
            if date != null
            then
              "${string date.day}. ${getMonthName date.month language} ${string date.year} ${pad date.hour}:${pad date.minute}:${pad date.second}"
            else
              debug.panic "formatDateTime" "Invalid date: ${date}";

    formatISO8601#: D -> string -> string
    # where D: ToDateTime
    =   dateTime:
          let
            date                        =   from dateTime;
            pad#: int -> string
            =   value:
                  if value == null
                  then
                    "00"
                  else if value < 10
                  then
                    "0${string value}"
                  else
                    string value;
          in
            if date != null
            then
              "${string date.year}-${pad date.month}-${pad date.day}"
            else
              debug.panic "formatISO8601" "Invalid date: ${date}";

    formatISO8601'#: D -> string -> string
    # where D: ToDateTime
    =   dateTime:
          let
            date                        =   from dateTime;
            pad#: int -> string
            =   value:
                  if value == null
                  then
                    "00"
                  else if value < 10
                  then
                    "0${string value}"
                  else
                    string value;
          in
            if date != null
            then
              "${string date.year}-${pad date.month}-${pad date.day}T${pad date.hour}:${pad date.minute}:${pad date.second}"
            else
              debug.panic "formatISO8601'" "Invalid date: ${date}";

    formatYearMonth#: string -> string -> string
    =   dateTime:
        language:
          let
            dateTime'                   =   from dateTime;
          in
            if dateTime' != null
            then
              "${getMonthName dateTime'.month language} ${string dateTime'.year}"
            else
              debug.panic "formatYearMonth" "Invalid date: ${dateTime}";

    formatYearShortMonth#: string -> string -> string
    =   dateTime:
        language:
          let
            dateTime'                   =   from dateTime;
          in
            if dateTime' != null
            then
              "${getMonthShortName dateTime'.month language} ${string dateTime'.year}"
            else
              debug.panic "formatYearShortMonth" "Invalid date: ${dateTime}";

    from#: int | set | string -> DateTime
    =   dateTime:
        (
          type.matchPrimitiveOrPanic dateTime
          {
            int                         =   parseUnixTime dateTime;
            set                         =   fromSet       dateTime;
            string
            =   let
                  dateTime'             =   tryParseISO8601 dateTime;
                in
                  if dateTime' != null
                  then
                    parseISO8601 dateTime
                  else
                    parseDateTime dateTime;
          }
        )
        //  {
              __toString
              =   let
                    string'
                    =   value:
                          if value == null
                          then
                            "00"
                          else if value < 10
                          then
                            "0${string value}"
                          else
                            string value;
                  in
                    { year, month, day, hour, minute, second, ... }:
                      "${string year}-${string' month}-${string' day}T${string' hour}:${string' minute}:${string' second}";
            };

    fromSet#:
    # {
    #   year:       int,
    #   month:      int?,
    #   day:        int?,
    #   dayOfWeek:  int?,
    #   dayOfYear:  int?,
    #   hour:       int?,
    #   minute:     int?,
    #   second:     int?,
    #   nanosecond: int?,
    #   unix:       int?,
    #   zone:       int?,
    #   zoneName:   string?,
    # }
    # -> DateTime:
    =   {
          year, month ? null, day ? null, dayOfWeek ? null, dayOfYear ? null,
          hour ? null, minute ? null, second ? null, nanosecond ? null,
          zone ? null, zoneName ? null,
          unix ? null,
          ...
        } @ data:
          if  integer.isInstanceOf  year
          &&  integer.orNull        month
          &&  integer.orNull        day
          &&  integer.orNull        dayOfWeek
          &&  integer.orNull        dayOfYear
          &&  integer.orNull        hour
          &&  integer.orNull        minute
          &&  integer.orNull        second
          &&  integer.orNull        nanosecond
          &&  integer.orNull        zone
          &&  string.orNull         zoneName
          then
            DateTime.instanciate
              { inherit year month day hour minute second nanosecond zone zoneName; }
          else
            debug.panic "DateTime"
            {
              text                      =   "Value cannot be a DateTime!";
              inherit data;
            };

    getDayName#: int -> string -> string
    =   dayOfWeek:
        language:
          let
            days
            =   {
                  eng                   =   [ "Monday" "Thuesday" "Wednesday" "Thursday"    "Friday"  "Saturday"  "Sunday"  ];
                  deu                   =   [ "Montag" "Dienstag" "Mittwoch"  "Donnerstag"  "Freitag" "Samstag"   "Sonntag" ];
                };
            days'
            =   if language == null
                then
                  days.eng
                else
                  ( days.${language} or days.eng);
          in
            list.get days' ( dayOfWeek - 1 );

    getDayShortName#: int -> string -> string
    =   dayOfWeek:
        language:
          let
            days
            =   {
                  eng                   =   [ "Mon" "Thu" "Wed" "Thu" "Fri" "Sat" "Sun" ];
                  deu                   =   [ "Mo"  "Di"  "Mi"  "Do"  "Fr"  "Sa"  "So"  ];
                };
            days'
            =   if language == null
                then
                  days.eng
                else
                  ( days.${language} or days.eng);
          in
            list.get days' ( dayOfWeek - 1 );

    getMonthName#: int -> string -> string
    =   month:
        language:
          let
            months
            =   {
                  eng
                  =   [
                        "January"   "February"  "March"     "April"
                        "May"       "June"      "July"      "August"
                        "September" "October"   "November"  "December"
                      ];
                  deu
                  =   [
                        "Januar"    "Februar" "März"      "April"
                        "Mai"       "Juni"    "Juli"      "August"
                        "September" "Oktober" "November"  "Dezember"
                      ];
                };
            months'
            =   if language == null
                then
                  months.eng
                else
                  ( months.${language} or months.eng);
          in
            list.get months' ( month - 1 );

    getMonthShortName#: int -> string -> string
    =   month:
        language:
          let
            months
            =   {
                  eng
                  =   [
                        "Jan" "Feb" "Mar" "Apr"
                        "May" "Jun" "Jul" "Aug"
                        "Sep" "Oct" "Nov" "Dec"
                      ];
                  deu
                  =   [
                        "Jan" "Feb" "Mär" "Apr"
                        "Mai" "Jun" "Jul" "Aug"
                        "Sep" "Okt" "Nov" "Dez"
                      ];
                };
            months'
            =   if language == null
                then
                  months.eng
                else
                  ( months.${language} or months.eng);
          in
            list.get months' ( month - 1 );

    parseDateTime#:
    # Y = "([0-9]{4})",
    # m = "([0-9]{2})",
    # d = "([0-9]{2})",
    # H = "([0-9]{2})",
    # M = "([0-9]{2})",
    # S = "([0-9]{2})"
    # @ "${Y}${m}${d}${H}${M}${S}" -> { year, month, day, hour, minute, second }
    =   dateTime:
          let
            dateTime'                   =   string.match "([0-9]{4})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})" dateTime;
            field                       =   list.get dateTime';
          in
            if dateTime' != null
            then
              {
                year                    =   integer (field 0);
                month                   =   integer (field 1);
                day                     =   integer (field 2);
                hour                    =   integer (field 3);
                minute                  =   integer (field 4);
                second                  =   integer (field 5);
              }
            else
              null;

    parseISO8601#: string -> DateTime | !
    =   iso8601:
          let
            dateTime                    =   tryParseISO8601 iso8601;
          in
            if  dateTime != null
            then
              dateTime
            else
              debug.panic "parseISO8601"
              {
                text                    =   "Cannot parse as ISO 8601-Date:";
                data                    =   iso8601;
              };

    parseUnixTime#: int -> int | float | null | string -> DateTime
    =   unix:
        zoneOrName:
          let
            zone
            =   type.matchPrimitiveOrPanic zoneOrName
                {
                  int                   =   zoneOrName * secondsPerHour;
                  float                 =   float.floor ( zoneOrName * secondsPerHour );
                  null                  =   0;
                  string
                  =   secondsPerHour
                  *   {
                        # ToDo: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
                        cest            =   2;
                        cet             =   1;
                        utc             =   0;
                      }.${zoneOrName} or ( debug.panic "parseUnixTime" "Unknown Zone »${zoneOrName}«!" );
                };
            adjustedUnix                =   zone + unix;
            zoneName
            =   if string.isInstanceOf zoneOrName
                then
                  zoneOrName
                else
                  null;

            correctYear#: int -> int
            =   month: if month <= march then 1 else 0;
            shiftMonth#: int -> int
            =   month: month + march + 1 - ( if month < ( monthsPerYear - march ) then 0 else monthsPerYear );

            # For whatever reason, the months are from march (0) to february (11)
            # Therefor the month must be shifted to january (1) to december (12) and the year must be corrected.
            leapYearsPerEra
            =   ( yearsPerEra / yearsPerCycle   )   # + Regular leap years, e.g. 2004, 2008, 2012
            -   ( yearsPerEra / yearsPerCentury )   # - Except those divisible by 100, e.g. 1700, 1800, 1900
            +   ( yearsPerEra / yearsPerEra     );  # + But those divisible by 400, e.g. 1600, 2000, 2400
            leapYearsPerRegularCentury  =   yearsPerCentury / yearsPerCycle - 1;
            daysPerEra                  =   yearsPerEra * daysPerYear + leapYearsPerEra;
            daysBetweenMarchZeroAndEpoch
            =   1970 * daysPerYear                  # Regular Days since 0000-01-01
            +   17                                  # Leap Years in 1900–1970
            +   3 * leapYearsPerRegularCentury      # Leap Years in 1600–1900
            +   4 * leapYearsPerEra                 # Leap Years in 0–1600
            -   31                                  # Days January
            -   28;                                 # Days in February of year 0
            daysPerCycle                =   yearsPerCycle * daysPerYear + 1;
            daysPerCentury              =   yearsPerCentury * daysPerYear + leapYearsPerRegularCentury;
            daysFromMarchTillAugust     =   31 + 30 + 31 + 30 + 31;
            march                       =   2;
            daysSinceEpoch              =   adjustedUnix / secondsPerDay;
            daysSinceMarchZero          =   daysSinceEpoch + daysBetweenMarchZeroAndEpoch;
            positiveEra
            =   if daysSinceMarchZero >= 0
                then
                  daysSinceMarchZero
                else
                  daysSinceMarchZero - daysPerEra + 1;
            era                         =   positiveEra / daysPerEra;
            dayOfEra                    =   daysSinceMarchZero - era * daysPerEra;
            yearOfEra
            =   (
                  dayOfEra
                  - dayOfEra / ( daysPerCycle - 1 )
                  + dayOfEra / daysPerCentury
                  - dayOfEra / ( daysPerEra - 1 )
                ) / daysPerYear;
            numberOfLeapYears           =   yearOfEra / yearsPerCycle - yearOfEra / yearsPerCentury;
            dayOfYear                   =   dayOfEra - ( daysPerYear * yearOfEra + numberOfLeapYears );
            month'                      =   ( 5 * dayOfYear + march ) / daysFromMarchTillAugust;
            day                         =   dayOfYear - ( daysFromMarchTillAugust * month' + march ) / 5 + 1;
            month                       =   shiftMonth month';
            year                        =   yearOfEra + era * yearsPerEra + correctYear month;

            secondsToday                =   adjustedUnix - daysSinceEpoch * secondsPerDay;
            hour                        =   secondsToday / secondsPerHour;
            secondsThisHour             =   secondsToday - hour * secondsPerHour;
            minute                      =   secondsThisHour / secondsPerMinute;
            second                      =   secondsThisHour - minute * secondsPerMinute;
            nanosecond                  =   0;

            modulo7                     =   x: x - ( x / 7 ) * 7;
            dayOfWeek                   =   modulo7 ( dayOfEra + dayOfWeekOfEraBegin );
          in
            DateTime { inherit unix year month day hour minute second nanosecond  dayOfWeek dayOfYear zone zoneName; };

    tryParseISO8601#: string -> DateTime | null
    =   iso8601:
        let
          year                          =   "([+-]?[0-9]{4})";
          zone                          =   "(Z|Z?([+-]?[0-9]{2}))?";
          a                             =   "([0-9]{1,2})";
          #  This neither matches milliseconds, intervals nor durations, but YYYYMM
          regex                         =   "${year}(-?${a}(-?${a}([T_ ]?${a}(:?(${a}(:?${a})?))?)?)?)?${zone}";
          matched                       =   string.match regex iso8601;
          toInteger'#: string | null -> int | null
          =   value:
                if value != null
                then
                  integer value
                else
                  null;
        in
          if  string.isInstanceOf iso8601
          &&  matched != null
          then
            DateTime
            {
              year                      =   toInteger' ( list.get matched  0 );
              month                     =   toInteger' ( list.get matched  2 );
              day                       =   toInteger' ( list.get matched  4 );
              dayOfWeek                 =   null;
              dayOfYear                 =   null;
              hour                      =   toInteger' ( list.get matched  6 );
              minute                    =   toInteger' ( list.get matched  9 );
              second                    =   toInteger' ( list.get matched 11 );
              nanosecond                =   0;
              zone                      =   toInteger' ( list.get matched 13 );
              zoneName                  =   null;
            }
          else
            null;
  in
    DateTime
    //  {
          inherit DateTime;
        }