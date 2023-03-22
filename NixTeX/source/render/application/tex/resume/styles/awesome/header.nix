{ core, symbols, styles, toTex, ... } @ libs:
{ ... } @ config:
  let
    inherit(core) indentation list path string;
    inherit(symbols.forkAwesome) home;

    toTex'                              =   body: string.concatWords (toTex body);

    formatAddress
    =   { country, municipality, postalCode, street, ... }:
          "${street.name}~${street.number}, ${country}${postalCode}~${municipality}";

    formatHeaderAbout
    =   about:
          styles.headerPosition "${toTex' about}\\\\[.4em]";

    formatHeaderName
    =   { family, given, ... }:
        [
          (styles.headerFirstName given)
          (styles.headerLastName family)
        ];

    formatPicture
    =   position:
        {
          align ? "left",
          edge  ? true,
          fileName,
          shape ? "circle",
        }:
          if position == align
          then
          [
            "\\begin{minipage}[c]{.25\\linewidth}" indentation.more
              { "left" = "\\raggedright{%"; "right" = "\\raggedleft{%"; }.${align} indentation.more
                "\\begin{tikzpicture}%" indentation.more
                  "\\node[%" indentation.more
                    "${shape},%"
                    "draw                = ${if edge then "none" else "darkgray"},%"
                    "line width          = 0.1em,%"
                    "inner sep           = ${{ "circle" = "3.2em"; "rectangle" = "4.5em"; }.${shape}},%"
                    "fill overzoom image = \\source/${fileName},%"
                  indentation.less "] () {};%"
                indentation.less "\\end{tikzpicture}"
              indentation.less "}%"
            indentation.less "\\end{minipage}"
          ]
          else
            [];

    formatQuote
    =   quote:
        [
        ];

    formatSocial                        =   path.import ./social.nix libs config;
  in
    {
      about   ? null,
      name,
      photo   ? null,
      quote   ? null,
      show    ? true,
      social  ? null,
      ...
    }:
      list.ifOrEmpty' show
      (
        [ "\\begin{minipage}[c]{\\textwidth}%" indentation.more ]
        ++  (list.ifOrEmpty' (photo != null) (formatPicture "left" photo))
        ++  [ "\\begin{minipage}[c]{${if photo != null then ".75" else ""}\\linewidth}%" indentation.more ]
        ++  (formatHeaderName name)
        ++  [ "\\vspace{.4em}%" ]
        ++  (list.ifOrEmpty  (about != null) (formatHeaderAbout about))
        ++  [ (styles.headerAddress "${home}\\,${formatAddress social.address}\\\\[-.5em]") ]
        ++  [ "\\\\[-2.5\\normalbaselineskip]%" ]
        ++  (list.ifOrEmpty' (social != null) (formatSocial social))
        ++  (list.ifOrEmpty' (quote != null) (formatQuote quote))
        ++  [ indentation.less "\\end{minipage}%" ]
        ++  (list.ifOrEmpty' (photo != null) (formatPicture "right" photo))
        ++  [ indentation.less  "\\end{minipage}\\\\[0.5\\normalbaselineskip]%" ]
      )
