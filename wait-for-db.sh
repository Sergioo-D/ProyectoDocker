#!/bin/bash

set -e

# Parámetros de conexión a la base de datos
host="$1"
shift
port="$1"
shift
cmd="$@"
user="bogdanadmin"
password="n!H7Pm9~]w2CCy8?<|yB1apDc4[>BrdkC.#|zG5EQ"

# Configuración de reintentos
max_attempts=30
attempt_num=1
sleep_seconds=5

until mysql -h "$host" -P "$port" -u"$user" -p"$password" -e "SHOW DATABASES;" > /dev/null 2>&1; do
  >&2 echo "MySQL is unavailable - sleeping ($attempt_num/$max_attempts)"
  sleep $sleep_seconds
  if [ $attempt_num -eq $max_attempts ]; then
    echo "MySQL is still unavailable after $max_attempts attempts - stopping."
    exit 1
  fi
  ((attempt_num++))
done

>&2 echo "MySQL is up - executing command"
exec $cmd
