#!/bin/bash

# Generar key si es necesario
php artisan key:generate --force

# Limpiar configuraciones
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Ejecutar migraciones
php artisan migrate --force

# Configurar puerto de Apache
sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Iniciar Apache
apache2ctl -D FOREGROUND