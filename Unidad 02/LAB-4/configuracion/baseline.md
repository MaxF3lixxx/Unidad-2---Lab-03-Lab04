# Línea base de seguridad — PostgreSQL 16

## Estado inicial observado

Valores de las capturas de pgAdmin de PostgreSQL 16.4. Las rutas de configuración se confirmaron con la consulta de parámetros.

| Control | Valor observado | Valor esperado o criterio | Estado |
|---|---|---|---|
| Versión | PostgreSQL 16.4, compilado por Visual C++ build 1940, 64-bit | PostgreSQL 16 para esta práctica | Revisado |
| Puerto | 4020 | Documentado; accesible solo desde orígenes necesarios | Puerto confirmado; acceso de red no verificado |
| `listen_addresses` | `*` | Interfaz local o privada requerida por la aplicación | Escucha en todas las interfaces; revisar cuáles necesita |
| Reglas de `pg_hba.conf` | 6 reglas, líneas 113, 115, 117, 120, 121 y 122. Host limitado a `127.0.0.1` y `::1`; también hay reglas locales y de replicación. Todas usan `scram-sha-256`; sin errores. | Base, usuario, origen y método específicos | Revisado; no se ven reglas host para redes remotas |
| Ruta de `pg_hba.conf` | `C:/Program Files/PostgreSQL/16/data/pg_hba.conf` | Registrar y proteger la ruta | Revisado |
| Autenticación | `scram-sha-256` (`password_encryption`) | SCRAM cuando los clientes lo soporten | Revisado |
| Roles con privilegios o LOGIN | La consulta devolvió solo `postgres`: `rolsuper=true`, `rolcreaterole=true`, `rolcreatedb=true`, `rolcanlogin=true` | Privilegios administrativos solo para cuentas justificadas | Revisado; `postgres` es superusuario |
| Cuenta de aplicación | No se identificó una cuenta separada en la consulta de roles con LOGIN o privilegios; no se revisó la configuración de la aplicación | Cuenta separada y con privilegios mínimos | No identificada en esta revisión |
| Membresías de roles | `pg_monitor` aparece como miembro de `pg_read_all_settings`, `pg_read_all_stats` y `pg_stat_scan_tables` | Membresías justificadas según la función de cada rol | Revisado según la captura |
| Extensiones | `plpgsql` versión `1.0` | Solo las necesarias para el propósito de la instancia | Revisado |
| SSL del servidor | `ssl=off`; `ssl_min_protocol_version=TLSv1.2` | Evaluar TLS según las conexiones del entorno | SSL aparece desactivado |
| TLS de la conexión actual | `ssl=false`, `client_addr=::1` (conexión local); versión y cipher aparecen nulos | Confirmar si la conexión debe usar TLS | Revisado: esta sesión no usa TLS |
| Conexiones y timeouts | `max_connections=100`, `superuser_reserved_connections=3`, `statement_timeout=0`, `idle_in_transaction_session_timeout=0` | Revisar si los límites y tiempos de espera corresponden al uso del entorno | Revisado; los dos timeouts están desactivados |
| Conexiones activas observadas | 5 sesiones de pgAdmin con usuario `postgres` desde `::1`; 5 procesos internos con valores de conexión nulos. No se ven conexiones remotas en esta captura. | Revisar nuevamente si cambia la exposición o el uso | Observado en la consulta de verificación |
| Archivo de configuración | `C:/Program Files/PostgreSQL/16/data/postgresql.conf` | Registrar y proteger la ruta | Revisado |
| Archivo de identificación | `C:/Program Files/PostgreSQL/16/data/pg_ident.conf` | Registrar y proteger la ruta | Revisado |
| Directorio de datos | `C:/Program Files/PostgreSQL/16/data` | Accesible solo a cuentas autorizadas del sistema operativo | Ruta confirmada; permisos no revisados |
| Directorio de logs | `log` (relativo al directorio de datos) | Ubicación y política documentadas | Revisado |
| Registro de conexiones | `off` | Revisar si el nivel de registro satisface las necesidades de monitoreo | Valor observado; monitoreo por evaluar |
| Registro de desconexiones | `off` | Revisar si el nivel de registro satisface las necesidades de monitoreo | Valor observado; monitoreo por evaluar |
| Permisos del sistema operativo | No se inspeccionaron las ACL de Windows para los archivos ni el directorio de datos | Archivos y directorio protegidos | No revisado en esta práctica |
| Firewall | No se consultaron las reglas de entrada de Windows Firewall | Permitir solo orígenes necesarios al puerto del servicio | No revisado en esta práctica |
| Actualizaciones | No se consultó una política de actualización del servidor | Política y responsable documentados | No revisado en esta práctica |

## Criterios propuestos

- **Red:** elegir las interfaces necesarias; documentar el puerto y restringir los orígenes mediante controles de red y reglas HBA.
- **Autenticación:** preferir SCRAM si es compatible con las aplicaciones y clientes.
- **Autorización:** evitar que una cuenta de aplicación tenga `SUPERUSER`, `CREATEROLE` o `CREATEDB` salvo que exista una necesidad excepcional aprobada.
- **Configuración:** documentar valores relevantes y revisar extensiones, conexiones y registros.
- **Sistema operativo:** verificar propietario y permisos de los archivos de configuración y del directorio de datos desde el servidor.
- **TLS:** revisar la configuración del servidor y confirmar si la conexión del cliente realmente usa TLS.
- **Mantenimiento:** establecer quién revisa y aplica actualizaciones, y registrar fecha, versión y resultado.