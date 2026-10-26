
# Cambios propuestos — LAB-04

## Estado actual

La instancia revisada es PostgreSQL 16.4, en Windows, puerto 4020. La tabla siguiente compara los valores observados con una propuesta para el laboratorio. La columna “Después propuesto” es el estado al que se buscaría llegar; **no significa que el cambio ya esté aplicado**.

## Comparación antes y después propuesto

| Parámetro o control | Antes (observado) | Después propuesto | Justificación | Estado |
|---|---|---|---|---|
| `listen_addresses` | `*` | `localhost` | La conexión observada era local y las reglas HBA permiten hosts solo desde `127.0.0.1` y `::1`. Así PostgreSQL no escucha en las demás interfaces. | Propuesto; la verificación todavía mostró `*` |
| Puerto | `4020` | Mantener `4020` | Cambiar el número del puerto no reemplaza los controles de acceso. El puerto ya está documentado. | Sin cambio propuesto |
| Reglas de `pg_hba.conf` | Seis reglas locales/loopback y de replicación; SCRAM; sin errores ni redes host remotas | Mantener las reglas si la base se usa solo en este equipo. Si se necesita acceso desde otra máquina, agregar únicamente la base, el usuario y la red requeridos. | Las reglas actuales ya limitan el acceso de host al equipo local. | Mantener; no se modificó |
| Autenticación | `password_encryption=scram-sha-256`; reglas HBA con SCRAM | Mantener SCRAM y verificar compatibilidad de clientes | Ya se observa un método actual en la configuración consultada. | Sin cambio propuesto |
| Cuenta administrativa | El rol `postgres` tiene `LOGIN`, `SUPERUSER`, `CREATEROLE` y `CREATEDB` | Reservar `postgres` para administración y usar una cuenta de aplicación separada, sin esos privilegios | La aplicación no debería conectarse como superusuario. | Propuesto; no se creó un rol |
| TLS | `ssl=off`; la conexión local mostró `ssl=false`; mínimo configurado `TLSv1.2` | Si se habilitan conexiones remotas, configurar certificados, `ssl=on` y reglas `hostssl`. Para uso solo local, evaluar primero si se requiere TLS. | TLS protege conexiones que viajan por la red. | Propuesto para evaluar; no aplicado |
| Límite de conexiones | `max_connections=100`; `superuser_reserved_connections=3` | Mantener por ahora y revisar según la carga real | No hay información de carga para justificar otro límite. | Sin cambio propuesto |
| Timeouts | `statement_timeout=0`; `idle_in_transaction_session_timeout=0` | Para esta práctica se propone evaluar `statement_timeout=60s` e `idle_in_transaction_session_timeout=5min`; ajustar si la aplicación necesita operaciones más largas | Un límite puede evitar consultas o transacciones inactivas por tiempo indefinido. | Propuesta académica; no aplicada |
| Registro de conexiones | `log_connections=off`; `log_disconnections=off` | Evaluar activarlos en el laboratorio y revisar dónde se guardan y cuánto tiempo se conservan los logs | Ayudaría a revisar conexiones, siempre que los registros puedan administrarse. | Propuesto; no aplicado |
| Firewall | No revisado; puerto PostgreSQL observado `4020` | Permitir únicamente el origen que realmente requiera acceso; si el servicio queda en `localhost`, no permitir conexiones entrantes desde otras máquinas | El firewall limita quién puede alcanzar el servicio por red. | No revisado ni cambiado |
| Permisos de archivos | No revisados; configuración y datos están bajo `C:/Program Files/PostgreSQL/16/data/` | Dar acceso solo a la cuenta del servicio PostgreSQL y a administradores autorizados | Evitar lectura o modificación de configuración y datos por otras cuentas locales. | No revisado ni cambiado |
| Actualizaciones | No se consultó una política | Registrar quién revisa y aplica actualizaciones aprobadas de PostgreSQL 16 | Mantener un proceso de mantenimiento claro. | No revisado |

## Cambios aplicados

No se confirma ningún cambio aplicado en el servidor. La consulta posterior a la edición todavía mostró `listen_addresses = '*'` en `postgresql.conf`, línea 60. Por eso, `localhost` queda como valor objetivo propuesto y no como valor actual.

| Dato de cambio | Registro |
|---|---|
| Fecha y hora | No aplica: no se confirmó un cambio aplicado |
| Responsable |  Max Felix |
| Cambio aplicado | Ninguno confirmado |
| Valor anterior | `listen_addresses = '*'` |
| Valor nuevo | Sin cambio confirmado |
| Reinicio o recarga | No aplica |
| Resultado de verificación | La consulta mostró `setting = '*'` y `pending_restart = false` |
| Evidencia asociada | Captura de `pg_settings` y capturas de inspección en `evidencias/` |
| Plan de reversión | No aplica |
