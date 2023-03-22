chem.spectra                            =   {}

function chem.spectra.draw(xlabel, ylabel, unsetX, unsetY, title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks, above, points)
  if  type  ( fileName ) ==  "table"
  then
    theFunction                         =   {}
    for index, file                     in  ipairs  ( fileName  )
    do
      if  type  ( file ) ==  "table"
      then
        markFileAsUsed  ( file  [ 1 ] )
        file  [ 1 ]                     =   "'"..file[1].."'"
        table.insert  ( theFunction,  file                )
      else
        markFileAsUsed  ( file  )
        table.insert  ( theFunction,  "'"..file.."'"  )
      end
    end
  else
    markFileAsUsed  ( fileName  )
    theFunction                         =   "'"..tostring(fileName).."'"
  end
  return  gnuplot.plotFunction
          (
            xlabel,
            ylabel,
            unsetX, unsetY,
            title  or  "\\GetTitleStringResult",
            theFunction,
            xMin, xMax,
            yMin, yMax,
            colour, plot,
            peaks, above,
            points
          )
end

function chem.spectra.ir(title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks)
  return  chem.spectra.draw
          (
            "${\\acrshort{waveNumber} / \\Newunit{cm-1}{}}$",
            "${\\text{Transmission} / \\Newunit{percent}{}}$",
            false,  false,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            peaks,  false
          )
end

function chem.spectra.raman(title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks)
  return  chem.spectra.draw
          (
            "${\\Delta\\acrshort{waveNumber} / \\Newunit{cm-1}{}}$",
            "${\\text{Intensität}}$",
            false,  true,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            peaks,  true
          )
end

function chem.spectra.pxrd(title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks)
  return  chem.spectra.draw
          (
            "${2\\,\\Theta / \\Newunit{degree}{}}$",
            "${\\text{Intensität}}$",
            false,  true,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            peaks,  true
          )
end

function chem.spectra.uvvis(title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks)
  return  chem.spectra.draw
          (
            "${\\acrshort{waveLength} / \\Newunit{nanometre}{}}$",
            "${\\text{Extinktion}}$",
            false,  true,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            peaks,  true
          )
end

function chem.spectra.iuvvis(title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks)
  return  chem.spectra.draw
          (
            "${\\acrshort{waveNumber} / \\Newunit{cm-1}{}}$",
            "${\\text{Extinktion}}$",
            false,  true,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            peaks,  true
          )
end

function chem.spectra.tauc(title, fileName, xMin, xMax, yMin, yMax, colour, plot, peaks)
  return  spectra
          (
            "${\\acrshort{bandGap} / \\Newunit{electronVolt}{}}$",
            "${\\left(\\acrshort{absorptionCoefficient}\\cdot\\acrshort{planckConstant}\\cdot\\acrshort{waveFrequency}\\right)^2}$",
            false,  false,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            peaks,  true
          )
end

function chem.spectra.cv(title, reference, fileName, xMin, xMax, yMin, yMax, colour, plot, points)
  return  chem.spectra.draw
          (
            "${\\acrshort{dcVoltage} / \\Newunit{volt}{}}$ \\acrshort{versus} "..reference,
            "${\\acrshort{dcCurrent} / \\Newunit{microampere}{}}$",
            false,  false,
            title,  fileName,
            xMin,   xMax,
            yMin,   yMax,
            colour, plot,
            false,  true,
            points
          )
end
