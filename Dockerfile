FROM debian:wheezy

RUN apt-get update && apt-get install -y \
	libapache2-mod-php5 \
	apache2-mpm-prefork \
	apache2 \
	&& apt-get clean

RUN a2ensite 000-default

WORKDIR /var/www/html

CMD . /etc/apache2/envvars && exec apache2 -DFOREGROUND


