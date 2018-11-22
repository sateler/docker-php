FROM debian:stretch

RUN apt-get update && apt-get install -y \
	apache2 \
	libapache2-mod-php \
	php-mbstring \
	php-intl \
	php-json \
	php-cli \
	php-mysql \
	php-mcrypt \
	php-curl \
	php-gd \
	php-xml \
	php-zip \
	php-xdebug \
	&& apt-get clean

RUN sed -i -e 's|^ErrorLog.*|ErrorLog /proc/self/fd/2|' /etc/apache2/apache2.conf

RUN mkdir -p /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/metaZones.res /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/timezoneTypes.res /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/windowsZones.res /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/zoneinfo64.res /var/lib/ICU_tzdata/
RUN chmod -R +r /var/lib/ICU_tzdata/
ENV ICU_TIMEZONE_FILES_DIR=/var/lib/ICU_tzdata/

ADD default /etc/apache2/sites-available/000-default.conf
ADD mpm_prefork.conf /etc/apache2/conf.d/

RUN a2ensite 000-default && a2enmod rewrite

WORKDIR /var/www/

CMD . /etc/apache2/envvars && exec apache2 -DFOREGROUND


