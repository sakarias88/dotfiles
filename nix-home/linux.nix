{ config, pkgs, ... }:
{
  imports = [ ./common.nix ];

  services.gpg-agent.enableSshSupport = true;
  programs.git.signing.signByDefault = false; # TODO: Should be true
}
