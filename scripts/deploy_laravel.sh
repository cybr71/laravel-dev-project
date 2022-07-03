#!/bin/bash

# Install dependencies
export COMPOSER_ALLOW_SUPERUSER=1
composer install -d /var/www/releases/dev-php/

# Migrate all tables
php /var/www/releases/dev-php/artisan migrate --force

# Clear any previous cached views
php /var/www/releases/dev-php/artisan config:clear
php /var/www/releases/dev-php/artisan cache:clear
php /var/www/releases/dev-php/artisan view:clear

# Optimize the application
php /var/www/releases/dev-php/artisan config:cache
php /var/www/releases/dev-php/artisan optimize
#php /var/www/html/artisan route:cache
