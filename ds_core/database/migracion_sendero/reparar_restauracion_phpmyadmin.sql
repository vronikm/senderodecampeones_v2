-- =====================================================================
-- Reparación de la base de Sendero restaurada desde el Exportar de phpMyAdmin
-- =====================================================================
-- QUE PROBLEMA RESUELVE
--
-- El Exportar de phpMyAdmin 5.2.3 omite el CHECK y el ENGINE=InnoDB de las
-- tablas que tienen restricciones CHECK (Arena y League), y la restauración
-- se corta en la primera clave foránea hacia una de ellas (#1824). La base
-- queda con los datos completos pero:
--   · esas tablas en MyISAM (sin transacciones ni claves foráneas),
--   · sin la mayoría de las claves foráneas de TODO el sistema,
--   · sin las restricciones CHECK.
-- Encontrado el 2026-11-27 en la copia LOCAL de producción (importada en
-- WAMP, motor por defecto MyISAM; producción estaba sana): 17 tablas
-- MyISAM, 11 de 95 claves foráneas y 0 de 22 CHECK.
--
-- QUE HACE
--
--   1. Pasa a InnoDB las tablas que deben serlo.
--   2. Crea cada clave foránea que falte.
--   3. Crea cada restricción CHECK que falte.
-- Definiciones tomadas de una base migrada desde cero con la cadena
-- completa (aplicar_migracion.sh, 96 archivos). Generado el 2026-11-27.
--
-- SE PUEDE REPETIR: cada paso comprueba antes; lo que ya está no se toca.
-- Si una clave falla por datos huérfanos, se detiene ahí sin perder lo
-- hecho: corregir el dato y volver a ejecutar.
--
-- PHPMYADMIN: abrir primero la base de la escuela. Como en la 094, la base
-- se guarda en @db antes de mirar information_schema, y se compara en
-- BINARY: las columnas de esquema de information_schema no tienen el mismo
-- cotejamiento en todas las vistas (#1267 Illegal mix of collations).
-- =====================================================================
SET NAMES utf8mb4;
SET @db := DATABASE();
SET @sql := IF(@db IS NULL OR @db = 'information_schema',
    'SELECT * FROM `DETENIDO_abra_primero_la_base_de_la_escuela`',
    IF((SELECT COUNT(*) FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'cumple_plantilla') = 0,
       'SELECT * FROM `DETENIDO_no_es_una_base_DigiSports_migrada`', 'DO 0'));
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

/* ---------- 1. Motor InnoDB ---------- */

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_carnet') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_carnet` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_cemergencia') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_cemergencia` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_consentimiento') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_consentimiento` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_documentos') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_documentos` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_infomedic') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_infomedic` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_pago') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_pago` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_pago_descuento') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_pago_descuento` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_pago_transaccion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_pago_transaccion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_representante') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_representante` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_representanteconyuge') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`alumno_representanteconyuge` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_asignahorario') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_asignahorario` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_asistencia') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_asistencia` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_hora') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_hora` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_horario') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_horario` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_horario_detalle') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_horario_detalle` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_lugar') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_lugar` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'balance_egreso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`balance_egreso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'balance_ingreso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`balance_ingreso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'carnet_catcolor') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`carnet_catcolor` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'carnet_configuracion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`carnet_configuracion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'carnet_mes_color') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`carnet_mes_color` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'consentimiento_enlace') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`consentimiento_enlace` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'consentimiento_texto') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`consentimiento_texto` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'cumple_plantilla') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`cumple_plantilla` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_bloqueo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_bloqueo_grupo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo_grupo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_cliente') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_cliente` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_devolucion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_devolucion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_forma_ingreso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_forma_ingreso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_horario') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_horario` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_instalacion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_instalacion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_monedero') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_monedero_movimiento') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero_movimiento` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_pago') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_pago` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva_fija') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva_fija` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_tarifa') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_tarifa` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_tipo_piso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsa_tipo_piso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_abono') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_abono` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_auditoria') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_auditoria` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_categoria') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_categoria` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_concepto') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_concepto` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_designacion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_designacion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_equipo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_equipo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_estadistica_tipo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_estadistica_tipo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_estado') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_estado` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_estado_transicion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_estado_transicion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_factura') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_factura` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_factura_detalle') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_factura_detalle` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_factura_pago') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_factura_pago` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_fase') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_fase` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_grupo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_grupo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_grupo_equipo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_grupo_equipo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_inscripcion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_inscripcion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_jornada') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_jornada` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_obligacion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido_stat') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido_stat` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_persona') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_persona` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_plantilla') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_plantilla` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_serie') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_serie` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_bombo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_bombo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_restriccion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_restriccion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_resultado') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_resultado` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_temporada') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_temporada` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_torneo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`dsl_torneo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'empleado_asistencia') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`empleado_asistencia` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'empleado_egreso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`empleado_egreso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'empleado_egreso_trx') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`empleado_egreso_trx` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'empleado_ingreso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`empleado_ingreso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'empleado_ingreso_trx') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`empleado_ingreso_trx` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_ambiente') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_ambiente` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_certificado') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_certificado` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_config') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_config` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_detalle') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_detalle` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_forma_pago') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_forma_pago` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_pagos') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_pagos` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_punto_emision') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_punto_emision` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_secuenciales') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_secuenciales` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_agenda') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`general_agenda` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_escuela') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`general_escuela` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_sede') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`general_sede` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_tabla') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`general_tabla` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_tabla_catalogo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`general_tabla_catalogo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'insights_auditoria') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`insights_auditoria` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'insights_cartera_snapshot') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`insights_cartera_snapshot` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'insights_favorito') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`insights_favorito` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'insights_umbral') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`insights_umbral` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'redes_config') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`redes_config` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'redes_publicacion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`redes_publicacion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_2fa_evento') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_2fa_evento` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_2fa_recuperacion') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_2fa_recuperacion` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_intento_acceso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_intento_acceso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_menu') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_menu` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_permiso') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_permiso` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_rol') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_rol` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_rol_modulo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_rol_modulo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_usuario') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_usuario` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_usuario_sede') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_usuario_sede` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'sujeto_alumno') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`sujeto_alumno` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'sujeto_empleado') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`sujeto_empleado` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'torneo_equipo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`torneo_equipo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'torneo_jugador') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`torneo_jugador` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF((SELECT ENGINE FROM information_schema.TABLES WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'torneo_torneo') = 'MyISAM',
    CONCAT('ALTER TABLE `', @db, '`.`torneo_torneo` ENGINE=InnoDB'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

/* ---------- 2. Claves foráneas ---------- */

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_cemergencia_alumno')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_cemergencia'
                     AND COLUMN_NAME IN ('cemer_alumnoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`alumno_cemergencia` ', 'ADD CONSTRAINT `fk_cemergencia_alumno` FOREIGN KEY (`cemer_alumnoid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_consentimiento_alumno')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_consentimiento'
                     AND COLUMN_NAME IN ('consent_alumnoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`alumno_consentimiento` ', 'ADD CONSTRAINT `fk_consentimiento_alumno` FOREIGN KEY (`consent_alumnoid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_infomedic_alumno')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_infomedic'
                     AND COLUMN_NAME IN ('infomedic_alumnoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`alumno_infomedic` ', 'ADD CONSTRAINT `fk_infomedic_alumno` FOREIGN KEY (`infomedic_alumnoid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_pago_alumno')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_pago'
                     AND COLUMN_NAME IN ('pago_alumnoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`alumno_pago` ', 'ADD CONSTRAINT `fk_pago_alumno` FOREIGN KEY (`pago_alumnoid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_pago_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'alumno_pago'
                     AND COLUMN_NAME IN ('pago_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`alumno_pago` ', 'ADD CONSTRAINT `fk_pago_sede` FOREIGN KEY (`pago_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE RESTRICT'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_asigna_alumno')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_asignahorario'
                     AND COLUMN_NAME IN ('asignahorario_alumnoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_asignahorario` ', 'ADD CONSTRAINT `fk_asigna_alumno` FOREIGN KEY (`asignahorario_alumnoid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_asigna_horario')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_asignahorario'
                     AND COLUMN_NAME IN ('asignahorario_horarioid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_asignahorario` ', 'ADD CONSTRAINT `fk_asigna_horario` FOREIGN KEY (`asignahorario_horarioid`) REFERENCES `asistencia_horario` (`horario_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_horario_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_horario'
                     AND COLUMN_NAME IN ('horario_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_horario` ', 'ADD CONSTRAINT `fk_horario_sede` FOREIGN KEY (`horario_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_detalle_horario')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'asistencia_horario_detalle'
                     AND COLUMN_NAME IN ('detalle_horarioid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`asistencia_horario_detalle` ', 'ADD CONSTRAINT `fk_detalle_horario` FOREIGN KEY (`detalle_horarioid`) REFERENCES `asistencia_horario` (`horario_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_bloqueo_grupo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_bloqueo'
                     AND COLUMN_NAME IN ('bloqueo_grupoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo` ', 'ADD CONSTRAINT `fk_bloqueo_grupo` FOREIGN KEY (`bloqueo_grupoid`) REFERENCES `dsa_bloqueo_grupo` (`grupo_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_bloqueo_instalacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_bloqueo'
                     AND COLUMN_NAME IN ('bloqueo_instalacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo` ', 'ADD CONSTRAINT `fk_bloqueo_instalacion` FOREIGN KEY (`bloqueo_instalacionid`) REFERENCES `dsa_instalacion` (`instalacion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_grupo_instalacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_bloqueo_grupo'
                     AND COLUMN_NAME IN ('grupo_instalacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo_grupo` ', 'ADD CONSTRAINT `fk_grupo_instalacion` FOREIGN KEY (`grupo_instalacionid`) REFERENCES `dsa_instalacion` (`instalacion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_devolucion_reserva')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_devolucion'
                     AND COLUMN_NAME IN ('devolucion_reservaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_devolucion` ', 'ADD CONSTRAINT `fk_devolucion_reserva` FOREIGN KEY (`devolucion_reservaid`) REFERENCES `dsa_reserva` (`reserva_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_horario_instalacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_horario'
                     AND COLUMN_NAME IN ('horario_instalacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_horario` ', 'ADD CONSTRAINT `fk_horario_instalacion` FOREIGN KEY (`horario_instalacionid`) REFERENCES `dsa_instalacion` (`instalacion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_instalacion_piso')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_instalacion'
                     AND COLUMN_NAME IN ('instalacion_pisoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_instalacion` ', 'ADD CONSTRAINT `fk_instalacion_piso` FOREIGN KEY (`instalacion_pisoid`) REFERENCES `dsa_tipo_piso` (`piso_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_instalacion_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_instalacion'
                     AND COLUMN_NAME IN ('instalacion_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_instalacion` ', 'ADD CONSTRAINT `fk_instalacion_sede` FOREIGN KEY (`instalacion_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_monedero_cliente')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_monedero'
                     AND COLUMN_NAME IN ('monedero_clienteid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero` ', 'ADD CONSTRAINT `fk_monedero_cliente` FOREIGN KEY (`monedero_clienteid`) REFERENCES `dsa_cliente` (`cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_movimiento_monedero')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_monedero_movimiento'
                     AND COLUMN_NAME IN ('movimiento_monederoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero_movimiento` ', 'ADD CONSTRAINT `fk_movimiento_monedero` FOREIGN KEY (`movimiento_monederoid`) REFERENCES `dsa_monedero` (`monedero_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_movimiento_pago')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_monedero_movimiento'
                     AND COLUMN_NAME IN ('movimiento_pagoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero_movimiento` ', 'ADD CONSTRAINT `fk_movimiento_pago` FOREIGN KEY (`movimiento_pagoid`) REFERENCES `dsa_pago` (`pago_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_movimiento_reserva')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_monedero_movimiento'
                     AND COLUMN_NAME IN ('movimiento_reservaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero_movimiento` ', 'ADD CONSTRAINT `fk_movimiento_reserva` FOREIGN KEY (`movimiento_reservaid`) REFERENCES `dsa_reserva` (`reserva_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_pago_forma')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_pago'
                     AND COLUMN_NAME IN ('pago_formaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_pago` ', 'ADD CONSTRAINT `fk_pago_forma` FOREIGN KEY (`pago_formaid`) REFERENCES `dsa_forma_ingreso` (`forma_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_pago_reserva')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_pago'
                     AND COLUMN_NAME IN ('pago_reservaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_pago` ', 'ADD CONSTRAINT `fk_pago_reserva` FOREIGN KEY (`pago_reservaid`) REFERENCES `dsa_reserva` (`reserva_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_reserva_cliente')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva'
                     AND COLUMN_NAME IN ('reserva_clienteid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva` ', 'ADD CONSTRAINT `fk_reserva_cliente` FOREIGN KEY (`reserva_clienteid`) REFERENCES `dsa_cliente` (`cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_reserva_fija')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva'
                     AND COLUMN_NAME IN ('reserva_fijaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva` ', 'ADD CONSTRAINT `fk_reserva_fija` FOREIGN KEY (`reserva_fijaid`) REFERENCES `dsa_reserva_fija` (`fija_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_reserva_instalacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva'
                     AND COLUMN_NAME IN ('reserva_instalacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva` ', 'ADD CONSTRAINT `fk_reserva_instalacion` FOREIGN KEY (`reserva_instalacionid`) REFERENCES `dsa_instalacion` (`instalacion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_reserva_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva'
                     AND COLUMN_NAME IN ('reserva_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva` ', 'ADD CONSTRAINT `fk_reserva_sede` FOREIGN KEY (`reserva_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_fija_cliente')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva_fija'
                     AND COLUMN_NAME IN ('fija_clienteid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva_fija` ', 'ADD CONSTRAINT `fk_fija_cliente` FOREIGN KEY (`fija_clienteid`) REFERENCES `dsa_cliente` (`cliente_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_fija_instalacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva_fija'
                     AND COLUMN_NAME IN ('fija_instalacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva_fija` ', 'ADD CONSTRAINT `fk_fija_instalacion` FOREIGN KEY (`fija_instalacionid`) REFERENCES `dsa_instalacion` (`instalacion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_fija_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_reserva_fija'
                     AND COLUMN_NAME IN ('fija_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva_fija` ', 'ADD CONSTRAINT `fk_fija_sede` FOREIGN KEY (`fija_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_tarifa_instalacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsa_tarifa'
                     AND COLUMN_NAME IN ('tarifa_instalacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsa_tarifa` ', 'ADD CONSTRAINT `fk_tarifa_instalacion` FOREIGN KEY (`tarifa_instalacionid`) REFERENCES `dsa_instalacion` (`instalacion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsla_obligacion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_abono'
                     AND COLUMN_NAME IN ('abono_obligacionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_abono` ', 'ADD CONSTRAINT `fk_dsla_obligacion` FOREIGN KEY (`abono_obligacionid`) REFERENCES `dsl_obligacion` (`obligacion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslc_torneo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_categoria'
                     AND COLUMN_NAME IN ('categoria_torneoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_categoria` ', 'ADD CONSTRAINT `fk_dslc_torneo` FOREIGN KEY (`categoria_torneoid`) REFERENCES `dsl_torneo` (`torneo_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsld_partido')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_designacion'
                     AND COLUMN_NAME IN ('designacion_partidoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_designacion` ', 'ADD CONSTRAINT `fk_dsld_partido` FOREIGN KEY (`designacion_partidoid`) REFERENCES `dsl_partido` (`partido_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsld_persona')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_designacion'
                     AND COLUMN_NAME IN ('designacion_personaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_designacion` ', 'ADD CONSTRAINT `fk_dsld_persona` FOREIGN KEY (`designacion_personaid`) REFERENCES `dsl_persona` (`persona_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsl_trans_desde')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_estado_transicion'
                     AND COLUMN_NAME IN ('trans_desde')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_estado_transicion` ', 'ADD CONSTRAINT `fk_dsl_trans_desde` FOREIGN KEY (`trans_desde`) REFERENCES `dsl_estado` (`estado_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsl_trans_hasta')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_estado_transicion'
                     AND COLUMN_NAME IN ('trans_hasta')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_estado_transicion` ', 'ADD CONSTRAINT `fk_dsl_trans_hasta` FOREIGN KEY (`trans_hasta`) REFERENCES `dsl_estado` (`estado_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslf_punto')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_factura'
                     AND COLUMN_NAME IN ('factura_puntoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_factura` ', 'ADD CONSTRAINT `fk_dslf_punto` FOREIGN KEY (`factura_puntoid`) REFERENCES `facturas_electronicas_punto_emision` (`punto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslfd_factura')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_factura_detalle'
                     AND COLUMN_NAME IN ('detalle_facturaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_factura_detalle` ', 'ADD CONSTRAINT `fk_dslfd_factura` FOREIGN KEY (`detalle_facturaid`) REFERENCES `dsl_factura` (`factura_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslfp_factura')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_factura_pago'
                     AND COLUMN_NAME IN ('pago_facturaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_factura_pago` ', 'ADD CONSTRAINT `fk_dslfp_factura` FOREIGN KEY (`pago_facturaid`) REFERENCES `dsl_factura` (`factura_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslf_categoria')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_fase'
                     AND COLUMN_NAME IN ('fase_categoriaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_fase` ', 'ADD CONSTRAINT `fk_dslf_categoria` FOREIGN KEY (`fase_categoriaid`) REFERENCES `dsl_categoria` (`categoria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslg_fase')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_grupo'
                     AND COLUMN_NAME IN ('grupo_faseid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_grupo` ', 'ADD CONSTRAINT `fk_dslg_fase` FOREIGN KEY (`grupo_faseid`) REFERENCES `dsl_fase` (`fase_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslge_grupo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_grupo_equipo'
                     AND COLUMN_NAME IN ('ge_grupoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_grupo_equipo` ', 'ADD CONSTRAINT `fk_dslge_grupo` FOREIGN KEY (`ge_grupoid`) REFERENCES `dsl_grupo` (`grupo_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslge_inscripcion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_grupo_equipo'
                     AND COLUMN_NAME IN ('ge_inscripcionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_grupo_equipo` ', 'ADD CONSTRAINT `fk_dslge_inscripcion` FOREIGN KEY (`ge_inscripcionid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsli_categoria')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_inscripcion'
                     AND COLUMN_NAME IN ('inscripcion_categoriaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_inscripcion` ', 'ADD CONSTRAINT `fk_dsli_categoria` FOREIGN KEY (`inscripcion_categoriaid`) REFERENCES `dsl_categoria` (`categoria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsli_equipo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_inscripcion'
                     AND COLUMN_NAME IN ('inscripcion_equipoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_inscripcion` ', 'ADD CONSTRAINT `fk_dsli_equipo` FOREIGN KEY (`inscripcion_equipoid`) REFERENCES `dsl_equipo` (`equipo_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsli_estado')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_inscripcion'
                     AND COLUMN_NAME IN ('inscripcion_estadoid','inscripcion_estadoentidad')) = 2,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_inscripcion` ', 'ADD CONSTRAINT `fk_dsli_estado` FOREIGN KEY (`inscripcion_estadoid`, `inscripcion_estadoentidad`) REFERENCES `dsl_estado` (`estado_id`, `estado_entidad`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslj_fase')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_jornada'
                     AND COLUMN_NAME IN ('jornada_faseid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_jornada` ', 'ADD CONSTRAINT `fk_dslj_fase` FOREIGN KEY (`jornada_faseid`) REFERENCES `dsl_fase` (`fase_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslo_categoria')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_obligacion'
                     AND COLUMN_NAME IN ('obligacion_categoriaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `fk_dslo_categoria` FOREIGN KEY (`obligacion_categoriaid`) REFERENCES `dsl_categoria` (`categoria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslo_concepto')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_obligacion'
                     AND COLUMN_NAME IN ('obligacion_conceptoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `fk_dslo_concepto` FOREIGN KEY (`obligacion_conceptoid`) REFERENCES `dsl_concepto` (`concepto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslo_equipo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_obligacion'
                     AND COLUMN_NAME IN ('obligacion_equipoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `fk_dslo_equipo` FOREIGN KEY (`obligacion_equipoid`) REFERENCES `dsl_equipo` (`equipo_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslo_factura')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_obligacion'
                     AND COLUMN_NAME IN ('obligacion_facturaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `fk_dslo_factura` FOREIGN KEY (`obligacion_facturaid`) REFERENCES `dsl_factura` (`factura_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslo_persona')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_obligacion'
                     AND COLUMN_NAME IN ('obligacion_personaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `fk_dslo_persona` FOREIGN KEY (`obligacion_personaid`) REFERENCES `dsl_persona` (`persona_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_estado')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_estadoid','partido_estadoentidad')) = 2,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_estado` FOREIGN KEY (`partido_estadoid`, `partido_estadoentidad`) REFERENCES `dsl_estado` (`estado_id`, `estado_entidad`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_fase')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_faseid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_fase` FOREIGN KEY (`partido_faseid`) REFERENCES `dsl_fase` (`fase_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_grupo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_grupoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_grupo` FOREIGN KEY (`partido_grupoid`) REFERENCES `dsl_grupo` (`grupo_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_jornada')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_jornadaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_jornada` FOREIGN KEY (`partido_jornadaid`) REFERENCES `dsl_jornada` (`jornada_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_local')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_localid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_local` FOREIGN KEY (`partido_localid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_serie')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_serieid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_serie` FOREIGN KEY (`partido_serieid`) REFERENCES `dsl_serie` (`serie_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpa_visitante')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido'
                     AND COLUMN_NAME IN ('partido_visitanteid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `fk_dslpa_visitante` FOREIGN KEY (`partido_visitanteid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslps_partido')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido_stat'
                     AND COLUMN_NAME IN ('stat_partidoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido_stat` ', 'ADD CONSTRAINT `fk_dslps_partido` FOREIGN KEY (`stat_partidoid`) REFERENCES `dsl_partido` (`partido_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslps_persona')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido_stat'
                     AND COLUMN_NAME IN ('stat_personaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido_stat` ', 'ADD CONSTRAINT `fk_dslps_persona` FOREIGN KEY (`stat_personaid`) REFERENCES `dsl_persona` (`persona_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslps_tipo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_partido_stat'
                     AND COLUMN_NAME IN ('stat_tipoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido_stat` ', 'ADD CONSTRAINT `fk_dslps_tipo` FOREIGN KEY (`stat_tipoid`) REFERENCES `dsl_estadistica_tipo` (`tipo_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpl_inscripcion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_plantilla'
                     AND COLUMN_NAME IN ('plantilla_inscripcionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_plantilla` ', 'ADD CONSTRAINT `fk_dslpl_inscripcion` FOREIGN KEY (`plantilla_inscripcionid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslpl_persona')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_plantilla'
                     AND COLUMN_NAME IN ('plantilla_personaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_plantilla` ', 'ADD CONSTRAINT `fk_dslpl_persona` FOREIGN KEY (`plantilla_personaid`) REFERENCES `dsl_persona` (`persona_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslse_fase')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_serie'
                     AND COLUMN_NAME IN ('serie_faseid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_serie` ', 'ADD CONSTRAINT `fk_dslse_fase` FOREIGN KEY (`serie_faseid`) REFERENCES `dsl_fase` (`fase_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslse_ganador')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_serie'
                     AND COLUMN_NAME IN ('serie_ganadorid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_serie` ', 'ADD CONSTRAINT `fk_dslse_ganador` FOREIGN KEY (`serie_ganadorid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslse_local')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_serie'
                     AND COLUMN_NAME IN ('serie_localid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_serie` ', 'ADD CONSTRAINT `fk_dslse_local` FOREIGN KEY (`serie_localid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslse_visitante')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_serie'
                     AND COLUMN_NAME IN ('serie_visitanteid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_serie` ', 'ADD CONSTRAINT `fk_dslse_visitante` FOREIGN KEY (`serie_visitanteid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dsls_fase')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo'
                     AND COLUMN_NAME IN ('sorteo_faseid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo` ', 'ADD CONSTRAINT `fk_dsls_fase` FOREIGN KEY (`sorteo_faseid`) REFERENCES `dsl_fase` (`fase_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslsb_inscripcion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_bombo'
                     AND COLUMN_NAME IN ('bombo_inscripcionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_bombo` ', 'ADD CONSTRAINT `fk_dslsb_inscripcion` FOREIGN KEY (`bombo_inscripcionid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslsb_sorteo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_bombo'
                     AND COLUMN_NAME IN ('bombo_sorteoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_bombo` ', 'ADD CONSTRAINT `fk_dslsb_sorteo` FOREIGN KEY (`bombo_sorteoid`) REFERENCES `dsl_sorteo` (`sorteo_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslsr_sorteo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_restriccion'
                     AND COLUMN_NAME IN ('restriccion_sorteoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_restriccion` ', 'ADD CONSTRAINT `fk_dslsr_sorteo` FOREIGN KEY (`restriccion_sorteoid`) REFERENCES `dsl_sorteo` (`sorteo_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslsres_inscripcion')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_resultado'
                     AND COLUMN_NAME IN ('resultado_inscripcionid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_resultado` ', 'ADD CONSTRAINT `fk_dslsres_inscripcion` FOREIGN KEY (`resultado_inscripcionid`) REFERENCES `dsl_inscripcion` (`inscripcion_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslsres_sorteo')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_sorteo_resultado'
                     AND COLUMN_NAME IN ('resultado_sorteoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_resultado` ', 'ADD CONSTRAINT `fk_dslsres_sorteo` FOREIGN KEY (`resultado_sorteoid`) REFERENCES `dsl_sorteo` (`sorteo_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_dslto_temporada')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'dsl_torneo'
                     AND COLUMN_NAME IN ('torneo_temporadaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`dsl_torneo` ', 'ADD CONSTRAINT `fk_dslto_temporada` FOREIGN KEY (`torneo_temporadaid`) REFERENCES `dsl_temporada` (`temporada_id`) ON DELETE NO ACTION ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_fed_factura')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_detalle'
                     AND COLUMN_NAME IN ('factura_electronica_id')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_detalle` ', 'ADD CONSTRAINT `fk_fed_factura` FOREIGN KEY (`factura_electronica_id`) REFERENCES `facturas_electronicas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_fep_factura')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'facturas_electronicas_pagos'
                     AND COLUMN_NAME IN ('factura_electronica_id')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`facturas_electronicas_pagos` ', 'ADD CONSTRAINT `fk_fep_factura` FOREIGN KEY (`factura_electronica_id`) REFERENCES `facturas_electronicas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_sede_escuela')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_sede'
                     AND COLUMN_NAME IN ('sede_escuelaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`general_sede` ', 'ADD CONSTRAINT `fk_sede_escuela` FOREIGN KEY (`sede_escuelaid`) REFERENCES `general_escuela` (`escuela_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_catalogo_tabla')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'general_tabla_catalogo'
                     AND COLUMN_NAME IN ('catalogo_tablaid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`general_tabla_catalogo` ', 'ADD CONSTRAINT `fk_catalogo_tabla` FOREIGN KEY (`catalogo_tablaid`) REFERENCES `general_tabla` (`tabla_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_auditoria_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'insights_auditoria'
                     AND COLUMN_NAME IN ('auditoria_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`insights_auditoria` ', 'ADD CONSTRAINT `fk_auditoria_sede` FOREIGN KEY (`auditoria_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE SET NULL ON UPDATE RESTRICT'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_snapshot_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'insights_cartera_snapshot'
                     AND COLUMN_NAME IN ('snapshot_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`insights_cartera_snapshot` ', 'ADD CONSTRAINT `fk_snapshot_sede` FOREIGN KEY (`snapshot_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE RESTRICT'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_pub_alumno')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'redes_publicacion'
                     AND COLUMN_NAME IN ('pub_alumnoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`redes_publicacion` ', 'ADD CONSTRAINT `fk_pub_alumno` FOREIGN KEY (`pub_alumnoid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE SET NULL ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_2faev_usuario')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_2fa_evento'
                     AND COLUMN_NAME IN ('ev_usuarioid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_2fa_evento` ', 'ADD CONSTRAINT `fk_2faev_usuario` FOREIGN KEY (`ev_usuarioid`) REFERENCES `seguridad_usuario` (`usuario_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_2farec_usuario')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_2fa_recuperacion'
                     AND COLUMN_NAME IN ('rec_usuarioid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_2fa_recuperacion` ', 'ADD CONSTRAINT `fk_2farec_usuario` FOREIGN KEY (`rec_usuarioid`) REFERENCES `seguridad_usuario` (`usuario_id`) ON DELETE CASCADE ON UPDATE NO ACTION'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_permiso_menu')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_permiso'
                     AND COLUMN_NAME IN ('permiso_menuid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_permiso` ', 'ADD CONSTRAINT `fk_permiso_menu` FOREIGN KEY (`permiso_menuid`) REFERENCES `seguridad_menu` (`menu_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_permiso_rol')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_permiso'
                     AND COLUMN_NAME IN ('permiso_rolid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_permiso` ', 'ADD CONSTRAINT `fk_permiso_rol` FOREIGN KEY (`permiso_rolid`) REFERENCES `seguridad_rol` (`rol_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_rolmodulo_rol')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_rol_modulo'
                     AND COLUMN_NAME IN ('rolmod_rolid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_rol_modulo` ', 'ADD CONSTRAINT `fk_rolmodulo_rol` FOREIGN KEY (`rolmod_rolid`) REFERENCES `seguridad_rol` (`rol_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_usuario_empleado')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_usuario'
                     AND COLUMN_NAME IN ('usuario_empleadoid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_usuario` ', 'ADD CONSTRAINT `fk_usuario_empleado` FOREIGN KEY (`usuario_empleadoid`) REFERENCES `sujeto_empleado` (`empleado_id`) ON DELETE SET NULL ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_usuario_rol')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_usuario'
                     AND COLUMN_NAME IN ('usuario_rolid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_usuario` ', 'ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`usuario_rolid`) REFERENCES `seguridad_rol` (`rol_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_usuariosede_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_usuario_sede'
                     AND COLUMN_NAME IN ('usuariosede_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_usuario_sede` ', 'ADD CONSTRAINT `fk_usuariosede_sede` FOREIGN KEY (`usuariosede_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_usuariosede_usuario')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'seguridad_usuario_sede'
                     AND COLUMN_NAME IN ('usuariosede_usuarioid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`seguridad_usuario_sede` ', 'ADD CONSTRAINT `fk_usuariosede_usuario` FOREIGN KEY (`usuariosede_usuarioid`) REFERENCES `seguridad_usuario` (`usuario_id`) ON DELETE CASCADE ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_alumno_origen')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'sujeto_alumno'
                     AND COLUMN_NAME IN ('alumno_origenid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`sujeto_alumno` ', 'ADD CONSTRAINT `fk_alumno_origen` FOREIGN KEY (`alumno_origenid`) REFERENCES `sujeto_alumno` (`alumno_id`) ON DELETE SET NULL ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_alumno_representante')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'sujeto_alumno'
                     AND COLUMN_NAME IN ('alumno_repreid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`sujeto_alumno` ', 'ADD CONSTRAINT `fk_alumno_representante` FOREIGN KEY (`alumno_repreid`) REFERENCES `alumno_representante` (`repre_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_alumno_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'sujeto_alumno'
                     AND COLUMN_NAME IN ('alumno_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`sujeto_alumno` ', 'ADD CONSTRAINT `fk_alumno_sede` FOREIGN KEY (`alumno_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'fk_empleado_sede')
              AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE BINARY TABLE_SCHEMA = BINARY @db AND TABLE_NAME = 'sujeto_empleado'
                     AND COLUMN_NAME IN ('empleado_sedeid')) = 1,
    CONCAT('ALTER TABLE `', @db, '`.`sujeto_empleado` ', 'ADD CONSTRAINT `fk_empleado_sede` FOREIGN KEY (`empleado_sedeid`) REFERENCES `general_sede` (`sede_id`) ON DELETE RESTRICT ON UPDATE CASCADE'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

/* ---------- 3. Restricciones CHECK ---------- */

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_bloqueo_rango' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo` ', 'ADD CONSTRAINT `ck_bloqueo_rango` CHECK (`bloqueo_fin` > `bloqueo_inicio`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_grupo_fechas' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_bloqueo_grupo` ', 'ADD CONSTRAINT `ck_grupo_fechas` CHECK (`grupo_fechahasta` >= `grupo_fechadesde`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_devolucion_medio' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_devolucion` ', 'ADD CONSTRAINT `ck_devolucion_medio` CHECK (`devolucion_medio` in (_utf8mb4''EFE'',_utf8mb4''TRA'',_utf8mb4''MON''))'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_devolucion_origen' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_devolucion` ', 'ADD CONSTRAINT `ck_devolucion_origen` CHECK (`devolucion_origen` in (_utf8mb4''C'',_utf8mb4''E''))'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_devolucion_valor' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_devolucion` ', 'ADD CONSTRAINT `ck_devolucion_valor` CHECK (`devolucion_valor` > 0)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_horario_dia' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_horario` ', 'ADD CONSTRAINT `ck_horario_dia` CHECK (`horario_dia` between 1 and 7)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_horario_rango' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_horario` ', 'ADD CONSTRAINT `ck_horario_rango` CHECK (`horario_hasta` > `horario_desde`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_monedero_saldo' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero` ', 'ADD CONSTRAINT `ck_monedero_saldo` CHECK (`monedero_saldo` >= 0)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_movimiento_valor' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_monedero_movimiento` ', 'ADD CONSTRAINT `ck_movimiento_valor` CHECK (`movimiento_valor` > 0)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_pago_valor' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_pago` ', 'ADD CONSTRAINT `ck_pago_valor` CHECK (`pago_valor` > 0)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_reserva_rango' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva` ', 'ADD CONSTRAINT `ck_reserva_rango` CHECK (`reserva_horafin` > `reserva_horainicio`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_fija_dia' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva_fija` ', 'ADD CONSTRAINT `ck_fija_dia` CHECK (`fija_dia` between 1 and 7)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_fija_rango' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_reserva_fija` ', 'ADD CONSTRAINT `ck_fija_rango` CHECK (`fija_horafin` > `fija_horainicio`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_tarifa_rango' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsa_tarifa` ', 'ADD CONSTRAINT `ck_tarifa_rango` CHECK (`tarifa_hasta` > `tarifa_desde`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dsla_valor' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_abono` ', 'ADD CONSTRAINT `ck_dsla_valor` CHECK (`abono_valor` > 0)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslc_edades' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_categoria` ', 'ADD CONSTRAINT `ck_dslc_edades` CHECK ((`categoria_edadmin` is null) or (`categoria_edadmax` is null) or (`categoria_edadmin` <= `categoria_edadmax`))'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslo_descuento' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `ck_dslo_descuento` CHECK (`obligacion_descuento` <= `obligacion_valor`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslo_positivos' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_obligacion` ', 'ADD CONSTRAINT `ck_dslo_positivos` CHECK ((`obligacion_valor` >= 0) and (`obligacion_descuento` >= 0) and (`obligacion_recargo` >= 0))'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslpa_rivales' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_partido` ', 'ADD CONSTRAINT `ck_dslpa_rivales` CHECK (`partido_localid` <> `partido_visitanteid`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslpl_fechas' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_plantilla` ', 'ADD CONSTRAINT `ck_dslpl_fechas` CHECK ((`plantilla_baja` is null) or (`plantilla_baja` >= `plantilla_alta`))'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslse_mejorde' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_serie` ', 'ADD CONSTRAINT `ck_dslse_mejorde` CHECK ((`serie_mejorde` % 2) = 1)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

SET @sql := IF(NOT EXISTS (SELECT 1 FROM information_schema.TABLE_CONSTRAINTS WHERE BINARY CONSTRAINT_SCHEMA = BINARY @db AND CONSTRAINT_NAME = 'ck_dslsr_distintos' AND CONSTRAINT_TYPE = 'CHECK'),
    CONCAT('ALTER TABLE `', @db, '`.`dsl_sorteo_restriccion` ', 'ADD CONSTRAINT `ck_dslsr_distintos` CHECK (`restriccion_menorid` < `restriccion_mayorid`)'), 'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;
