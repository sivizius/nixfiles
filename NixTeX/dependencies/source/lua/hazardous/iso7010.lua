function iso7010data  ( hazardousData )
  local result                          =   hazardousData.iso7010 or  {}
  result.warnings                       =   result.warnings       or  {}
  return result
end

function iso7010Pictrograms ( iso7010, pictograms )
  for index, pictogram                  in  ipairs  ( iso7010.warnings  )
  do
    table.insert
    (
      pictograms,
      "\\includegraphics[width=\\@HazardousPictogramSize]"
      ..  ( "{"..source.."/assets/pictograms/iso7010/warnings/%03d.pdf}" ):format  ( pictogram )
    )
  end
end
