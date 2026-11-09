-- 065_ajustes_sendero.sql
-- Equivalente del 065_ajustes_champions para Sendero de Campeones.
--
-- Igual que el de Champions salvo en tres puntos:
--   1. NO quita Facturacion al Administrador. Champions no facturaba; Sendero
--      si: tiene configuracion del SRI, firma y facturas autorizadas.
--   2. El logo es el de Sendero (organizacion_sendero.png en la carpeta de
--      marca de Core), no el de Champions.
--   3. Sendero ya tenia los menus 43 (Consentimientos LOPDP) y 44
--      (Inscripciones pendientes) con los mismos ids y vistas, pero en la raiz
--      del menu. El INSERT IGNORE los respeta; aqui se cuelgan del grupo 927
--      "Inscripcion Online", como en DigiSports.
--
-- Idempotente: INSERT IGNORE y UPDATE condicionados.
SET NAMES utf8mb4;

-- Categorias de texto libre ("Sub 15", "2013-2014"), como en DigiSports.
ALTER TABLE torneo_equipo MODIFY equipo_categoria VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

-- Facturacion antigua de SoccerEasy: Sendero ya no la tenia; por si acaso.
DROP TABLE IF EXISTS facturacion_factura_pago;
DROP TABLE IF EXISTS facturacion_factura;

INSERT IGNORE INTO seguridad_menu
       (menu_id, menu_modulo, menu_nombre, menu_orden, menu_padreid, menu_hijo, menu_vista, menu_icono, menu_estado)
VALUES (43,  'basketball', 'Consentimientos LOPDP',    3,   927,  'N', 'consentimientoList',    'nav-icon fas fa-user-shield text-warning', 'A'),
       (44,  'basketball', 'Inscripciones pendientes', 2,   927,  'N', 'inscripcionPendientes', 'nav-icon fas fa-user-clock text-warning',  'A'),
       (908, 'basketball', 'Carnets del mes',          18,  0,    'N', 'carnetList',            'nav-icon far fa-address-card',             'A'),
       (969, 'league',     'Plantilla',                70,  NULL, 'N', 'plantillaPanel',        'fas fa-id-card',                           'O'),
       (970, 'league',     'Sorteo',                   80,  NULL, 'N', 'sorteoPanel',           'fas fa-random',                            'O'),
       (971, 'league',     'Eliminatorias',            90,  NULL, 'N', 'playoffPanel',          'fas fa-sitemap',                           'O'),
       (972, 'league',     'Acta del partido',         100, NULL, 'N', 'actaPartido',           'fas fa-clipboard-list',                    'O'),
       (973, 'league',     'Líderes',                  110, NULL, 'N', 'rankingPanel',          'fas fa-medal',                             'O');

-- Los menus 43 y 44 que ya traia Sendero: al grupo "Inscripcion Online" y
-- con el modulo, orden e icono de DigiSports.
UPDATE seguridad_menu m
   JOIN seguridad_menu g ON g.menu_id = 927 AND g.menu_hijo = 'S'
   SET m.menu_padreid = 927,
       m.menu_modulo  = 'basketball',
       m.menu_orden   = IF(m.menu_id = 43, 3, 2),
       m.menu_icono   = IF(m.menu_id = 43, 'nav-icon fas fa-user-shield text-warning', 'nav-icon fas fa-user-clock text-warning')
 WHERE m.menu_id IN (43, 44) AND IFNULL(m.menu_padreid, 0) = 0;

-- Sus permisos, por NOMBRE de rol. Sendero si tiene "Asistente" (rol 6).
INSERT IGNORE INTO seguridad_permiso
       (permiso_rolid, permiso_menuid, permiso_ver, permiso_crear, permiso_editar,
        permiso_eliminar, permiso_exportar, permiso_estado)
SELECT r.rol_id, v.menuid, v.ver, v.crear, v.editar, v.eliminar, v.exportar, v.estado
  FROM (          SELECT 'Administrador'       rol, 43  menuid, 'S' ver, 'S' crear, 'S' editar, 'S' eliminar, 'N' exportar, 'A' estado
        UNION ALL SELECT 'Asistente',               43,  'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Gerente',                 43,  'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Administrador',           44,  'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Administrador',           908, 'S', 'S', 'S', 'N', 'N', 'A'
        UNION ALL SELECT 'Asistente',               908, 'S', 'S', 'S', 'N', 'N', 'A'
        UNION ALL SELECT 'Super Administrador',     969, 'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Super Administrador',     970, 'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Super Administrador',     971, 'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Árbitro',                 972, 'S', 'N', 'S', 'N', 'N', 'A'
        UNION ALL SELECT 'Oficial de mesa',         972, 'S', 'N', 'S', 'N', 'N', 'A'
        UNION ALL SELECT 'Super Administrador',     972, 'S', 'S', 'S', 'S', 'N', 'A'
        UNION ALL SELECT 'Super Administrador',     973, 'S', 'S', 'S', 'S', 'N', 'A') v
  JOIN seguridad_rol r ON r.rol_nombre = v.rol;

-- Logo de Sendero en la carpeta de marca de Core (ds_core/assets/img/marca/).
UPDATE general_escuela SET escuela_logo = 'organizacion_sendero.png' WHERE escuela_id = 1;
