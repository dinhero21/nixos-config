{ ... }:

{
  services.openssh.enable = true;
  users.users.dinhero21.openssh.authorizedKeys.keyFiles = [ ./dinhero21.pub ];
}
