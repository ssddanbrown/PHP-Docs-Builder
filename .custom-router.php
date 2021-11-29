<?php

// This custom router exists to provide control over the host and port
// to align the site's variables to that which the container host
// is intending to use.

$port = intval(getenv('PORT') ?: 8080);
$_SERVER["SERVER_ADDR"] = 'localhost:' . $port;
$_SERVER['SERVER_NAME'] = 'localhost';
$_SERVER['SERVER_PORT'] = $port;

$filename = isset($_SERVER["PATH_INFO"]) ? $_SERVER["PATH_INFO"] : $_SERVER["SCRIPT_NAME"];

if (file_exists($_SERVER["DOCUMENT_ROOT"] . $filename)) {
    /* This could be an image or whatever, so don't try to compress it */
    ini_set("zlib.output_compression", 0);
    return false;
}

include_once "error.php";