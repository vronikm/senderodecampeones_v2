-- 000_previo_sendero.sql
-- Paso previo de Sendero de Campeones, equivalente al 000_previo_champions.
--
-- Sendero NO necesita crear las nueve tablas que el 000 de Champions crea
-- (consentimientos, carnet_configuracion y facturacion electronica): ya las
-- tiene, con datos propios y con la misma forma (comprobado columna a columna
-- el 2026-11-04). Las unicas diferencias son columnas que Sendero agrego en
-- su v1 y que se conservan:
--   facturas_electronicas         factura_origen_id, reemplazada_por_id,
--                                 reemplazo_motivo, reemplazo_confirmado_at,
--                                 reemplazo_confirmado_by (reemplazo por
--                                 SECUENCIAL REGISTRADO; DigiSports no las usa,
--                                 son NULL por defecto)
--   facturas_electronicas_config  servicio_activo, mantenimiento_mensaje,
--                                 ruc_proveedor, etiqueta_ruc_proveedor (la
--                                 071 las da por existentes y no las repite)
-- carnet_configuracion ya trae las dos claves que el 000 de Champions inserta.
--
-- Queda solo lo que la migracion 008 (claves foraneas) necesita: el
-- representante 0 "sin vinculo" pasa a NULL. En Sendero no hay ningun alumno
-- con representante 0 (comprobado), pero la columna debe admitir NULL.
--
-- Idempotente.
SET NAMES utf8mb4;
ALTER TABLE sujeto_alumno MODIFY alumno_repreid INT NULL;
UPDATE sujeto_alumno SET alumno_repreid = NULL WHERE alumno_repreid = 0;
