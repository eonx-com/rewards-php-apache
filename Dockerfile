FROM php:7.1-apache

# Install operating system dependencies
RUN apt update; \
    apt install -y \
      libicu-dev \
      libjpeg-dev \
      libpng-dev \
      libfreetype6-dev \
      libmcrypt-dev \
      zlib1g-dev; \
    rm -r /var/lib/apt/lists/*;

# Install PHP extensions required for Laravel
RUN docker-php-ext-configure pdo_mysql \
        --with-pdo-mysql=mysqlnd; \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/; \
    docker-php-ext-install \
      bcmath \
      gd \
      intl \
      mbstring \
      mcrypt \
      pcntl \
      pdo_mysql \
      opcache \
      zip;

# Enable Apache URL Rewrite
RUN rm -rf /etc/apache2/sites-available/*; \
    rm -rf /etc/apache2/sites-enabled/*; \
    a2enmod rewrite; \
    service apache2 restart

# Change www-data user to match host uid
RUN usermod -u 1000 www-data; \
    groupmod -g 1000 www-data;

# Expose HTTP port
EXPOSE 80

# Installing AWS Cli
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
        unzip \
        wget \
        jq \
    && pip3 install --upgrade pip \
    && apt-get clean \
    && pecl install xdebug

RUN pip3 --no-cache-dir install --upgrade awscli

WORKDIR /var/www

