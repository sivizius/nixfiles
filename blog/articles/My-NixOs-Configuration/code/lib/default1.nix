# ignore
{
# /ignore
Host
=   about:
    {
      config,
      profile,
      services  ? [],
      system,
      users,
    }:
    {
      inherit about config profile services system users;
      __type__  = "Host";
      name      = null;
    };
# ignore
}
# /ignore