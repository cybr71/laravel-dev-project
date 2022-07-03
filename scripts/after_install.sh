#!/usr/bin/env bash


# First i will stop queu worker and then make sure
# Server is down

echo "Stop queue worker.." >> /var/log/deploy.log
echo "php artisan down.." >> /var/log/deploy.log

php /var/www/dev-php/artisan down



# I have left a few things in here and will explain this further (see below)

rsync --delete-before --verbose --archive --exclude "storage/logs/" --exclude "storage/oauth-*" --exclude ".git/*"  /var/www/releases/dev-php/ /var/www/dev-php/ >> /var/log/deploy.log


echo "Syncing end: /var/www/releases/dev-php /var/www/dev-php" >> /var/log/deploy.log


# Create cache and chmod folders
mkdir -p /var/www/dev-php/bootstrap/cache
mkdir -p /var/www/dev-php/storage/framework/sessions
mkdir -p /var/www/dev-php/storage/framework/views
mkdir -p /var/www/dev-php/storage/framework/cache
mkdir -p /var/www/dev-php/public/files/

# Change rights
chmod 777 -R /var/www/dev-php/bootstrap/cache
chmod 777 -R /var/www/dev-php/storage

# Change owner
chown ubuntu:www-data -R /var/www/dev-php

# Bring up application
php /var/www/dev-php/artisan up


# Clear any previous cached views
php /var/www/dev-php/artisan config:clear
php /var/www/dev-php/artisan cache:clear
php /var/www/dev-php/artisan view:clear

# Optimize the application
php /var/www/dev-php/artisan config:cache
php /var/www/dev-php/artisan optimize
#php /var/www/html/artisan route:cache
