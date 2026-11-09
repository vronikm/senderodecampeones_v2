-- 082_ver_asistencias_sendero.sql
-- Menu «Ver asistencias» (vista asistenciaList: grilla mensual por alumno),
-- que Sendero de Campeones tenia en v1 y DigiSports no traia.
--
-- Va en el mismo grupo que «Ver registro» (reporteAsistencia), justo despues.
-- Registrarla como menu NO es opcional: en Futbol una vista que no figura en
-- seguridad_menu no se restringe (ds_core/inc/seguridad.php), y esta muestra
-- la asistencia de menores.
--
-- Permiso: el Administrador (como «Ver registro») y con EXPORTAR, que en v1
-- tenia (Excel e imprimir). El Super Administrador la ve sin fila de permiso.
-- Otros roles se habilitan en Core › Permisos.
--
-- Idempotente: no repite el menu ni el permiso.
SET NAMES utf8mb4;

INSERT INTO seguridad_menu
       (menu_modulo, menu_nombre, menu_orden, menu_padreid, menu_hijo, menu_vista, menu_icono, menu_estado)
SELECT 'basketball', 'Ver asistencias', r.menu_orden + 1, r.menu_padreid, 'N', 'asistenciaList',
       'nav-icon far fa-circle text-info', 'A'
  FROM seguridad_menu r
 WHERE r.menu_vista = 'reporteAsistencia'
   AND NOT EXISTS (SELECT 1 FROM seguridad_menu x WHERE x.menu_vista = 'asistenciaList')
 ORDER BY r.menu_id
 LIMIT 1;

INSERT INTO seguridad_permiso
       (permiso_rolid, permiso_menuid, permiso_ver, permiso_crear, permiso_editar,
        permiso_eliminar, permiso_exportar, permiso_estado)
SELECT r.rol_id, m.menu_id, 'S', 'N', 'N', 'N', 'S', 'A'
  FROM seguridad_rol r
  JOIN seguridad_menu m ON m.menu_vista = 'asistenciaList'
 WHERE r.rol_nombre = 'Administrador'
   AND NOT EXISTS (SELECT 1 FROM seguridad_permiso p
                    WHERE p.permiso_rolid = r.rol_id AND p.permiso_menuid = m.menu_id);
