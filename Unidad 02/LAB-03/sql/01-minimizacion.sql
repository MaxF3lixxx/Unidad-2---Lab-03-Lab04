-- LAB-03 | Actividad 2: minimización para atención al cliente
-- Requiere public.clientes creada previamente.

BEGIN;

CREATE TABLE IF NOT EXISTS public.clientes_soporte (
    id BIGINT PRIMARY KEY REFERENCES public.clientes(id),
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

INSERT INTO public.clientes_soporte (id, nombre, correo, telefono)
SELECT id, nombre, correo, telefono
FROM public.clientes
ON CONFLICT (id) DO UPDATE
SET nombre = EXCLUDED.nombre,
    correo = EXCLUDED.correo,
    telefono = EXCLUDED.telefono;

-- Verificación: solo aparecen los datos necesarios para soporte.
SELECT id, nombre, correo, telefono
FROM public.clientes_soporte
ORDER BY id;

COMMIT;
