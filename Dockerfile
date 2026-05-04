FROM php:8.2-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    gnupg \
    curl \
    unixodbc-dev \
    libzip-dev \
    zip \
    unzip

# Agregar repositorio de Microsoft
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/11/prod bullseye main" > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Instalar extensiones PHP
RUN pecl install sqlsrv-5.11.1 pdo_sqlsrv-5.11.1 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# 👉 INSTALAR COMPOSER
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

RUN chown -R www-data:www-data /var/www
USER www-data    

WORKDIR /var/www