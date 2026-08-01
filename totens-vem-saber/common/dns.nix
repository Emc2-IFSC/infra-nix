{ config, pkgs, lib, inputs, ... }: {
  # self-hosted DNS config to block unwanted websites
   
  networking.nameservers = [ "[::1]" "127.0.0.1" ]; # Set localhost as DNS

  # DNS server configuration
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    openFirewall = false;
    host = "0.0.0.0";
    port = 178;

    settings = {
      users = [
        {
          name = "admin";
          password = "$2a$12$08jUqiuAuZSMiZOmc1WrQezvRcQ6gX6T/0Ik6frS.Y0kb0wdX13Aa";  
        }
      ];

      http = {
        # You can select any ip and port, just make sure to open firewalls where needed
        address = "0.0.0.0:178";
      };
      
      dns = let
        upstreams = if config.services.unbound.enable
          then  [
          "[::1]:${toString config.services.unbound.settings.server.port}"
          ]
          else fallback;
        fallback = [
            "1.1.1.1" # Cloudflare
            "2606:4700:4700::1111" #Cloudflare
            "9.9.9.11" # Quad9
            "2620:fe::11" # Quad9

            # Uncomment the following to use a local DNS service (e.g. Unbound)
            # Additionally replace the address & port as needed
            # "127.0.0.1:5335"
          ];
      in
        {
          bootstrap_dns = upstreams;
          bootstrap_prefer_ipv6 = true;
          upstream_dns = upstreams;
          fallback_dns = fallback;
        };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = true;
        safe_search.enabled = true;
        safebrowsing_enabled = true;
      };
      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters = map(url: { enabled = true; url = url; }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_2_Base/filter.txt"
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_24.txt" # 1Hosts (Lite)
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
      ];
      user_rules = [
        # Extra websites to block can go here!
        # Examples:
        # "||google.com^" # Block google.com and all its subdomains
        # "www.google.com" # Block only "www.google.com"
      ];
    };
  };
}
