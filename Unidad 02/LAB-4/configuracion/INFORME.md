# Informe — LAB-04 Hardening de PostgreSQL

## Alcance
Este análisis responde al caso integral de la guía. Describe el escenario planteado; los valores reales de mi servidor y las capturas se agregan después de ejecutar las consultas del laboratorio.

## 1. ¿Cuál era la principal superficie de ataque?
Según el escenario, la base acepta conexiones desde cualquier dirección IPv4, escucha en todas las interfaces y tiene el puerto 5432 permitido desde cualquier origen. También hay reglas HBA amplias y una aplicación que se conecta con una cuenta administrativa.

## 2. ¿Qué configuración representaba el mayor riesgo?
La combinación de firewall abierto a cualquier origen, escucha en todas las interfaces y una regla `0.0.0.0/0` deja el servicio accesible desde una red demasiado amplia. El uso de una cuenta administrativa por la aplicación aumenta el posible impacto si sus credenciales se comprometen.

## 3. ¿Qué cambio produciría la mayor reducción de exposición?
Restringir el acceso de red a los orígenes que realmente necesitan conectarse y limitar `listen_addresses` a la interfaz necesaria. También se debe reducir el alcance de las reglas HBA. Estos cambios deben planearse con los datos reales de la red para no interrumpir la aplicación.

## 4. ¿Qué diferencia existe entre firewall y `pg_hba.conf`?
El firewall filtra comunicaciones de red hacia el servidor, por ejemplo por origen y puerto. `pg_hba.conf` decide qué combinación de base, usuario, origen y método de autenticación puede intentar conectarse en PostgreSQL. Se complementan; uno no reemplaza al otro.

## 5. ¿Qué diferencia existe entre autenticación y autorización?
La autenticación comprueba quién se conecta. La autorización determina qué acciones puede hacer después, como consultar o modificar tablas.

## 6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?
Una aplicación normalmente solo necesita operaciones específicas. Si la aplicación o sus credenciales se comprometen, una cuenta `SUPERUSER` daría capacidades administrativas sobre toda la instancia.

## 7. ¿Por qué cambiar el puerto no es suficiente?
Cambiar el número del puerto no controla quién puede conectarse ni qué permisos tiene. El servicio todavía podría quedar expuesto si escucha en interfaces amplias y la red o HBA permiten conexiones innecesarias.

## 8. ¿Por qué `listen_addresses='*'` puede ser innecesario?
Ese valor hace que PostgreSQL escuche en todas las interfaces disponibles. Si la aplicación solo se conecta por una interfaz local o privada, las demás interfaces aumentan la exposición sin aportar una necesidad clara.

## 9. ¿Qué papel tiene el sistema operativo?
El sistema operativo protege los archivos de configuración, certificados y el directorio de datos mediante propietarios y permisos. Los permisos SQL no impiden que alguien con acceso al sistema operativo lea archivos directamente.

## 10. ¿Qué controles deberían revisarse periódicamente?
Revisaría reglas HBA, interfaces y firewall, roles y privilegios, cuentas de aplicación, extensiones, TLS, permisos de archivos, conexiones, registros y actualizaciones. También documentaría quién hizo cada revisión y qué hallazgos se corrigieron.

## Conclusión
Las contraseñas fuertes son solo una parte de la seguridad. El escenario requiere limitar la red, usar reglas de conexión específicas, separar cuentas, reducir privilegios y proteger la configuración y los archivos del sistema. La verificación debe hacerse después de cualquier cambio en un entorno académico autorizado.