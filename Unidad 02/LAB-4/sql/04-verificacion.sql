-- Consulta de lectura. Comparar estos resultados con configuracion/baseline.md.

SELECT
    current_setting('port') AS puerto,
    current_setting('listen_addresses') AS listen_addresses,
    current_setting('password_encryption') AS password_encryption,
    current_setting('ssl') AS ssl,
    current_setting('ssl_min_protocol_version') AS ssl_min_protocol_version;

-- Detecta las máscaras equivalentes a cualquier IPv4 o IPv6.
-- No se incluyen reglas locales, cuyo campo address es NULL.
SELECT line_number, type, database, user_name, address, netmask, auth_method
FROM pg_hba_file_rules
WHERE (address = '0.0.0.0' AND netmask = '0.0.0.0')
   OR (address = '::' AND netmask = '::')
ORDER BY line_number;

-- Roles con capacidades administrativas o de creación.
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles
WHERE rolsuper OR rolcreaterole OR rolcreatedb
ORDER BY rolname;

-- Conexiones actuales y uso de TLS.
SELECT
    a.usename,
    a.datname,
    a.client_addr,
    a.application_name,
    s.ssl,
    s.version
FROM pg_stat_activity AS a
LEFT JOIN pg_stat_ssl AS s USING (pid)
ORDER BY a.usename, a.datname, a.client_addr;