{ ansi, context, debug, derivation, expression, library, list, path, set, string, target, type, ... }:
  let
    TestCase
    =   type "TestCase"
        {
          from
          =   { success, value } @ result:
                TestCase.instanciate result;
        };

    TestResult
    =   type "TestResult"
        {
          from
          =   variant:
              { success, value } @ result:
                TestResult.instanciateAs variant result;
        };

    check
    =   value:
        arguments:
          let
            result                      =   expression.tryEval value;
          in
            type.matchPrimitiveOrDefault result.value
            {
              list                      =   checkList             result.value;
              set                       =   checkTests arguments  result.value;
              lambda                    =   checkValue            (result.value arguments);
            }
            (TestResult "Value" result);

    checkList
    =   list.fold
        (
          { success, value, ... } @ state:
          entry:
            let
              result                    =   checkValue entry;
            in
              state
              //  {
                    success             =   success && result.success;
                    value               =   value ++ [ entry ];
                  }
        )
        (
          TestResult "List"
          {
            success                     =   true;
            value                       =   [];
          }
        );

    checkSet
    =   set.fold
        (
          { success, value, ... } @ state:
          name:
          entry:
            let
              result                    =   checkValue entry;
            in
              debug.info "checkSet"
              {
                text = "Entry ${name} failed:";
                data = entry;
                when = !result.success;
              }
              state
              //  {
                    success             =   success && result.success;
                    value               =   value // { ${name} = entry; };
                  }
        )
        (
          TestResult "Set"
          {
            success                     =   true;
            value                       =   {};
          }
        );

    checkTests
    =   arguments:
          set.fold
          (
            { success, value, ... } @ state:
            name:
            entry:
              let
                result                  =   check entry arguments;
              in
                state
                //  {
                      success           =   success && result.success;
                      value             =   value // { ${name} = result; };
                    }
          )
          (
            TestCase
            {
              success                   =   true;
              value                     =   {};
            }
          );

    checkValue
    =   value:
          let
            result                      =   expression.tryEval value;
          in
            type.matchPrimitiveOrDefault result.value
            {
              list                      =   checkList   result.value;
              set
              =   if !(string.DoNotFollow.isInstanceOf result.value)
                  then
                    checkSet result.value
                  else
                    result;
            }
            (TestResult "Value" result);

    format
    =   system:
        fullName:
        { success, value, ... } @ this:
          if !(TestResult.isInstanceOf this)
          then
            string.concatLines
            (
              set.mapToList
              (
                name:
                testCases:
                  let
                    fullName'
                    =   if fullName != null
                        then
                          "${fullName} → ${name}"
                        else
                          name;
                  in
                    format system fullName' testCases
              )
              value
            )
          else
            let
              inherit(ansi) foreground;
              fullName'
              =   if fullName != null
                  then
                    " ${fullName}"
                  else
                    "";
              value'
              =   string.from
                    {
                      legacy            =   false;
                      display           =   true;
                      maxDepth          =   null;
                      nice              =   true;
                      showType          =   true;
                    }
                    value;
              verdict
              =   if success
                  then
                    "${foreground.green}[passed]"
                  else
                    "${foreground.red}[failed]";
              formatLine
              =   line:
                    "echo -e \"${verdict}${fullName'} @ ${system}${line}${ansi.reset}\"";
            in
              if success && true
              then
                formatLine ""
              else
                string.concatMappedLines
                (
                  line:
                    let
                      line'
                      =   let
                            inherit(string.char) escape;
                          in
                            string.replace'
                            {
                              "\""      =   ''\"'';
                              "\\"      =   ''\\'';
                              "$"       =   ''\$'';
                              "`"       =   ''\`'';
                              ${escape} =   "\\e";
                            }
                            line;
                    in
                      formatLine ": ${line'}"
                )
                (string.splitLines value');

    testsToChecks
    =   { fileName, lib, source, tests }:
        buildSystem:
        arguments:
          let
            lib'                        =   library.initialise lib (arguments' // { inherit fileName source; });
            arguments'                  =   arguments // { inherit buildSystem; };
            tests'                      =   check (tests lib') arguments';
            builder
            =   path.toFile "builder.sh"
                ''
                  #!/usr/bin/env sh
                  ${format buildSystem null tests'}
                  ${
                    if tests'.success
                    then
                      ''
                        echo -e "\e[32mall tests were successful!\e[0m"
                        echo "1" > $out
                        exit 0
                      ''
                    else
                      ''
                        echo -e "\e[31msome tests failed!\e[0m"
                        exit 1
                      ''
                  }
                '';
          in
            debug.debug []
            {
              text                      =   "Builder for ${buildSystem}";
              data                      =   builder;
            }
              derivation
              {
                args                    =   [ builder ];
                builder                 =   "/bin/sh";
                name                    =   "libcore-test";
                system                  =   "${buildSystem}";
              };

  in
  {
    load
    =   fileName:
        { ... } @ env:
        { ... } @ lib:
        {
          inherit fileName lib;
          tests                         =   path.import fileName env;
          source                        =   context "tests" fileName;
        };

    __functor
    =   { ... }:
        { ... } @ tests:
        arguments:
          if false
          then
            target.System.mapAll
            (
              buildSystem:
              {
                default                 =   testsToChecks tests buildSystem arguments;
              }
            )
          else
          {
            x86_64-linux.default        =   testsToChecks tests "x86_64-linux" arguments;
          };
  }
