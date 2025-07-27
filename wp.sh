#!/bin/bash

# Usage: ./wp-path-checker.sh site.com

# Check if domain is passed
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

# List of paths to check
paths=(
    "/wp-json/wp/v2/users"
    "/wp-json/?rest_route=/wp/v2/users/"
    "/wp-json/?rest_route=/wp/v2/users/n"
    "/index.php?rest_route=/wp-json/wp/v2/users"
    "/index.php?rest_route=/wp/v2/users"
    "/author-sitemap.xml"
    "/wp-content/debug.log"
    "/wp-content/plugins/mail-masta/"
    "/wp-content/plugins/mail-masta/inc/campaign/count_of_send.php?pl=/etc/passwd"
    "/wp-content/uploads/wp-file-manager-pro/fm_backup/"
    "/wp-login.php?action=register"
    "/wp-admin/login.php"
    "/wp-admin/wp-login.php"
    "/login.php"
    "/wp-login.php"
    "/wp-config.php"
    "/wp-config.php_"
    "/wp-config.php.BAK"
    "/tox.ini"
    "/wp-includes/rest-api/endpoints/class-wp-rest-posts-controller.php"
    "/wp-content/uploads/"
    "/wp-content/UPLOADS/"
    "/wp-content/UpLoAds/"
)

echo "Checking WordPress paths for: $DOMAIN"
echo

for path in "${paths[@]}"; do
    url="https://${DOMAIN}${path}"
    status=$(curl -k -o /dev/null -s -w "%{http_code}" "$url")
    echo "$url -> HTTP $status"
done