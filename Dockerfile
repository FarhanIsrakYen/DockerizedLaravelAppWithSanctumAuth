FROM php:8.2-fpm
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set working directory
WORKDIR /var/www/html/

# Install dependencies for the operating system software
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    openssl \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    libzip-dev \
    unzip \
    git \
    libonig-dev \
    curl \
    libpq-dev \
    cron \
    gnupg2 \
    libgmp-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Nodejs
# RUN apt-get update && apt-get install -y gpgv curl && \
#     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#     curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
#     apt-get install -y nodejs yarn && \
#     rm -rf /var/lib/apt/lists/

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions for php
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install composer (php package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents to the working directory
COPY . /var/www/html

# Assign permissions of the working directory to the www-data user
RUN chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

# Expose port 9000 and start php-fpm server (for FastCGI Process Manager)
EXPOSE 9000
CMD ["php-fpm"]
