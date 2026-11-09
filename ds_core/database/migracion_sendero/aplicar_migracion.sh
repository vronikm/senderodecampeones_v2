#!/bin/bash
# =====================================================================
# Convierte una copia de la base de Sendero de Campeones v1 en una base
# DigiSports. Variante de migracion_champions/aplicar_migracion.sh.
#
#   ./aplicar_migracion.sh BASE              aplica la cadena sobre BASE
#   ./aplicar_migracion.sh --generar ARCHIVO escribe la cadena en UN .sql
#
# BASE es una copia restaurada de Sendero v1 (ver LEEME.md). Nunca la base
# en uso: se trabaja sobre una copia.
#
# Cliente y credenciales por variables de entorno:
#   MYSQL       ruta al cliente         (por omision: mysql)
#   MYSQL_OPTS  opciones de conexion    (por omision: -u root)
# =====================================================================
set -u
AQUI="$(cd "$(dirname "$0")" && pwd)"
RAIZ="$(cd "$AQUI/.." && pwd)"          # ds_core/database
CHAMPIONS="$RAIZ/migracion_champions"

# --- El orden ---------------------------------------------------------
# 000: el de Sendero (ya tiene las nueve tablas que crea el de Champions).
# 014, 015 y 041: las versiones de migracion_champions (roles existentes y
#                 ALTER DATABASE sin nombre).
# 065 y 067: las de Sendero. 068 (dato de Champions) no aplica.
# 066 y 069-083: las de migracion_champions, que son genericas.
ARCHIVOS=("$AQUI/000_previo_sendero.sql")
for f in "$RAIZ"/0[0-6][0-9]_*.sql; do
    n=$(basename "$f" | cut -c1-3)
    case "$n" in
        014) ARCHIVOS+=("$CHAMPIONS/014_permisos_opciones_nuevas.champions.sql") ;;
        015) ARCHIVOS+=("$CHAMPIONS/015_dashboard_operativo.champions.sql") ;;
        041) ARCHIVOS+=("$CHAMPIONS/041_unificar_cotejamiento.champions.sql") ;;
        *)   ARCHIVOS+=("$f") ;;
    esac
done
ARCHIVOS+=("$AQUI/065_ajustes_sendero.sql"
           "$CHAMPIONS/066_nombre_futbol.sql"
           "$AQUI/067_tarjeta_cumple_sendero.sql")
for f in "$CHAMPIONS"/069_*.sql "$CHAMPIONS"/0[7-9][0-9]_*.sql; do
    [ -f "$f" ] && ARCHIVOS+=("$f")
done
# 082 en adelante: lo propio de Sendero que DigiSports no traia.
for f in "$AQUI"/08[2-9]_*_sendero.sql "$AQUI"/09[0-9]_*_sendero.sql; do
    [ -f "$f" ] && ARCHIVOS+=("$f")
done

# --- Un solo archivo para phpMyAdmin ----------------------------------
if [ "${1:-}" = "--generar" ]; then
    SALIDA="${2:?Uso: $0 --generar ARCHIVO.sql}"
    {
        printf -- "-- =====================================================================\n"
        printf -- "-- Sendero de Campeones: migracion v1 -> DigiSports, en un solo archivo\n"
        printf -- "-- Generado %s con aplicar_migracion.sh --generar (%d archivos).\n" "$(date '+%Y-%m-%d %H:%M')" "${#ARCHIVOS[@]}"
        printf -- "--\n-- Importar con phpMyAdmin SOBRE LA BASE QUE CONTIENE LA COPIA DE\n"
        printf -- "-- SENDERO V1, despues de respaldarla. No repetir sobre una base ya migrada.\n"
        printf -- "-- =====================================================================\nSET NAMES utf8mb4;\n"
        for f in "${ARCHIVOS[@]}"; do
            printf "\n-- ---------------------------------------------------------------------\n-- >>> %s\n" "$(basename "$f")"
            printf -- "-- ---------------------------------------------------------------------\n"
            tr -d '\r' < "$f" | sed '1s/^\xEF\xBB\xBF//'
            printf "\n"
        done
    } > "$SALIDA"
    echo "Escrito $SALIDA con ${#ARCHIVOS[@]} archivos."
    exit 0
fi

BASE="${1:?Uso: $0 BASE   |   $0 --generar ARCHIVO.sql}"
MYSQL="${MYSQL:-mysql}"
MYSQL_OPTS="${MYSQL_OPTS:--u root}"
sql() { $MYSQL $MYSQL_OPTS --default-character-set=utf8mb4 -N -B "$BASE" -e "$1"; }
existe() { [ "$(sql "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '$1'")" = "1" ]; }

# --- La base tiene que ser Sendero v1 SIN migrar ----------------------
existe sujeto_alumno         || { echo "DETENIDO: $BASE no parece Sendero v1 (no tiene sujeto_alumno)."; exit 1; }
existe facturas_electronicas || { echo "DETENIDO: $BASE no parece Sendero v1 (no tiene facturas_electronicas). Para SoccerEasy use migracion_champions."; exit 1; }
existe cumple_plantilla      && { echo "DETENIDO: $BASE ya esta migrada (tiene cumple_plantilla). No se aplica nada."; exit 1; }

# --- Aplicar ----------------------------------------------------------
echo "Base: $BASE   ·   ${#ARCHIVOS[@]} archivos"
i=0
for f in "${ARCHIVOS[@]}"; do
    i=$((i + 1))
    printf "  %2d/%d  %-48s " "$i" "${#ARCHIVOS[@]}" "$(basename "$f")"
    if salida=$($MYSQL $MYSQL_OPTS --default-character-set=utf8mb4 "$BASE" < "$f" 2>&1); then
        echo "ok"
    else
        echo "ERROR"; echo "$salida" | sed 's/^/        /'
        echo "DETENIDO en $(basename "$f"). Lo aplicado antes queda aplicado: restaure la copia y corrija antes de repetir."
        exit 1
    fi
done
echo "Terminado. Compruebe con:  php ds_core/database/estado_migraciones.php"
