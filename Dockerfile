FROM debian:wheezy

RUN apt-get update && apt-get install -y \
	libapache2-mod-php5 \
	apache2-mpm-prefork \
	apache2 \
	&& apt-get clean

# common modules
RUN apt-get install -y \
	php5-mysql \
	php5-mcrypt \
	php5-curl \
	&& apt-get clean

ADD default /etc/apache2/sites-available/

RUN a2ensite 000-default
RUN a2enmod rewrite

WORKDIR /var/www/html

CMD . /etc/apache2/envvars && exec apache2 -DFOREGROUND


