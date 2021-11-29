#!/bin/bash

# Formatting constants
RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# Env options
export PORT="${PORT:-8080}"
export LANG="${LANG:-en}"

# Clone down docs repo if our expected volume is empty
if ! [ "$(ls -A /docs)" ]; then
    echo -e "${BLUE}No docs found, Cloning down latest ${LANG} documentation from GitHub${NC}"
    git clone "https://github.com/php/doc-${LANG}.git" /docs
    chmod -R 777 /docs
fi

if [ ! "$LANG" == "en" ]; then
    echo -e "${BLUE}Fetching EN documentation from GitHub${NC}"
    git clone "https://github.com/php/doc-en.git" /phpdoc/en
fi

# Symlink docs into working directory
ln -s /docs "/phpdoc/$LANG"

# Build docs
docs_configure() {
    echo -e "${GREEN}Documentation configuring${NC}"
    errmsg=`php /phpdoc/doc-base/configure.php --with-lang=${LANG} 2>&1 > /dev/null`
    if [ ! -z "$errmsg" ]; then
        echo -e "${RED}Configuring complete with errors:${NC}"
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
rm -rf "/phpdoc/web-php/manual/$LANG" && ln -s /phpdoc/php-web "/phpdoc/web-php/manual/$LANG"

# Run initial build on startup
echo -e "${GREEN}Running initial ${LANG} build ${NC}"
docs_configure
docs_render

# Serve PHP site using built-in webserver
php -S "0.0.0.0:$PORT" -t /phpdoc/web-php /phpdoc/web-php/.custom-router.php > /dev/null 2>&1 &

# Define the user menu
menu="${BLUE}

================
PHP Docs Builder
================
Serving docs at: http://localhost:${PORT}/manual/${LANG}

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
        # Don't depend on configure before running render
        # since configure may complete with errors
        docs_configure
        docs_render
    fi
done