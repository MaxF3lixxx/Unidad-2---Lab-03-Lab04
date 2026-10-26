# LAB-04 — Hardening y configuración segura de PostgreSQL

Este repositorio presenta la revisión de seguridad que hice sobre una instancia local de PostgreSQL 16.4. El trabajo se enfocó en las interfaces de escucha, las reglas de acceso, los roles, la autenticación y TLS.

## Objetivo

Identificar la configuración que puede ampliar la superficie de ataque y proponer medidas para permitir solo las conexiones y los permisos necesarios.

## Entorno

- PostgreSQL 16.4
- Windows 64-bit
- Base de práctica: `LABORATORIO 04`
- Puerto observado: `4020`
- Revisión realizada con pgAdmin 4

## Superficie de ataque inicial

| Elemento | Resultado observado |
|---|---|
| Puerto | `4020` |
| Interfaces de escucha | `*` |
| Reglas de host en `pg_hba.conf` | Limitadas a `127.0.0.1` y `::1` |
| Método de autenticación | `scram-sha-256` |
| SSL del servidor | Desactivado |
| Rol con privilegios administrativos | `postgres` |

## Hallazgos

Las reglas HBA permiten conexiones de host desde la misma computadora y no muestran redes remotas. Sin embargo, PostgreSQL escucha en todas las interfaces. La sesión de pgAdmin que revisé era local y no usaba TLS.

El rol `postgres` puede iniciar sesión y tiene permisos de superusuario, crear roles y crear bases de datos. No identifiqué una cuenta separada para la aplicación. También observé que `log_connections` y `log_disconnections` están desactivados, y que los dos timeouts revisados están en cero.

No revisé los permisos de Windows, las reglas del firewall ni la política de actualizaciones.

## Cambios realizados

No quedó confirmado ningún cambio en el servidor. Se propuso limitar `listen_addresses` a `localhost`, pero la última verificación todavía mostró `*` en `postgresql.conf`, línea 60. La propuesta y los demás cambios posibles están registrados en `configuracion/cambios.md`.

## Justificación de los cambios

Limitar las interfaces de escucha reduciría la exposición si la base solo se usa desde esta computadora. También conviene mantener las reglas HBA específicas, separar la cuenta de la aplicación de `postgres` y definir si TLS y los registros de conexión son necesarios para el uso de esta instancia.

## Verificación

Revisé los valores con consultas de lectura en PostgreSQL y comparé las reglas HBA, los roles, las extensiones, las conexiones y TLS. Las capturas están en la carpeta `evidencias`. Como no quedó aplicado un cambio, no hay valores posteriores de hardening que comparar.

## Checklist de hardening

- [x] Puerto e interfaces de escucha identificados.
- [x] Reglas de `pg_hba.conf` revisadas.
- [x] Métodos de autenticación identificados.
- [x] Rol administrativo identificado.
- [x] Extensiones instaladas revisadas.
- [x] TLS del servidor y de la sesión revisado.
- [x] Rutas de configuración identificadas.
- [x] Conexiones y timeouts revisados.
- [ ] Interfaces restringidas a las necesarias.
- [ ] Cuenta de aplicación separada y con privilegios mínimos.
- [ ] Permisos de archivos revisados en Windows.
- [ ] Firewall revisado y documentado.
- [ ] Política de actualizaciones documentada.
- [ ] Cambios de configuración aplicados y verificados.

## Conclusiones

La instancia usa SCRAM y sus reglas HBA de host están limitadas a conexiones locales, pero el servidor todavía escucha en todas las interfaces y SSL está desactivado. La revisión permitió identificar estos puntos y dejar propuestas concretas. Para completar el hardening, falta aplicar y verificar los cambios autorizados, además de revisar Windows, el firewall y las actualizaciones.
