FROM php:7.2-apache-stretch

# PHP Extension Requirements
RUN apt-get update && apt-get install -y \
    # for php pdo_dblib
    freetds-dev \
    # For php-intl
    libicu-dev \
    openssh-client \
    # For gd
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    # For php-soap
    libxml2-dev \
    && apt-get clean \
    && pecl install xdebug

# for php pdo_dblib
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a

# Configure and install or enable extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) intl pdo_mysql gd zip soap pdo_dblib calendar bcmath \
    && docker-php-ext-enable xdebug

# Add newer icu txdata res
COPY ./icu2019a44le /icu2019a44le
ENV ICU_TIMEZONE_FILES_DIR /icu2019a44le

# Apache
ADD default /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default && a2enmod rewrite
WORKDIR /var/www/
CMD . /etc/apache2/envvars && exec apache2 -DFOREGROUND

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer