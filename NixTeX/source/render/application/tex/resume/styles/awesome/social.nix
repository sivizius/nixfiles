{ core, phonenumbers, symbols, styles, urls, ... }:
{ ... }:
  let
    inherit(core) indentation list;
    icons
    =   {
          inherit(symbols.forkAwesome)
            email-bulk fax
            git github gitlab gitea globe gnupg graduation-cap
            linkedin matrix-org medium mobile orcid phone reddit skype stackoverflow twitter wikipedia xing;
        };

    acvHeaderSocialSep
    =   "\\unskip\\enspace\\cleaders\\copy\\acvHeaderSocialSepBox\\hskip\\wd\\acvHeaderSocialSepBox\\enspace\\ignorespaces";

    formatEmail
    =   address:
          urls.formatEmailTeXboxed address "${icons.email-bulk}\\,${address}";

    formatGit
    =   { name, domain, isGitea ? false, ... }:
          let
            icon
            =   {
                  "github"              =   icons.github;
                  "github.com"          =   icons.github;
                  "gitlab"              =   icons.gitlab;
                  "gitlab.com"          =   icons.gitlab;
                }.${domain} or null;
            icon'
            =   if isGitea
                then
                  icons.gitea
                else
                  icons.git;
          in
            if icon != null
            then
              urls.formatHttpsTeXboxed "${domain}/${name}" "${icon}\\,${name}"
            else
              urls.formatHttpsTeXboxed "${domain}/${name}" "${icon'}\\,\\texttt{${domain}/${name}}";

    formatGoogleScholar
    =   { id, name }:
          urls.formatHttpsTeXboxed "scholar.google.com/citations?user=${id}" "${icons.graduation-cap}\\,${id}";

    formatHomePage
    =   homepage:
          urls.formatHttpsTeXboxed homepage "${icons.globe}\\,\\texttt{${homepage}}";

    formatLinkedIn
    =   { id, name }:
          urls.formatHttpsTeXboxed "www.linkedin.com/in/${id}" "${icons.linkedin}\\,${id}";

    formatMatrix
    =   { name, domain }:
          urls.formatHttpsTeXboxed "${domain}/${name}" "${icons.matrix-org}\\,@${name}:${domain}";

    formatMedium
    =   { id, name }:
          urls.formatHttpsTeXboxed "medium.com/@${id}" "${icons.medium}\\,${name}";

    formatOrcid
    =   { id, name }:
          urls.formatHttpsTeXboxed "orcid.org/${id}" "${icons.orcid}\\,${id}";

    formatPGP
    =   { fingerprint, url }:
          urls.formatHttpsTeXboxed url "${icons.gnupg}\\,\\texttt{${url} (\\texttt{${fingerprint}})}";

    formatPhoneNumber
    =   icon:
        number:
          "${icon}\\,${phonenumbers.formatTeX number}";

    formatReddit
    =   name:
          urls.formatHttpsTeXboxed "www.reddit.com/user/${name}" "${icons.reddit}\\,u/${name}";

    formatSkype                         =   name: "${icons.skype}\\,${name}";

    formatStackOverflow
    =   { id, name }:
          urls.formatHttpsTeXboxed "stackoverflow.com/users/${id}" "${icons.stackoverflow}\\,${name}";

    formatTwitter
    =   name:
          urls.formatHttpsTeXboxed "www.twitter.com/${name}" "${icons.twitter}\\,${name}";


    formatWikipedia
    =   { language ? "en", name }:
          urls.formatHttpsTeXboxed "${language}.wikipedia.org/wiki/User:${name}" "${icons.wikipedia}\\,${name}";

    formatXing
    =   { id, name }:
          urls.formatHttpsTeXboxed "www.xing.com/profile/${id}" "${icons.xing}\\,${name}";

    mapGit                              =   list.map formatGit;

    mapPhone
    =   { cell ? null, fax ? null, home ? null }:
          []
          ++  (list.ifOrEmpty  (cell != null) (formatPhoneNumber icons.mobile cell))
          ++  (list.ifOrEmpty  (home != null) (formatPhoneNumber icons.phone  home))
          ++  (list.ifOrEmpty  (fax  != null) (formatPhoneNumber icons.fax    fax));
  in
    {
      email         ? null,
      git           ? null,
      googleScholar ? null,
      homepage      ? null,
      linkedIn      ? null,
      matrix        ? null,
      medium        ? null,
      orcid         ? null,
      pgp           ? null,
      phone         ? null,
      reddit        ? null,
      show          ? true,
      skype         ? null,
      stackOverflow ? null,
      twitter       ? null,
      wikipedia     ? null,
      xing          ? null,
      ...
    }:
      let
        items
        =   (list.ifOrEmpty  (matrix         != null) (formatMatrix         matrix))
        ++  (list.ifOrEmpty  (skype          != null) (formatSkype          skype))
        ++  (list.ifOrEmpty' (git            != null) (mapGit               git))
        ++  (list.ifOrEmpty  (stackOverflow  != null) (formatStackOverflow  stackOverflow))
        ++  (list.ifOrEmpty  (linkedIn       != null) (formatLinkedIn       linkedIn))
        ++  (list.ifOrEmpty  (xing           != null) (formatXing           xing))
        ++  (list.ifOrEmpty  (twitter        != null) (formatTwitter        twitter))
        ++  (list.ifOrEmpty  (reddit         != null) (formatReddit         reddit))
        ++  (list.ifOrEmpty  (googleScholar  != null) (formatGoogleScholar  googleScholar))
        ++  (list.ifOrEmpty  (orcid          != null) (formatOrcid          orcid))
        ++  (list.ifOrEmpty  (medium         != null) (formatMedium         medium))
        ++  (list.ifOrEmpty  (wikipedia      != null) (formatWikipedia      wikipedia))
        ++  (list.ifOrEmpty  (homepage       != null) (formatHomePage       homepage))
        ++  (list.ifOrEmpty' (phone          != null) (mapPhone             phone))
        ++  (list.ifOrEmpty  (email          != null) (formatEmail          email))
        ++  (list.ifOrEmpty  (pgp            != null) (formatPGP            pgp));
      in
        list.ifOrEmpty' show
        (
          [
            "\\begin{center}%" indentation.more
            styles.headerSocialOpen indentation.more
          ]
          ++  (
                list.fold
                (
                  result:
                  item:
                    if result != []
                    then
                      result ++ [ "${acvHeaderSocialSep}{${item}}%" ]
                    else
                      result ++ [ "{${item}}%" ]
                )
                []
                items
              )
          ++  [
                indentation.less styles.headerSocialClose
                indentation.less "\\end{center}%"
              ]
        )
