-- 067_tarjeta_cumple_sendero.sql
-- La tarjeta de cumpleanos como la generaba Sendero de Campeones v1
-- (app/views/content/cumpleaniosTarjeta-view.php).
--
-- Sendero usa su propio marco (ds_futbol/app/views/imagenes/cumples/marco.png,
-- 900 x 1600, copiado del sistema anterior) y la franja VERDE #054017 al 70 %
-- (alpha GD 38), la misma de barcelona; lo que cambia es el area de la foto.
-- Medidas de v1 pasadas a porcentajes del marco, con la misma formula con la
-- que el 067 de Champions obtiene sus 72,822 / 75,772 (verificada):
--   foto     x 21,8 %  y 17,6 %  ancho 55,8 %  alto 46,3 %
--   franja   18 % del alto de la foto = 8,334 % del marco, inclinada -2,5 grados
--            centro = pie de la foto - media franja + medio desnivel del giro
--            (502,2 px * tan 2,5 / 2 = 10,96 px = 0,685 %) = 60,418 %
--   nombre   5,5 % del ancho de la foto = 3,069 % del marco, blanco,
--            linea base en 58,918 % (centro de la franja menos 18 % de su alto)
--   edad     4 % del ancho de la foto = 2,232 % del marco, amarillo #FFE001,
--            linea base en 61,752 % (centro de la franja mas 16 % de su alto)
--
-- Idempotente.
SET NAMES utf8mb4;
UPDATE cumple_plantilla
   SET foto_x = 21.800, foto_y = 17.600, foto_ancho = 55.800, foto_alto = 46.300,
       nombre_x = 21.800, nombre_y = 58.918, nombre_ancho = 55.800, nombre_tam = 3.069,
       nombre_color = '#FFFFFF', nombre_alinea = 'C',
       edad_x = 21.800, edad_y = 61.752, edad_ancho = 55.800, edad_tam = 2.232,
       edad_color = '#FFE001', edad_alinea = 'C', edad_texto = '{edad} AÑOS',
       franja_activa = 'S', franja_alto = 8.334, franja_color = '#054017', franja_opacidad = 70,
       angulo = -2.50
 WHERE plantilla_archivo = 'marco.png';
