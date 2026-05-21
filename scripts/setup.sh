#!/bin/bash
set -e

echo "=== Inicializando base de datos Fábrica ==="

# Levantar el contenedor de PostgreSQL
echo "[1/3] Levantando contenedor PostgreSQL..."
docker compose up -d

# Esperar a que PostgreSQL esté listo
echo "[2/3] Esperando a que PostgreSQL esté listo..."
until docker compose exec -T postgres pg_isready -U fabrica -d fabrica > /dev/null 2>&1; do
    sleep 2
done
echo "PostgreSQL está listo."

# El script init.sql se ejecuta automáticamente al iniciar el contenedor
# por estar montado en /docker-entrypoint-initdb.d/
echo "[3/3] Base de datos inicializada correctamente."
echo ""
echo "=== Conexión ==="
echo "Host: localhost"
echo "Puerto: 5432"
echo "Usuario: fabrica"
echo "Password: fabrica123"
echo "Base de datos: fabrica"
echo ""
echo "Ejemplo de conexión:"
echo "  psql -h localhost -U fabrica -d fabrica"
