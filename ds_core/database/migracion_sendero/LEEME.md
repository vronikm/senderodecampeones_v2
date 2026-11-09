# Migración de Sendero de Campeones (v1) a DigiSports

Convierte una copia de la base de Sendero de Campeones v1 en una base
DigiSports. Ensayada el 2026-11-04 sobre `digitech_migra_senderocampeones`,
copia de `digitech_senderocampeones`. La base de origen nunca se toca: se
trabaja sobre una copia.

Variante de `../migracion_champions/` (SoccerEasy → DigiSports). Usa sus
archivos genéricos y sustituye solo los que llevan decisiones de Champions.

## Por qué no sirve tal cual la cadena de Champions

Sendero v1 es SoccerEasy **más exactamente las nueve tablas** que crea
`000_previo_champions.sql` (consentimientos, `carnet_configuracion` y las siete
de facturación electrónica), ya con datos propios. Comparado columna a columna
el 2026-11-04:

| tabla | diferencia con el 000 de Champions |
|---|---|
| `alumno_consentimiento`, `carnet_configuracion`, `facturas_electronicas_certificado`, `_detalle`, `_forma_pago`, `_pagos`, `_secuenciales` | idénticas |
| `facturas_electronicas` | + `factura_origen_id`, `reemplazada_por_id`, `reemplazo_motivo`, `reemplazo_confirmado_at`, `reemplazo_confirmado_by` (reemplazo por SECUENCIAL REGISTRADO, v1). Se conservan; DigiSports no las usa |
| `facturas_electronicas_config` | + `servicio_activo`, `mantenimiento_mensaje`, `ruc_proveedor`, `etiqueta_ruc_proveedor`. La `071` las da por existentes y no las repite |

Además ya no tenía `facturacion_factura(_pago)` y `torneo_equipo.equipo_categoria`
ya era `VARCHAR(50)`.

Por eso `aplicar_migracion.sh` de Champions se niega (la base ya tiene
`facturas_electronicas`) y su `pre_retirar_residuos_qa.sql` **borraría**
`carnet_configuracion`. No usarlos con Sendero.

## Qué cambia respecto a Champions

| paso | Sendero |
|---|---|
| `pre_retirar_residuos_qa` | **no se aplica** (borra `carnet_configuracion`; Sendero no tiene residuos QA) |
| `000` | `000_previo_sendero.sql`: solo `alumno_repreid` admite NULL (para la `008`) |
| `001`–`064` | iguales, con `014`, `015` y `041` de `migracion_champions/` |
| `065` | `065_ajustes_sendero.sql`: **no** quita Facturación al Administrador (Sendero factura), logo de Sendero, y cuelga los menús 43/44 que Sendero ya tenía del grupo 927 «Inscripción Online» |
| `066` | la de Champions (genérica) |
| `067` | `067_tarjeta_cumple_sendero.sql`: el marco y las medidas de la tarjeta de cumpleaños de Sendero v1 (franja verde #054017) |
| `068` | **no se aplica** (corrige un pago de Champions) |
| `069`–`083` | las de Champions (genéricas, repetibles) |
| `082` | `082_ver_asistencias_sendero.sql`: menú «Ver asistencias» (`asistenciaList`) bajo «Asistencia alumnos», con permiso de ver y exportar para el Administrador. Los `08x_*_sendero.sql` siguientes entran solos en la cadena |
| `084` | `084_secuencial_por_ambiente_sendero.sql`: pruebas y producción numeran por separado: columna `ambiente` en `facturas_electronicas_secuenciales` y el ambiente en la clave única del número (Fútbol y League). El siguiente secuencial de cada ambiente se define en Core › Puntos de emisión. Repetible |

Sendero tiene el rol 6 «Asistente» (como barcelona). No choca con la `029`,
que crea «Árbitro» y «Oficial de mesa» por nombre, con id automático.

## Un solo comando

```bash
MYSQL=/ruta/a/mysql MYSQL_OPTS="-u USUARIO -pCLAVE" \
  ds_core/database/migracion_sendero/aplicar_migracion.sh BASE
```

81 archivos, se detiene en el primer error. Antes de empezar exige que `BASE`
sea Sendero v1 **sin migrar** (tiene `facturas_electronicas` y no tiene
`cumple_plantilla`). Para phpMyAdmin: `--generar ARCHIVO.sql`.

## Orden completo

1. Crear la base vacía:
   ```sql
   CREATE DATABASE nombre CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
   ```
2. Restaurar el volcado de Sendero v1 con `SET default_storage_engine=InnoDB;
   SET FOREIGN_KEY_CHECKS=0;` al principio y `SET FOREIGN_KEY_CHECKS=1;` al final.
3. `aplicar_migracion.sh BASE`.
4. Comprobar (abajo).

## Archivos fuera de la base

Mismas rutas en v1 y en DigiSports, bajo `ds_futbol/`:

| Sendero v1 | DigiSports |
|---|---|
| `app/views/imagenes/…` (fotos, cédulas, pagos, ingresos, carnet, cumples) | `ds_futbol/app/views/imagenes/…` |
| `app/views/fotos/usuario/` | `ds_futbol/app/views/fotos/usuario/` |
| `storage/certificados/` (`firma.p12`, **`.cryptokey.php`**) | `ds_futbol/storage/certificados/` |
| `storage/sri/` (xml, ride, logs) | `ds_futbol/storage/sri/` |

Los de Sendero sobrescriben los marcadores de DigiSports donde coinciden
(fondo del carné `vertical_fondo.jpg`, imágenes por defecto, marco de cumpleaños).

Marca de Core (`ds_core/assets/img/marca/`): `organizacion_sendero.png`
(LogoSC de v1) y las fotos de sede que existan (`La_Salle_70.jpg`,
`El_Paraíso_26.jpg`); las sedes sin foto heredan el logo.

**La firma electrónica:** la clave está cifrada en la base con la llave de
`.cryptokey.php`. Hay que copiar la de **producción**: con la de desarrollo la
firma queda `SIN_CLAVE` (ocurre igual en v1 local con esta misma base).

## Comprobación del ensayo 2026-11-04

`php ds_core/database/estado_migraciones.php`: **36 aplicadas, 0 pendientes,
28 no determinables** (lo mismo que Champions).

Esquema idéntico a `digitech_migra_champions_cf` (104 tablas, 3 vistas,
mismos tipos, todo `utf8mb4_0900_ai_ci`) salvo las 5 columnas de reemplazo de
facturas de Sendero.

Datos contra el origen: alumnos 374 (230 activos), representantes 321, pagos
1112 (suma 23 878,88 / saldo 0,00), descuentos 160, asistencias 722, facturas
24 (780,00; 22 autorizadas), consentimientos 112, carnés 884, usuarios 5,
empleados 8, sedes 7 y el hash de nombres de alumnos, representantes y sedes:
**idénticos**. Única diferencia: `asistencia_asignahorario` 349 → 348; la fila
que falta apuntaba al alumno 119 y al horario 1, que no existen, y la `008` la
retira antes de crear las claves foráneas.

## Traído de Sendero v1

- «Ver asistencias» (`asistenciaList`, grilla mensual por alumno): vista
  `ds_futbol/app/views/content/asistenciaList-view.php`, métodos al final de
  `asistenciaController` y menú en la `082`. Diferencias con v1:
  - Las sedes siguen la regla de la sesión (`condicionSede`).
  - Cuenta los atrasos (A).
  - El porcentaje es el de «Ver registro»: (P + A) / días registrados.
  - Excel e imprimir solo con `permiso_exportar`.
  - Solo se sombrean los fines de semana: DigiSports no tiene tabla de feriados.
