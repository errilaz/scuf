#!/bin/bash
path=$1; shift
[ -z "$path" ] && echo "Error: path required" && exit 1
export SCUF_WS=$(realpath "$path")
[ -d "$SCUF_WS" ] && echo "Error: path already exists: $SCUF_WS" && exit 1
abbr=$(basename "$SCUF_WS")

read -e -p "Site name: " SITE_NAME
read -e -p "Project abbreviation: " -i "$abbr" SITE_PROJECT
read -e -p "Development domain: " -i "$SITE_PROJECT.local" SITE_DOMAIN_DEV
read -e -p "Production domain: " -i "example.com" SITE_DOMAIN_PROD

mkdir -p "$SCUF_WS"
base=$SCUF_WS/base.scuf
dev=$SCUF_WS/dev.scuf
prod=$SCUF_WS/prod.scuf

# Base
echo "[scuf]

compose = base.compose

[site]

name = \"$SITE_NAME\"
project = \"$SITE_PROJECT\"
domain = \"$SITE_DOMAIN_DEV\"
email = \"admin@$SITE_DOMAIN_DEV\"
data = \"/$SITE_PROJECT/data\"

[db]

name = \"$SITE_PROJECT\"
user = \"postgres\"
pass = \"postgres\"

[smtp]

host = \"localhost\"
port = 3600
user = \"admin\"
pass = \"admin\"

[publish]

host = \"$SITE_DOMAIN_PROD\"
user = \"$USER\"
path = \"/$SITE_PROJECT\"
" > "$base"  

# Dev
echo "[scuf]

compose = dev.compose

[site]

data = \"$SCUF_WS/data\"
" > "$dev"

# Prod
echo "[site]

domain = \"$SITE_DOMAIN_PROD\"
email = \"admin@$SITE_DOMAIN_PROD\"

[db]

pass = \"CHANGE_ME\"

[api]

pass = \"CHANGE_ME\"

[smtp]

host = \"CHANGE_ME\"
port = 25
user = \"CHANGE_ME\"
pass = \"CHANGE_ME\"
" > "$prod"