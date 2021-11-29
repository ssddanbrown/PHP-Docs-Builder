#!/bin/bash

# Formatting constants
RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# Env options
export PORT="${PORT:-8080}"

# Clone down docs repo if our expected volume is empty
if ! [ "$(ls -A /docs)" ]; then
    echo -e "${BLUE}No docs found, Cloning down latest documentation from GitHub${NC}"
    git clone https://github.com/php/doc-en.git /docs
    chmod -R 777 /docs
fi

# Symlink docs into working directory
ln -s /docs /phpdoc/en

# Build docs
docs_configure() {
    echo -e "${GREEN}Documentation configuring${NC}"
    errmsg=`php /phpdoc/doc-base/configure.php 2>&1 > /dev/null`
    if [ ! -z "$errmsg" ]; then
        echo -e "${RED}Configuring failed. Error:${NC}"
        echo -e "$errmsg"
        return 1
    else
        echo -e "${GREEN}Configuring complete ${NC}"
        return 0
    fi
}
docs_render() {
    echo -e "${GREEN}Rendering documentation ${NC}"
    errmsg=`php /phpdoc/phd/render.php \
    --docbook /phpdoc/doc-base/.manual.xml \
    --package PHP \
    --format php \
    --output /phpdoc/ 2>&1 > /dev/null`

    if [ ! -z "$errmsg" ]; then
        echo -e "${RED}Rendering failed. Error: ${NC}"
        echo -e "$errmsg"
        return 1
    else
        echo -e "${GREEN}Rendering complete ${NC}"
        return 0
    fi
    
}

# Symlink built docs into website
rm -rf /phpdoc/web-php/manual/en && ln -s /phpdoc/php-web /phpdoc/web-php/manual/en

# Serve PHP site using built-in webserver
php -S "0.0.0.0:$PORT" -t /phpdoc/web-php /phpdoc/web-php/.custom-router.php > /dev/null 2>&1 &

# Define the user menu
menu="${BLUE}

Press a key to perform an action:
${BLUE}- (${MAGENTA}b${BLUE})uild         ${NC}- Run both configure and render steps.
${BLUE}- (${MAGENTA}c${BLUE})onfigure     ${NC}- Validates and prepares the documentation XML.
${BLUE}- (${MAGENTA}r${BLUE})ender        ${NC}- Render the docs to PHP for display.
${BLUE}- (${MAGENTA}q${BLUE})uit          ${NC}- Quit this builder application.
${NC}
"

# Show the user menu between jobs
while true
do
    echo -e "$menu"
    read -n 1 -s -r -p $"" key
    if [ "$key" == 'c' ]; then
        docs_configure
    elif [ "$key" == 'r' ]; then
        docs_render
    elif [ "$key" == 'q' ]; then
        exit 0
    elif [ "$key" == 'b' ]; then
        docs_configure && docs_render
    fi
done