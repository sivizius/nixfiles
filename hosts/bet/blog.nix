{
  sivis-blog
  =   {
        enable                          =   true;
        title                           =   "Sivis Blog";
        articles
        =   [
              {
                title                   =   "Über dieses Blog hinaus!";
                author                  =   "sivizius";
                abstract
                =   ''
                      Das ist ein Artikel!
                    '';
                text
                =   ''
                      Hallo Welt!
                      ===========

                      Wie geht es ~~dir~~ __euch__?
                      Ich habe `schon` **so viel** von //dir// gehört!
                      Eigentlich ##nicht## so viel.

                      Das ist eine Liste:
                      >(URL) Block
                      : quote
                        >{Quellenangabe} Nested
                        : Block
                        : Quote
                      : Back
                      * 0 ABC
                      : abc
                      : : Indent!
                      : : More!
                      * 1 KLM
                      : klm
                      : *(2 NOP) 2 NOPE
                      : : nope
                      : : *{Summary} Details
                      : : : More Details
                      : k-l-m
                        *(3 QRS) 3 TUV
                        : tüv
                          * 4 123
                          : eins zwei drei
                            *(5 456) 5 789
                            : sieben acht neun
                            : * 6 XYZ
                            : : xyz
                            : 7-8-9 a
                            * hä

                      Das ist ein Bild:

                      Das ist die Bildbeschreibung
                      ![Alternativtext](https://external-preview.redd.it/Di9l4ORXUByiHfllJcxQkNqywSTAuhtmQWEbF2iwFKw.jpg?width=640&crop=smart&auto=webp&s=4fbed222b8ec30df5ad29448ebb42b7e02ed145e Titeltext)

                      Das ist Code:
                      ```rust
                      fn foo(bar: usize) -> ! {
                        let mut counter = 0;
                        while true {
                          println!("Counter: {}", counter);
                          counter += 1;
                        }
                      }
                      ```

                      $$$
                      1 + 2
                      f(x)..."Hello World"
                      f(x) = a*x^2 + b*x + c
                      f(x) = 0 <=> x = (-b+-sqrt(b^2-4ac))/(2a)
                      exp(ix) = cos(x) + i sin(x)
                      int(1/(1+ax) dx) = 1/a ln(1+ax) + C
                      e^z = lim_(n->inf)(1+z/n)^(n+0)
                      $$$
                    '';
              }
            ];
        authors
        =   {
              "sivizius".name = "Sebastian Walz";
            };
      };
}
/*
f(x)..."Hello World"
                        f(x) = a*x^2 + b*x + c
                        f(x) = 0 <=> x = (-b+-$sqrt(b^2-4ac))/(2a)
                        $exp(i x) = $cos(x) + i$sin(x)
                        $int((dx)/(1+ax)) = 1/a $ln(1+ax) + C
                        e^z = $lim_(n->$inf)(1+z/n)^n
                      */