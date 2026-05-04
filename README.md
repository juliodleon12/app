### CONSTRUIR CONTENEDORES
docker-compose up -d --build

### INGRESAR A CONTENEDOR PARA CORRER COMANDOS DE COMPOSER.
docker exec -it laravel_app bash

### CREAR LA APLICACION DE LARAVEL V10
composer create-project laravel/laravel:^10.0 --force

### INSTALAR AUTENTICACION.
## Debe de ser con blade para adminlte
composer require laravel/breeze --dev
php artisan breeze:install
npm install && npm run build


### INTEGRAR ADMIN LTE
composer require jeroennoten/laravel-adminlte
php artisan adminlte:install

### CONFIGURACION SQL SERVER EN .ENV
DB_CONNECTION=sqlsrv
DB_HOST=sqlsrv
DB_PORT=1433
DB_DATABASE=laravel
DB_USERNAME=sa
DB_PASSWORD=YourStrong!Passw0rd

DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

## PARA CERTIFICADO SSL DE LA BD EN config/database.php DESCOMENTAR
    'encrypt' => env('DB_ENCRYPT', 'true'),
    'trust_server_certificate' => env('DB_TRUST_SERVER_CERTIFICATE', 'false'),

### ACCESO A CONTENEDOR SQL SERVER
docker exec -it sqlsrv 
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -C

### CREAR BASE DE DATOS.
CREATE DATABASE laravel;
GO

### MIGRAR TABLAS PARA LOGIN.
php artisan migrate

### LIMPIAR CACHE DE LARAVEL.
php artisan config:clear
php artisan cache:clear


### SOLUCIONAR ERRORES DE PERMISOS.
## INGRESAR A CONTENEDOR.
docker exec -it laravel_app bash

## DAR PERMISOS.
chown -R www-data:www-data /var/www
chmod -R 775 /var/www/storage
chmod -R 775 /var/www/bootstrap/cache
