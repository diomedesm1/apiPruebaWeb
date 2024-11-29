# Usa la imagen oficial de PHP con FPM
FROM php:8.2-fpm

# Instala dependencias necesarias para Laravel y Composer
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    unzip \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instala Composer para gestionar las dependencias de PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia el archivo de configuración de Nginx desde la raíz
COPY ./nginx.conf /etc/nginx/nginx.conf

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia el código de la aplicación Laravel al contenedor
COPY . .

# Instala las dependencias de Laravel con Composer (sin dependencias de desarrollo)
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Establece el puerto 80 para Nginx
EXPOSE 80

# Comando para iniciar Nginx y PHP-FPM
CMD nginx -g "daemon off;" && php-fpm

