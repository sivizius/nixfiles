Service "Kubernetes Master"
{
  configuration
  =   { core, registries, ... }:
      {
        kubernetes
        =   let
              inherit(core) string;
              masterIP                  =   "10.1.1.2";
              masterAddress             =   "api.kube";
              masterPort                =   6443;
            in
            {
              inherit masterAddress;
              addons.dns.enable         =   true;
              apiserverAddress          =   "https://${masterAddress}:${string masterPort}";
              apiserver
              =   {
                    securePort          =   masterPort;
                    advertiseAddress    =   masterIP;
                  };
              easyCerts                 =   true;
              kubelet.extraOpts         =   "--fail-swap-on=false";
              roles                     =   [ "master" "node" ];
            };
      };
}
