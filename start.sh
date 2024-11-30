#!/bin/bash

# Imprimir información de depuración
echo "Información del entorno:"
env

# Verificar archivos y permisos
echo "Contenido del directorio actual:"
ls -la

echo "Contenido del .env:"
cat .env || echo "No se pudo leer .env"

# Verificar instalación de dependencias
composer check-platform-reqs || echo "Error en requisitos de plataforma"

# Intentar generar key si es necesario
php artisan key:generate --force || echo "Error al generar key"

# Verificar configuración de la aplicación
php artisan config:show || echo "Error al mostrar configuración"

# Limpiar configuraciones
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Verificar estado de migraciones
php artisan migrate:status || echo "Error al verificar migraciones"

# Ejecutar migraciones
php artisan migrate --force || echo "Error en migraciones"

# Realizar chequeo de sistema
php artisan about || echo "Error al mostrar información del sistema"

# Configurar puerto de Apache
PORT=${PORT:-80}
sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf
sed -i "s/*:80/*:$PORT/g" /etc/apache2/sites-available/000-default.conf

# Imprimir logs de errores de PHP
echo "Últimos logs de errores de PHP:"
tail -n 50 /var/log/apache2/error.log || echo "No se encontraron logs de errores"

# Iniciar Apache con logs detallados
apache2ctl -D FOREGROUND -e debug