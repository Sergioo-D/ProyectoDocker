FROM python:3.12.2-alpine3.19

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Instalar dependencias necesarias para mysqlclient, netcat (para el script de espera opcional) y el cliente de MySQL
RUN apk add --no-cache mysql-dev gcc musl-dev netcat-openbsd mariadb-client

# Copiar los archivos del proyecto al directorio de trabajo
COPY . .

# Instalar las dependencias del proyecto
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el script de entrada y hacerlo ejecutable
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# Exponer el puerto 8000 para que la aplicación sea accesible
EXPOSE 8000

# Usar el script de entrada como punto de entrada
CMD ["./entrypoint.sh"]
