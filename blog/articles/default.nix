{ Article, ... } @ lib:
{ authors, ... } @ env:
  map
    (
      article:
        import article lib env
    )
    [
      ./My-NixOS-Configuration
    ]