FROM php:8.2.27-fpm

# install libraries
RUN apt-get update \
    && apt-get install -y zlib1g-dev libzip-dev \
    && docker-php-ext-install zip

# Install pcntl 
# Start Laravel's local development server, queue worker, and Vite development server
# using the dev Composer script
RUN docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install \
    pcntl

RUN apt-get install -y libpq-dev libmcrypt-dev default-mysql-client libxml2 libxml2-dev
RUN docker-php-ext-install pdo_mysql pdo_pgsql soap bcmath

RUN apt-get clean

# install node & npm
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer