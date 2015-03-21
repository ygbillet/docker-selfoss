FROM php:5.6-apache
MAINTAINER Jens Erat <email@jenserat.de>

# Remove SUID programs
RUN for i in `find / -perm +6000 -type f`; do chmod a-s $i; done

# selfoss requirements: mod-headers, mod-rewrite, gd
RUN a2enmod headers rewrite && \
    apt-get update && \
    apt-get install -y unzip && \
    apt-get install -y libpng12-dev && \
    docker-php-ext-install gd && \
    rm -r /var/lib/apt/lists/*

WORKDIR /var/www/html
RUN curl -L https://github.com/SSilence/selfoss/releases/download/2.12/selfoss-2.12.zip -o selfoss-2.12.zip && \
    unzip selfoss-*.zip && \
    mv defaults.ini data/config.ini && \
    ln -s data/config.ini config.ini && \
    rm selfoss-*.zip && \
    chown -R www-data:www-data /var/www/html

# Extend maximum execution time, so /refresh does not time out
COPY php.ini /usr/local/etc/php/

VOLUME /var/www/html/data
