{ config, pkgs, ... }:

{
  imports =
  [ 
    ./common/common.nix
  ];

  networking.hostName = "totem-vemsaber-1";
}