FROM ubuntu:latest

RUN apt-get update && apt-get install -y software-properties-common language-pack-en-base \
    && LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
	&& apt-get install -y php5.6-fpm php5.6-cli php5.6-curl \
	php5.6-json \
	php5.6-mcrypt \
    php5.6-bcmath \
	php-memcache \
	php-memcached \
	php-mysqlnd-ms \
	php5.6-mysql \
	php-redis \
	php5.6-sqlite3 \
	php-stomp \
	php5.6-intl \
	php5.6-pgsql \
	php-xdebug \
    php5.6-gd \
	php5.6-dev \
	php-pear \
	wkhtmltopdf \
	xvfb \
	sendmail supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y supervisor
COPY ./conf/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt-get update && apt-get install -y nginx

RUN sed -i -e 's/listen = \/run\/php\/php5.6-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/5.6/fpm/pool.d/www.conf \
    && sed -i -e 's/;daemonize = yes/daemonize = no/g' /etc/php/5.6/fpm/php-fpm.conf

# Creates a launcher for wkhtmltopdf under xvfb
RUN echo 'xvfb-run -- /usr/bin/wkhtmltopdf "${@:-}"' > /usr/local/bin/wkhtmltopdf && \
	chmod +x /usr/local/bin/wkhtmltopdf

COPY ./conf/php/cli-php.ini /etc/php/5.6/cli/php.ini
#COPY ./conf/php/php-fpm.conf /etc/php/5.6/fpm/php-fpm.conf
COPY ./conf/php/php.ini /etc/php/5.6/fpm/php.ini
COPY ./conf/php/www.conf /etc/php/5.6/fpm/pool.d/www.conf
ADD ./conf/nginx/fastcgi_params /etc/nginx/fastcgi_params

# removing deb files
RUN apt-get clean

EXPOSE 80

CMD ["/usr/bin/supervisord"]