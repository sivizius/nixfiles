ignore
=   {
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "a", "an", "and", "also", "are", "as",
      "b", "be", "being", "bullshit", "but",
      "c", "comes",
      "d",
      "e",
      "f", "for", "freak", "fuck",
      "g", "go", "goes", "going",
      "h", "has", "have", "his", "her",
      "i", "in", "into", "is", "it",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o", "odd", "of", "on", "one", "or", "our",
      "p",
      "q",
      "r",
      "s",
      "t", "take", "than", "that", "the", "then", "there", "this", "to", "too",
      "u",
      "v",
      "w", "want", "was", "went", "we’re", "what", "when", "where", "will", "with",
      "x",
      "y", "you", "your", "you’re",
      "z",
    }

keywords
=   {
      "0",
      "1",  "1.0", "10 years", "11 years", "12 years", "13 years", "1337", "14 years", "15 years",
      "2",  "2 years", "2+ years", "23",
      "3",  "3 years", "3+ years",
      "4",  "4 years", "4+ years", "42",
      "5",  "5 years", "5+ years",
      "6",  "6 years", "6+ years",
      "7",  "7 years", "7+ years",
      "8",  "8 years", "8+ years",
      "9",  "9 years", "9+ years",
      "A",  "Admin", "Administrator", "agil", "agility", "AI", "amazon", "AMD", "android", "Apple", "artificial intelligence", "awk",
      "B",  "B.Sc.", "bachelor degree", "BASF", "bash", "big data", "blockchain", "browser", "business",
      "C",  "C++", "C\\#", "California Institute of Technology", "Chemnitz University of Technology", "Cobol", "code", "Columbia University", "Cornell University", "crypto",
            "cryptography", "css", "customer",
      "D",  "data mining", "developer", "Dr.",
      "E",  "embedded", "ETH Zürich", "experience",
      "F",  "F\\#", "flexible", "fortran", "fourier", "future",
      "G",  "Go", "Google",
      "H",  "Harvard University", "Haskell", "html", "html5",
      "I",  "Imperial College London", "Intel",
      "J",  "java", "js",
      "K",  "Karlsruhe Institute of Technology", "KIT",
      "L",  "LaTeX", "luaLaTeX", "Linux", "Lisp",
      "M",  "M.Sc.", "machine learning", "Massachusetts Institute of Technology", "master degree", "Microsoft", "MIT", "mobile",
      "N",  "Nanyang Technological University", "National University of Singapore",
      "O",  "office", "online",
      "P",  "partner", "PDF", "perl", "PhD", "phone", "php", "Princeton University", "Prof.", "professional", "project manager", "Projektmanager", "python",
      "Q",  "quality", "quantum",
      "R",  "Ruby", "Rust",
      "S",  "Scala", "Senior", "sh", "Silcon Valley", "smart", "software architect", "software developer", "Stanford University", "success", "system",
      "T",  "team", "TeX", "time-to-market", "Tsinghua-Universität", "TypeScript",
      "U",  "University College London", "University of California, Berkeley", "University of Cambridge", "University of Chicago", "University of Edinburgh", "University of Michigan",
            "University of Oxford", "University of Pennsylvania", "University of Sivicia",
      "V",
      "W",  "Windows",
      "X",  "XeLaTeX",
      "Y",  "Yale University",
      "Z",  "zsh",
    }

seperators                        =   " ?!.:,;()/&{}<>’"

function hideKeywords(text)
  for keyword                           in  text:gmatch ( "[^"..seperators.."]+"  )
  do
    if  ( not contains  ( ignore,   keyword ) )
    and ( not contains  ( keywords, keyword ) )
    then
      table.insert ( keywords, keyword )
    end
  end
  for index,  keyword                   in  ipairs  ( keywords  )
  do
    tex.print ( keyword:gsub  ( " ",  "\\quad " ).."\\quad" )
  end
end
