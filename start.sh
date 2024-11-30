#!/bin/bash

# Imprimir variables para depuración
echo "PORT: $PORT"
echo "APP_KEY: $APP_KEY"

# Verificar y generar .env si no existe
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Establecer APP_KEY si no está presente
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
else
    # Usar la APP_KEY proporcionada
    sed -i "s|^APP_KEY=.*|APP_KEY=$APP_KEY|" .env
fi

# Limpiar configuraciones
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Ejecutar migraciones
php artisan migrate --force

# Configurar puerto de Apache
PORT=${PORT:-80}
sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf
sed -i "s/*:80/*:$PORT/g" /etc/apache2/sites-available/000-default.conf

# Iniciar Apache
apache2ctl -D FOREGROUND