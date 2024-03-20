FROM python:3.12.2-alpine3.19

# Establecer el directorio de trabajo en /app
WORKDIR /app

# Instalar dependencias necesarias para mysqlclient
RUN apk add --no-cache mysql-dev gcc musl-dev

# Copiar los archivos del proyecto al directorio de trabajo
COPY . .

# Instalar las dependencias del proyecto
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto 8000 para que la aplicación sea accesible
EXPOSE 8000

# Ejecutar el servidor de desarrollo de Django al iniciar el contenedor
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
