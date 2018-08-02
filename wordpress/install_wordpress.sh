#!/bin/bash

#Exit if there are any errors:
set -e

function print_usage {

    echo "Usage $0 --db-master-user=[master db user] --db-master-pass=[master db pass]  --db-name=<db name> --db-host=<db user> --db-pass=<db pass> --url=<url> --title=<title> --admin-user=<admin user> --admin-email=<admin email> --admin-pass=[admin pass]

OPTIONS
    --db-master-user    (optional) Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-master-pass:   (optional) Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-name :         Name of the mysql database you've created for this site
    --db-user :         Name of the database user for this site
    --db-pass :         Mysql password for this site
    --url     :         URL for the wordpress site
    --title :           Title for the wordpress site
    --admin-email:      Email address of the admin user of the site
    --admin-pass:       (Optional) Admin password for the site.  If omitted a random password will be generated    
    "
    exit 1

}

TEMP=$(getopt  -o t --long db-name:,db-user:,db-pass:,db-master-user:,db-master-pass:,url:,title:,admin-user:,admin-email:,admin-pass: -n '$0' -- "$@")
eval set -- "$TEMP"
# extract options and their arguments into variables.
while true ; do
    case "$1" in
        --db-master-user) DB_MASTER_USER="$2" ; shift 2;;
        --db-master-pass) DB_MASTER_PASS="$2" ; shift 2;;
        --db-name) DB_NAME="$2" ; shift 2;;
        --db-user) DB_USER="$2" ; shift 2;;
        --db-pass) DB_PASS="$2" ; shift 2;;
        --url) URL="$2" ; shift 2;;
        --title) TITLE="$2" ; shift 2;;
        --admin-user) ADMIN_USER="$2" ; shift 2;;
        --admin-email) ADMIN_EMAIL="$2" ; shift 2;;
        --admin-pass) ADMIN_PASS="$2" ; shift 2;;
        --) shift ; break ;;
        *) echo "No such argument: $1" ; exit 1 ;;
    esac
done
echo "Create WP site $URL <$TITLE> (User $ADMIN_USER) on db $DB_NAME MASTER_USER:$DB_MASTER_USER";
if [ -z "$DB_NAME" ] || [ -z "$URL" ] || [ -z "$TITLE" ] || [ -z "$ADMIN_USER" ] || [ -z "$ADMIN_PASS" ]; then
    print_usage
fi

if [ ! -z "$DB_MASTER_USER" ] && [ ! -z "$DB_MASTER_PASS" ]; then
    echo "Creating database $DB_NAME"
    mysqladmin -h database -u "$DB_MASTER_USER" --password="$DB_MASTER_PASS" create $DB_NAME
    mysql  -h database -u $DB_MASTER_USER --password=$DB_MASTER_PASS << EOQ
        GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
EOQ

fi

# Install WP-CLI
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mkdir -p ~/bin
export PATH=$PATH:~/bin
mv wp-cli.phar ~/bin/wp

cd ~/public_html

#Download wordpress
wp core download 

#Generate a random table prefix.  This is a good security enhancement
PREFIX=wp_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 11 | head -n 1)_

#Create a configuration file.
wp config create  --dbhost=database --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbprefix=$PREFIX
wp core install --url=$URL --title="$TITLE" --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASS --admin_email=$ADMIN_EMAIL

#Example of how to install plugins:
#wp plugin install --activate w3-total-cache

#Example of how to install themes
#wp theme install --activate twentysixteen