-- Consulta de lectura: no modifican archivos del servidor.

SELECT
    type,
    database,
    user_name,
    address,
    netmask,
    auth_method,
    error
FROM pg_hba_file_rules
ORDER BY line_number;

SHOW listen_addresses;
SHOW port;
SHOW password_encryption;
SHOW ssl;
SHOW ssl_min_protocol_version;

SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;

-- Estado TLS de las conexiones visibles para el usuario actual.
SELECT
    s.pid,
    a.usename,
    a.client_addr,
    s.ssl,
    s.version,
    s.cipher
FROM pg_stat_ssl AS s
JOIN pg_stat_activity AS a USING (pid)
ORDER BY a.usename, a.client_addr;

-- Reglas HBA con errores, para identificarlas y revisarlas.
SELECT line_number, type, database, user_name, address, auth_method, error
FROM pg_hba_file_rules
WHERE error IS NOT NULL
ORDER BY line_number;
