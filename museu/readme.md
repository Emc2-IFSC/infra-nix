## Informações

VM no IFSC

Comando de rebuild, a partir do ssh para a conta `admin`: `git pull && sudo nixos-rebuild switch --flake ~/infra-nix`

## Instalação Inicial

**Apenas** para se precisar reinstalar a partir de uma VM **limpa** de ubuntu!

Instalado via nixos-infect

1. ssh para root na VM
1. Clone o fork do nixos-infect: `git clone https://github.com/LuNeder/nixos-infect/`
1. `cd nixos-infect`
1. Checkout para a branch com as portas extras de ssh: `git checkout patch-1`
1. `cat ./nixos-infect | NIX_CHANNEL=nixos-24.05 bash -x`

faça ssh novamente, agora já com nixos

1. `nix-shell -p git`
1. `git clone https://github.com/Emc2-IFSC/infra-nix`
1. `cd infra-nix`
1. Talvez seja necessário adaptar o `infra-nix/museu/hardware-configuration.nix` com base no que foi gerado em `/etc/hardware-configuration.nix` para a nova VM
1. `nixos-rebuild boot --flake .#museu`
1. `reboot`
1. ssh novamente, agora para a conta admin
1. Instalação completa!