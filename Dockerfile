FROM php:7.2-cli

# PHP Extension Requirements
RUN apt-get update && apt-get install -y \
    # for php pdo_dblib (sybase)
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

# for php pdo_dblib (sybase)
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a

# Configure and install or enable extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) intl pdo_mysql gd zip soap pdo_dblib calendar \
    && docker-php-ext-enable xdebug
