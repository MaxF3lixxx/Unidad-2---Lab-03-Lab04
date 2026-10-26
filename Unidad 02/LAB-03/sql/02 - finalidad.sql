
-- Estadísticas por ciudad.
SELECT ciudad, COUNT(*) AS cantidad_clientes
FROM public.clientes
GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

-- Rangos de edad y región postal aproximada; sin identificadores directos.
SELECT
    ciudad,
    CASE
        WHEN edad IS NULL THEN 'No especificada'
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad,
    LEFT(codigo_postal, 3) AS region_cp,
    COUNT(*) AS cantidad
FROM public.clientes
GROUP BY
    ciudad,
    CASE
        WHEN edad IS NULL THEN 'No especificada'
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END,
    LEFT(codigo_postal, 3)
ORDER BY ciudad, rango_edad, region_cp;

-- Vista agregada que se podrá conceder al rol de analítica.
CREATE OR REPLACE VIEW public.v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad IS NULL THEN 'No especificada'
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad,
    LEFT(codigo_postal, 3) AS region_cp,
    COUNT(*) AS cantidad_clientes
FROM public.clientes
GROUP BY
    ciudad,
    CASE
        WHEN edad IS NULL THEN 'No especificada'
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END,
    LEFT(codigo_postal, 3);
