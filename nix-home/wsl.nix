{ config, pkgs, ... }:
{
  imports = [ ./common.nix ];

  services.gpg-agent.enableSshSupport = false;
  programs.git.signing.signByDefault = false;
}
