-- Consulta de lectura: no modifican la configuración.

SELECT version() AS version_servidor;

SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity
ORDER BY usename, datname, client_addr;

-- Ubicación de datos, archivos de configuración y logs.
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;
