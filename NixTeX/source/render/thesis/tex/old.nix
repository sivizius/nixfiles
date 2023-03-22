[
  "\\cleardoublepage"
  "\\chapter*{Bibliografische Beschreibung}{" indentation.more
  "${authorList} \\\\ \\\\"
  "\\textbf{${title}}\\\\\\\\"
  "${thesis.organisation.name},"
  "${thesis.organisation.department} \\\\"
  "${thesis.title}~"
  "${time.formatDate' date "deu"},"
  "\\thelastpage~Seiten%"
  "%\\relax\\ifthenelse{\\equal{\\totalfigures}{0}}{}{, \\ifthenelse{\\equal{\\totalfigures}{1}}{eine~Abbildung}{\\totalfigures~Abbildungen}}%"
  "%\\relax\\ifthenelse{\\equal{\\totaltables} {0}}{}{, \\ifthenelse{\\equal{\\totaltables} {1}}{eine~Tabelle}  {\\totaltables~Tabellen}}%"
  "%\\ifthenelse{\\equal{\\totalfigures\\totaltables}{00}}{\\\\}{\\linebreak}\\\\"
  "${abstract}"
  "\\vfill"
  "\\begin{tabularx}{\\linewidth}{@{}lX@{}}"
  indentation.more
  "Schlagworte  & \\textit{${string.concatCSV keywords}}"
  indentation.less
  "\\end{tabularx}"
  indentation.less "{"
]
