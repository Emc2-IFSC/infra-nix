{lib, inputs, config, pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
    
    ensureDatabases = [
      
    ];

    ensureUsers = [
      {
        name = "mysqlbackup";
        ensurePermissions = {
          "*.*" = "SELECT, LOCK TABLES";
        };
      }
    ];
  };

  services.mysqlBackup = {
    enable = true;
    databases = config.services.mysql.ensureDatabases;
  };
}