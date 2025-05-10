{ Article, ... }:
{ authors, ... }:
  Article "My NixOS-Configurations"
  {
    authors                             =   with authors; [ sivizius ];
    dateTime                            =   "2022-12-14";
  }
  [
    (
      Heading "/etc/nixos/configuration.nix"
      [
        ''
          The simplest way to configure a NixOS-system is:
          Just write e.g.
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "/etc/nixos/configuration.nix";
          }
          ./code/configuration.nix
        )
        ''
          And then you run `nixos-rebuild switch` to build and switch to your configuration.
        ''
      ]
    )
    (
      Heading "Flakes"
      [
        ''
          But nowadays, flakes are the new hot shit you want, so the next step would be:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "flake.nix";
          }
          ./code/flake1.nix
        )
        (
          RubberDuck
          ''
            Cool, but what is `foo`?
          ''
        )
        ''
          That is the host, so you can have the configuration of multiple hosts in one flake.
          Now you can execute `nixos-rebuild switch --flake /path/to/your/flake#foo` on host `foo` to apply this configuration.
        ''
      ]
    )
    (
      Heading "Multiple Hosts"
      [
        ''
          But multiple hosts probably share a lot of their configuration,
            so the next step is something like this as `outputs`:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "flake.nix";
          }
          ./code/flake2.nix
        )
      ]
    )
    (
      Heading "Profiles"
      [
        (
          RubberDuck
          ''
            Just a common configuration might be suitable for two hosts,
              but what about
                two desktop systems like PC and laptop as well as
                two cloud servers at $cloudHServerHster and
                another server in a rack?
          ''
        )
        ''
          Easy, just set `hosts` to:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "flake.nix";
          }
          ./code/flake3.nix
        )
        ''
          Put a `common/default.nix` in `./profiles` and import it from the other three profiles
            to have some inheritance to remove redundant configurations.
          E.g. you could have a serverCommon-profile,
            which inherits from common and is inherited by both hetznerCloudServer and physicalServer.
        ''
      ]
    )
    (
      Heading "Services"
      [
        (
          RubberDuck
          ''
            Oh, and I want to have gitea on the physical server as well as
              on one of the cloud servers, but not the other?
          ''
        )
        ''
          …I guess, I should seperate profiles and services then:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "profiles/default.nix";
          }
          ./code/profiles/default.nix
        )
        ''
          and for services something like this:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "services/default.nix";
          }
          ./code/services/default.nix
        )
        ''
          Hosts should be seperate file too:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "hosts/default.nix";
          }
          ./code/hosts/default1.nix
        )
        ''
          Let us rewrite the `outputs` of our original flake:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "flake.nix";
          }
          ./code/flake4.nix
        )
        (
          RubberDuck
          ''
            Ufff, that is quite a change…but what about `Host`, `Profile` and `Service`?
          ''
        )
        ''
          That is some custom typing: nix, the language, only has
            booleans, integers, floats, functions, lists, null, paths, sets, and strings.
        ''
        (
          RubberDuck
          ''
            And derivations…
          ''
        )
        ''
          Actually no:
            Derivations are just sets with a field `type` set to `derivation`,
              so I am not the first one who invented this kind of subtyping sets.
        ''
      ]
    )
    (
      Heading "Users"
      [
        (
          RubberDuck
          ''
            My Laptop and PC might have just one user,
              but I like to let some trusted people manage my servers.
            And they have other preferences e.g. on how `htop` should look like.
            How can I do that?
          ''
        )
        ''
          We can extend the definition of `Host` with a field `users`:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "lib/default.nix";
          }
          ./code/lib/default1.nix
        )
        ''
          And define some users as seperate flakes:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "sivizius.nix";
          }
          ./code/users/sivizius.nix
        )
        ''
          and foobar:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "foobar.nix";
          }
          ./code/users/foobar.nix
        )
        ''
          This way, the other people just have
            to add their configuration,
            push it e.g. to github and
            when I re-deploy the hosts,
              I can automatically pull their configurations.
          Finally add them to the hosts in our flake:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "hosts/default.nix";
          }
          ./code/hosts/default2.nix
        )
        ''
          And modify the flake:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "flake.nix";
          }
          ./code/flake5.nix
        )
        ''
          These user-configurations should only configure stuff with home-manger,
            so we do not have to check the files these other administriators give us.
          They should only be able to make their own user environment on my systems unusable.
          Only the provided keys are relevant for the system-configuration of the hosts,
            so I and the other users can access my hosts.
        ''
      ]
    )
    (
      Heading "Network"
      [
        (
          RubberDuck
          ''
            Have you heard about the internet?
            My hosts have some peers and like to connect to each other.
          ''
        )
        ''
          Fine, so we need two different kind of network nodes: hosts and peers.
          And hosts should have some network-configuration defining e.g. ports as well as a list of peers:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "hosts/default.nix";
          }
          ./code/hosts/default3.nix
        )
      ]
    )
    (
      Heading "Dependencies"
      [
        (
          RubberDuck
          [
            ''
              As a recap: We have hosts and peers, profiles, services and users.
              Peers should not have any dependencies,
                because I have no controll over them.
              They are more like a interface definition,
                so my hosts can interact with them.
              Hosts on the other hand can depend on other peers and hosts as well as the profile, services and users.
              Profiles might provide some services, so they depend on them.
            ''
            ''
              Services might depend on other services and
                some services are doing network-stuff,
                  so they need the network-settings of the host.
              And the ssh-service needs to know the trusted keys by the users.
            ''
            ''
              Oh, and might be relevant for user-configurations,
                if we have a desktop-host with a graphical user-interface
                or just a server with ssh-access only.
            ''
          ]
        )
        ''
          Good points:
            I already equipped the profiles with a boolean `isDesktop`-field,
              but the module-system of nixos-configurations do not allow such a sepperation by itself.
          All modules are called with attribute set containing the full configuration `config`.
          We can work with that, I think:
        ''
        (
          CodeBlock
          {
            language  =   "nix";
            file      =   "lib/default.nix";
          }
          ./code/lib/default2.nix
        )
      ]
    )
    /*
    (
      Heading "Registries"
      [
        ''
          For example, you can easily check that all packages in `pkgs` are `derivations`:
          ```{nix}
            let
              inherit(builtins) attrValues foldl' getFlake isAttrs mapAttrs trace tryEval typeOf;
              nixpkgs = getFlake "github:NixOS/nixpkgs";
              pkgs    = nixpkgs.legacyPackages."x86_64-linux";
            in
              foldl'
              (
                state:
                { name, package }:
                  let
                    package' = tryEval package;
                  in
                    if package'.success
                    then
                      if isAttrs package'.value
                      then
                        if package'.value.type or null == "derivation"
                        then
                          state && true
                        else
                          trace "''${name} is a set, but not a derivation" false
                      else
                        trace "''${name} is not a set, but a ''${typeOf package'.value}" false
                    else
                      trace "''${name} cannot be evaluated o.O" false
              )
              true
              (attrValues ( mapAttrs (name: package: { inherit name package; }) pkgs))
          ```
          We get:
          ```{console}
            trace: AAAAAASomeThingsFailToEvaluate cannot be evaluated o.O
            trace: CuboCore is a set, but not a derivation
            …
            trace: _type is not a set, but a string
            …
            trace: addAttrsToDerivation is not a set, but a lambda
            …
            trace: elf-header is not a set, but a null
            …
            trace: libintlOrEmpty is not a set, but a list
            …
            trace: pathsFromGraph is not a set, but a path
            …
            trace: python3Packages is set, but not a derivation
            …
            false
          ```
          Oh, I guess, that is why it is called legacy.
          It seems, most of `pkgs` is either a derivation or a set of derivation like `python3Packages`.
          The flake-output `packages` expects a set of sets of derivation (`packages.<system>: { string -> derivation };`),
            so
        ''
      ]
    )
    */
  ]