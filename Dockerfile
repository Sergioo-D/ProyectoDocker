FROM python:3.12.2

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Usar apt-get para instalar dependencias (actualizar índices de paquetes y luego instalar)
# Nota: El paquete musl-dev no es necesario en Debian, se usa build-essential en su lugar
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \ # Equivalente a mysql-dev en Alpine
    gcc \
    build-essential \ # Este paquete incluye 'make', 'gcc', etc., útil para la compilación
    netcat-openbsd \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/* # Limpiar cache de apt

# Copiar los archivos del proyecto al directorio de trabajo
COPY . .

# Instalar las dependencias del proyecto
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el script de entrada y hacerlo ejecutable
RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/wait-for-db.sh

# Exponer el puerto 8000 para que la aplicación sea accesible
EXPOSE 8000

# Usar el script de entrada como punto de entrada
CMD ["/app/entrypoint.sh"]
