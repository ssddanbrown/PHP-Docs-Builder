FROM ubuntu:20.04
EXPOSE 8080

ARG DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN set -xe
RUN apt-get update -yqq && apt-get install -yqq php7.4-cli \
   php7.4-common php7.4-xml php7.4-sqlite3 php7.4-zip \
   git

# Create our working directory and docs directory
RUN mkdir /phpdoc /docs

# Clone the required projects
RUN git clone https://github.com/php/phd.git /phpdoc/phd
RUN git clone https://github.com/php/web-php.git /phpdoc/web-php
RUN git clone https://github.com/php/doc-base.git /phpdoc/doc-base

# Copy in our init script and custom router
COPY init.sh /phpdoc/init.sh
COPY .custom-router.php /phpdoc/web-php/.custom-router.php
RUN chmod +x /phpdoc/init.sh

# Setup /docs as a volume
VOLUME /docs

CMD ["/phpdoc/init.sh"]