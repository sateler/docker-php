FROM debian:wheezy

RUN apt-get update && apt-get install -y \
	apache2-mpm-prefork \
	apache2 \
	libapache2-mod-php5 \
	php5-mysql \
	php5-mcrypt \
	php5-curl \
	&& apt-get clean

RUN sed -i -e 's|^ErrorLog.*|ErrorLog /proc/self/fd/2|' /etc/apache2/apache2.conf


ADD default /etc/apache2/sites-available/

RUN a2ensite 000-default && a2enmod rewrite

WORKDIR /var/www/

CMD . /etc/apache2/envvars && exec apache2 -DFOREGROUND


