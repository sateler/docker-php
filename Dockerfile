FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update && apt-get install -y \
	php7.2-mbstring \
	php7.2-intl \
	php7.2-json \
	php7.2-cli \
	php7.2-mysql \
	php7.2-curl \
	php7.2-gd \
	php7.2-xml \
	php7.2-zip \
	php7.2-xdebug \
	&& apt-get clean

RUN mkdir -p /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/metaZones.res /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/timezoneTypes.res /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/windowsZones.res /var/lib/ICU_tzdata/
ADD http://source.icu-project.org/repos/icu/data/trunk/tzdata/icunew/2018e/44/le/zoneinfo64.res /var/lib/ICU_tzdata/
RUN chmod -R +r /var/lib/ICU_tzdata/
ENV ICU_TIMEZONE_FILES_DIR=/var/lib/ICU_tzdata/

WORKDIR /srv/app/

CMD /usr/bin/php -v
