-- Consulta de lectura: no crean ni modifican usuarios.

SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- Membresías entre roles.
SELECT
    parent.rolname AS rol_otorgado,
    member.rolname AS miembro
FROM pg_auth_members AS m
JOIN pg_roles AS parent ON parent.oid = m.roleid
JOIN pg_roles AS member ON member.oid = m.member
ORDER BY parent.rolname, member.rolname;

-- Extensiones instaladas.
SELECT extname, extversion
FROM pg_extension
ORDER BY extname;

-- No se muestran hashes ni credenciales.
