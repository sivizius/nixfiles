{
  Add = [
    {
      Alias = "@google";
      Description = "Google Search";
      IconURL = "https://www.google.com/favicon.ico";
      Method = "GET";
      Name = "Google";
      URLTemplate = "https://www.google.de/search?q={searchTerms}";
    }

    {
      Alias = "@ddg";
      Description = "DuckDuckGo Search";
      IconURL = "https://www.google.com/favicon.ico";
      Method = "GET";
      Name = "DuckDuckGo";
      URLTemplate = "https://www.google.de/search?q={searchTerms}";
    }

    {
      Alias = "@homecfg";
      Description = "Find home manager options quickly.";
      IconURL = "https://avatars.githubusercontent.com/u/33221035?s=128&v=4";
      Method = "GET";
      Name = "Home Manager Options";
      URLTemplate = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
    }

    {
      Alias = "@nixpkg";
      Description = "Search NixOS packages by name or description.";
      IconURL = "https://search.nixos.org/favicon.png";
      Method = "GET";
      Name = "NixOS packages";
      URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
    }

    {
      Alias = "@docrs";
      Description = "Search for crate documentation on docs.rs.";
      IconURL = "https://docs.rs/-/static/favicon.ico";
      Method = "GET";
      Name = "Rust Documentation";
      URLTemplate = "https://docs.rs/releases/search?query={searchTerms}";
    }
  ];

  Default = "";
}
