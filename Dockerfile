# Usar la imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip curl git libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo en /var/www/html
WORKDIR /var/www/html

# Copiar los archivos del proyecto al contenedor
COPY . /var/www/html

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Establecer los permisos correctos para almacenamiento y caché
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html

# Configurar Apache para usar el directorio público de Laravel
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Configurar el puerto de escucha dinámico (Railway usa la variable de entorno PORT)
ENV PORT=8080
RUN sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf

# Migraciones y optimización de Laravel
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear \
    && php artisan optimize \
    && php artisan migrate --force

# Exponer el puerto dinámico
EXPOSE 8080

# Comando predeterminado para iniciar Apache
CMD ["apache2-foreground"]
