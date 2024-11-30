FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    procps \
    nano

# Limpiar caché de apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Configurar DocumentRoot de Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configuración de Apache
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Habilitar logs detallados de Apache
RUN sed -i 's/LogLevel warn/LogLevel debug/g' /etc/apache2/apache2.conf

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar archivos del proyecto
COPY . /var/www/html

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Instalar dependencias de Composer
RUN composer install --no-dev --no-interaction --optimize-autoloader

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Preparar script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponer puerto
EXPOSE $PORT

# Comando de inicio
CMD ["/start.sh"]