#!/bin/sh
WORKSPACE="/var/www/app"

chmod -R 777 $WORKSPACE/storage
chmod -R 777 $WORKSPACE/bootstrap

cd $WORKSPACE

# Install packages were managed by npm
npm install && npm run build

# install packages were managed by composer
composer install

# # migration
php artisan migrate

# create storage link
php artisan storage:link

# generate app key
php artisan key:generate

# start php-fpm
php-fpm -F
