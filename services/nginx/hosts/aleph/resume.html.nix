{ web, ... }:
{ head, ... }:
  let
    inherit(web.html) HTML;
  in
    HTML { language = "eng"; }
    {
      inherit head;
      body
      =   with web.html;
          [
            (
              main
              [
                (
                  header
                  [
                    (h1 "Sebastian Walz")
                  ]
                )
                (
                  section
                  [
                    (h2 "Summary")
                    (
                      p ''
                          As a chemist (M.Sc.) with a focus on
                            synthetic organometallic chemistry,
                            in particularly ferrocene chemistry,
                          I was not only able to gain valuable practical experience
                            in various instrumental analysis techniques and
                            learn to critically evaluate data and process results during my studies,
                              but also also expand my skills
                                in programming languages
                                of different paradigms
                                like Nix, Python, C++, Rust and others.
                        ''
                    )
                    (
                      p ''
                          I have practical experience with
                            the usual development tools,
                            assembler,
                            reverse engineering of software and
                            I am familiar with
                              theoretical computer science,
                              cryptography,
                              Linux and
                              especially the Nix/NixOS ecosystem.
                          By operating my own server infrastructure with e-mail, monitoring, DNS, etc.
                            I was able to gain valuable experience in network and system administration.
                        ''
                    )
                    (
                      p ''
                          I am therefore open to opportunities that require
                            both my knowledge of chemistry and IT and
                            in which I can use my
                              mathematical and scientific problem-solving skills and
                              analytical thinking skills.
                        ''
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Education")
                    (
                      dl
                      [
                        (dt "Master of Science (M.Sc.) in Chemistry @ Chemnitz University of Technology (2018–2023)")
                        (dd [
                              (p "Grade:&nbsp;1.6 (Thesis:&nbsp;1.5)")
                              (
                                p ''
                                    Thesis in the Group Organometallic Chemistry of Prof. Heinrich Lang
                                      »Synthesis and Characterisation of Sulfur-Functionalised Ferrocenyl Pyrenes«
                                  ''
                              )
                            ]
                        )
                        (dt "Bachelor of Science (B.Sc.) in Chemistry @ Chemnitz University of Technology (2015–2018)")
                        (dd [
                              (p "Grade:&nbsp;2.0 (Thesis:&nbsp;1.3)")
                              (
                                p ''
                                    Thesis in the Department of Anorganic Chemistry of Prof. Heinrich Lang
                                      »Structural Diversity of Ferrocenyl Functionalised Iron Carbonyl Phosphinyl Clusters«
                                  ''
                              )
                            ]
                        )
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Software Development")
                    (
                      dl
                      [
                        (dt "LaTeX")                      (dd "luaLaTeX, plainTeX, pdfTeX")
                        (dt "Web/Frontend")               (dd "CSS3, HTML5, JavaScript, PHP, TypeScript")
                        (dt "General Purpose Languages")  (dd "C/C++, Go, Java, Nim, PureBasic, Rust")
                        (dt "Scripting Languages")        (dd "Bash, Lua, Nix, Python 3")
                        (dt "Assembly")                   (dd "fasm, nasm; amd64, x86, avr")
                        (dt "Embedded")                   (dd "Arduino, AVR/ATmega, Raspberry Pi")
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "IT-Skills")
                    (
                      dl
                      [
                        (dt "Operating Systems")  (dd "Linux (+10 years): Debian, NixOS (+4 years)")
                        (dt "Server/Networking")  (dd "bind, gitea, grafana+prometheus, let's encrypt, nginx, ssh")
                        (dt "Miscellaneous")      (dd "git, gnupg, luks, VS&nbsp;Code/Codium")
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Recreation")
                    (
                      dl
                      [
                        (dt "Diving") (dd "DTSA/CMAS* (ISO 24801-2) since 2021")
                        (dt "Chess")  (dd "For 20+ years, also in a club and regional tournaments for some time")
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Languages")
                    (
                      dl
                      [
                        (dt "German")   (dd "Native Speaker")
                        (dt "English")  (dd "Independent User (B2)")
                        (dt "Ivrit")    (dd "Basic User (A1)")
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Committees")
                    (
                      dl
                      [
                        (dt "Study Commission Bachelor/Master Chemistry (2017–2021)")                   (dd "Student Member")
                        (dt "Student Council Chemistry Institute (2016–2021)")                          (dd "Full Member")
                        (dt "Selection Committee for the W3-Professorship »Organic Chemistry« (2020)")  (dd "Student Member")
                        (dt "Selection Committee for the W2-Professorship »Applied Quantum Chemistry and Computational Chemistry« (2018)")
                        (dd "Student Member")
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Participation in Competitions")
                    (
                      dl
                      [
                        (dt "Jugend Forscht (»youth researches«) STEM-compition (regional level) in the chemistry-category (Chemnitz 2014)")
                        (dd "Wet-chemistry electronics based on aluminium.")
                        (dt "Jugend Forscht (»youth researches«) STEM-compition (regional level) in the engineering-category (Chemnitz 2013)")
                        (dd "Retrofitting of an light microscope for mlting point analysis with an controller (ATmega 16, BASCOM-AVR), PC-connection (PureBasic) and a camera with image recognition.")
                      ]
                    )
                  ]
                )
                (
                  section
                  [
                    (h2 "Publications")
                    (
                      ol
                      [
                        (li ''
                              M. Korb, L. Xianming, S. Walz, J. Mahrholdt, A. Popov, H. Lang,
                              »Structural Variety of Iron Carbonyl Clusters Featuring Ferrocenylphosphines«,
                              ${em "Eur. J. Inorg. Chem."} ${b "2021"}, ${em "2021"}, ${em "2017–2033"},
                              ${a { href = "https://chemistry-europe.onlinelibrary.wiley.com/doi/10.1002/ejic.202100097"; } "DOI 10.1002/ejic.202100097"}.
                            '')
                        (li ''
                              M. Korb, L. Xianming, S. Walz, M. Rosenkranz, E. Dmitrieva, A. Popov, H. Lang,
                              »(Electrochemical) Properties and Computational Investigations of Ferrocenyl-substituted
                                Fe${sub "3"}(μ${sub "3"}-PFc)${sub "2"}(CO)${sub "9"} and Co${sub "4"}(μ${sub "4"}-PFc)${sub "2"}(CO)${sub "9"}
                              Clusters and Their Reduced Species«,
                              ${em "Inorg. Chem."} ${b "2020"}, ${em "59"}, ${em "6147–6160"},
                              ${a { href = ""; } "DOI 10.1021/acs.inorgchem.0c00276"}.
                            '')
                      ]
                    )
                  ]
                )
              ]
            )
          ];
    }
