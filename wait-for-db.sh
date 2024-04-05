#!/bin/bash

set -e

host="$1"
shift
port="$1"
shift
cmd="$@"

# Utiliza variables de entorno para las credenciales
DB_USER=${DB_USER:-bogdanadmin}
DB_PASS=${DB_PASS:-tuContraseña}

# Configura un timeout para evitar intentos de conexión infinitos
TIMEOUT=60
SECONDS=0

echo "Esperando a que MySQL en '$host:$port' esté disponible..."

until mysql -h "$host" -P "$port" -u"$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;" || [ $SECONDS -ge $TIMEOUT ]; do
  >&2 echo "MySQL aún no está disponible después de $SECONDS segundos..."
  sleep 1
  SECONDS=$((SECONDS+1))
done

if [ $SECONDS -ge $TIMEOUT ]; then
  >&2 echo "Se alcanzó el tiempo máximo de espera de $TIMEOUT segundos para MySQL."
  exit 1
fi

>&2 echo "MySQL está disponible después de $SECONDS segundos - ejecutando comando."
exec $cmd
