#!/bin/bash

DB_NAME=$1
DB_USER=$2
DB_PASS=$3
URL=$4
TITLE=$5
ADMIN_USER=$6
ADMIN_EMAIL=$7
ADMIN_PASS=$8

if [ -z $ADMIN_EMAIL ]; then
    echo "Usage $0 <db name> <db user> <db pass> <url> <title> <admin user> <admin email> [admin pass]

Options:
    db name : Name of the mysql database you've created for this site
    db user : Name of the database user for this site
    db pass : Mysql password for this site
    URL     : URL for the wordpress site
    Title   : Title for the wordpress site
    Admin Email:    Email address of the admin user of the site
    Admin Pass :    (Optional) Admin password for the site.  If omitted a random password will be generated    
    "
    exit 1
fi

curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mkdir ~/bin
mv wp-cli.phar ~/bin/wp

cd ~/public_html
wp core download #Download wordpress

#Generate a random table prefix.  This is a good security enhancement
PREFIX=wp_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 11 | head -n 1)_

#Create a configuration file.
wp config create  --dbhost=database --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbprefix=$PREFIX
wp core install --url=$URL --title="$TITLE" --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASS --admin_email=$ADMIN_EMAIL

#wp plugin install --activate w3-total-cache