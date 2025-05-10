{ pkgs, ... }:
[
  (
    let
      version = "4.9.105";
    in
    pkgs.fetchFirefoxAddon {
      name = "darkreader";
      url = "https://github.com/darkreader/darkreader/releases/download/v${version}/darkreader-firefox.xpi";
      hash = "sha256-tKppApOFAP21PekXJy+4wfR2eDqId8lRWzsGvluI5KA=";
    }
  )

  (
    let
      version = "1.21";
    in
    pkgs.fetchFirefoxAddon {
      name = "passff";
      url = "https://codeberg.org/PassFF/passff/releases/download/${version}/passff.xpi";
      hash = "sha256-ILMqKGFluEsdWbSqJAnI4FHRGgv+zxZb2juxLYLA3tY=";
    }
  )

  (
    let
      version = "final";
    in
    pkgs.fetchFirefoxAddon {
      name = "scihubify";
      url = "https://github.com/sivizius/scihubify/raw/refs/heads/master/${version}/scihubify.xpi";
      hash = "sha256-OfmYMlbR5/fgHorIFKYPsFmpZMYN/SumN7R76z7CCBQ=";
    }
  )

  (
    let
      version = "5.3.3";
      version' = "${version}.7";
    in
    pkgs.fetchFirefoxAddon {
      name = "sideberry";
      url = "https://github.com/mbnuqw/sidebery/releases/download/v${version}/sidebery-${version'}.xpi";
      hash = "sha256-/fprPSy56zYsyf9XVpsVC/NSLKbfNMRHGXEoNY6nN2s=";
    }
  )

  (
    let
      version = "5.11.11";
    in
    pkgs.fetchFirefoxAddon {
      name = "sponsor-block";
      url = "https://github.com/ajayyy/SponsorBlock/releases/download/${version}/FirefoxSignedInstaller.xpi";
      hash = "sha256-i64HPxWrsguGEHnvRaSphXI+lKRLfOQKDfAFxSeMdPM=";
    }
  )

  (
    let
      version = "1.63.2";
    in
    pkgs.fetchFirefoxAddon {
      name = "ublock";
      url = "https://github.com/gorhill/uBlock/releases/download/${version}/uBlock0_${version}.firefox.signed.xpi";
      hash = "sha256-2TF2zvTcBC5BulAKoqkOXVe1vndEnL1SIRFYXjoM0Vg=";
    }
  )
]
