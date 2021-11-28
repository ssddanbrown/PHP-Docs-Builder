FROM ubuntu:20.04
EXPOSE 8080

ARG DEBIAN_FRONTEND=noninteractive
RUN set -xe
RUN apt-get update -yqq && apt-get install -yqq git php7.4-cli php7.4-common php7.4-xml php7.4-sqlite3 php7.4-zip
RUN mkdir /phpdoc
# Clone the required projects
RUN git clone https://github.com/php/phd.git /phpdoc/phd
RUN git clone https://github.com/php/web-php.git /phpdoc/web-php
RUN git clone https://github.com/php/doc-base.git /phpdoc/doc-base
RUN git clone https://github.com/php/doc-en.git /phpdoc/en
# Build docs
RUN php /phpdoc/doc-base/configure.php
RUN php /phpdoc/phd/render.php --docbook /phpdoc/doc-base/.manual.xml \
    --package PHP --format php --output /phpdoc/

# Symlink docs
RUN rm -rf /phpdoc/web-php/manual/en && ln -s /phpdoc/php-web /phpdoc/web-php/manual/en

# Copy in our custom router to fix host/port
COPY .custom-router.php /phpdoc/web-php/.custom-router.php

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/phpdoc/web-php", "/phpdoc/web-php/.custom-router.php"]