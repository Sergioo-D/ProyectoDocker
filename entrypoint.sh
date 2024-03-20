#!/bin/sh

# Salir si algún comando falla
set -e

# Esperar a que la base de datos esté lista (Opcional, útil si tienes problemas de sincronización al arrancar)
# echo "Esperando a la base de datos..."
# while ! nc -z db 3306; do
#   sleep 0.1
# done
# echo "Base de datos iniciada"

# Aplicar migraciones de Django
echo "Aplicando migraciones..."
python manage.py migrate --noinput

# Iniciar el servidor de desarrollo de Django
echo "Iniciando el servidor de Django..."
exec python manage.py runserver 0.0.0.0:8000
