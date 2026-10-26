DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'analista') THEN
        CREATE ROLE analista NOLOGIN;
    END IF;
END
$$;

GRANT USAGE ON SCHEMA public TO analista;
GRANT SELECT ON public.v_analitica_clientes TO analista;

-- Asegura que el rol no consulte directamente las tablas operativas.
REVOKE ALL ON public.clientes FROM analista;
REVOKE ALL ON public.clientes_soporte FROM analista;

-- Verificación de privilegios concedidos.
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista'
ORDER BY table_name, privilege_type;

-- La consulta autorizada para analítica:
SELECT * FROM public.v_analitica_clientes
ORDER BY ciudad, rango_edad, region_cp;
