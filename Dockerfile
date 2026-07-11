# ✅ Buster = OpenSSL 1.1.x = TLS 1.0 disponible
FROM php:8.2-fpm-buster

# ✅ Repositorios de archivo — Buster llegó a EOL
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    git \
    gnupg \
    curl \
    unixodbc-dev \
    libzip-dev \
    zip \
    unzip

RUN docker-php-ext-install zip

# ✅ Repositorio Microsoft para Debian 10 Buster
RUN curl https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/debian/10/prod buster main" \
    > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

RUN pecl install sqlsrv-5.10.1 pdo_sqlsrv-5.10.1 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# ✅ Habilitar TLS 1.0 en OpenSSL 1.1.x
RUN echo "" >> /etc/ssl/openssl.cnf && \
    echo "[system_default_sect]" >> /etc/ssl/openssl.cnf && \
    echo "MinProtocol = TLSv1" >> /etc/ssl/openssl.cnf && \
    echo "CipherString = DEFAULT@SECLEVEL=1" >> /etc/ssl/openssl.cnf

WORKDIR /var/www
