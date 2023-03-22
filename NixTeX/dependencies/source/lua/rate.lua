function rateFullStars  ( stars,  maximum )
  stars                                 =   eval(stars)
  maximum                               =   eval(maximum)
  assert
  (
    stars ~=  nil and maximum ~=  nil,
    "cannot print full stars: " ..  stars ..  " – " ..  maximum
  )
  full                                  =   math.floor(stars*maximum)
  rest                                  =   maximum  - full
  tex.print (("\\faStar"):rep(full)..("\\faStarO"):rep(rest))
end

function rateHalfStars  ( stars,  maximum )
  stars                                 =   eval(stars)
  maximum                               =   eval(maximum)
  assert
  (
    stars ~=  nil and maximum ~=  nil,
    "cannot print half stars: " ..  stars ..  " – " ..  maximum
  )
  full                                  =   math.floor(stars*maximum)
  rest                                  =   math.floor((1-stars)*maximum)
  half                                  =   maximum  - full  - rest
  tex.print (("\\faStar"):rep(full)..("\\faStarHalfFull"):rep(half)..("\\faStarO"):rep(rest))
end
