#!/bin/bash

# Clone down docs repo if our expected volume is empty
if ! [ "$(ls -A /docs)" ]; then
    git clone https://github.com/php/doc-en.git /docs
    chmod -R 777 /docs
fi

# Symlink docs into working directory
ln -s /docs /phpdoc/en

# Build docs
docs_configure() {
    php /phpdoc/doc-base/configure.php
}
docs_render() {
    php /phpdoc/phd/render.php \
    --docbook /phpdoc/doc-base/.manual.xml \
    --package PHP \
    --format php \
    --output /phpdoc/
}
#docs_configure
#docs_render

# Symlink built docs into website
rm -rf /phpdoc/web-php/manual/en && ln -s /phpdoc/php-web /phpdoc/web-php/manual/en

# Serve PHP site using built-in webserver
php -S 0.0.0.0:8080 -t /phpdoc/web-php /phpdoc/web-php/.custom-router.php > /dev/null 2>&1 &

# Provide user menu for next action to run
while true
do
    read -n 1 -s -r -p $'Press key to (c)onfigure, (r)ender, (b)uild or (q)uit:\n' key
    if [ "$key" == 'c' ]; then
        docs_configure
    elif [ "$key" == 'r' ]; then
        docs_render
    elif [ "$key" == 'q' ]; then
        exit 0
    elif [ "$key" == 'b' ]; then
        docs_configure
        docs_render
    fi
done