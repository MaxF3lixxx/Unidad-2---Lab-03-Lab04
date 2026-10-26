LAB-03 — Privacidad, cumplimiento y gobierno de los datos

Este trabajo revisa cómo Comercializadora Norte puede manejar los datos de sus clientes de acuerdo con la finalidad de cada área. El enfoque está en guardar solo lo necesario y evitar que toda la información quede disponible para cualquier usuario.

## Objetivo

Identificar los datos personales del escenario y proponer controles de minimización, acceso, retención y atención de solicitudes de los titulares.

## Entorno

- PostgreSQL 16
- Escenario académico de administración de clientes
- Áreas consideradas: atención al cliente, facturación, analítica y DBA

## Datos y finalidades del escenario

Atención al cliente necesita datos básicos de contacto. Facturación puede requerir información fiscal. Analítica puede trabajar con estadísticas agrupadas y no necesita identificar a cada cliente.

## Hallazgos

El análisis muestra que algunos campos, como el RFC, la edad exacta y el código postal completo, no son necesarios para todas las áreas. También se revisaron los riesgos de usar datos para promociones sin evaluar antes esa finalidad, conservarlos indefinidamente o mantener copias en respaldos, exportaciones y sistemas de prueba.

## Propuesta de privacidad y acceso

La estructura de soporte contiene solo identificador, nombre, correo y teléfono. Para analítica se propone una vista con ciudad, rangos de edad, región postal aproximada y conteos. El rol analista recibe acceso a esa vista y no a la tabla operativa completa.

También se propone documentar los plazos de retención, asignar responsables por categoría de datos y revisar las copias relacionadas antes de atender una cancelación. Las decisiones sobre finalidad y cumplimiento deben tomarse con las áreas responsables.

## Contenido del laboratorio

- `sql/01-minimizacion.sql`: estructura mínima de soporte.
- `sql/02-finalidad.sql`: consultas agrupadas y vista de analítica.
- `sql/03-control-acceso.sql`: permisos limitados para el rol analista.
- `evidencias/`: análisis de finalidades, retención, ciclo de vida, gobierno y arquitectura.

## Verificación

Los scripts contienen las consultas para mostrar la tabla de soporte, los datos agregados y los permisos del rol analista. Las evidencias de ejecución se agregan con capturas reales de PostgreSQL.

## Conclusiones

La información debe estar relacionada con una finalidad y disponible solo para quienes la necesitan. La minimización y la separación de accesos reducen la exposición de datos personales. El DBA implementa controles técnicos, mientras que las áreas responsables definen los usos, plazos y decisiones de cumplimiento.
