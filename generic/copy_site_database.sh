#!/bin/bash

#Exit if there are any errors:
set -e

function print_usage {

    echo "Usage $0 --db-master-user=<db master user> --db-master-pass=<db master pass> --old-db-user=[db user] --old-db-pass=[db pass]  --db-name=<db name> --old-site-user=<old site user> --old-site-ip=<old site ip> 

Copy a site from one stack to another.  Create a new site in idealstack, ssh to it and run this command.

OPTIONS
    --db-master-user    Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-master-pass:   Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-name :         Name of the mysql database you've created for this site
    --db-user :         Name of the database user for this site.  This user will be created on the new stack database automatically
    --db-pass :         Mysql password for this site. This user will be created on the new stack database automatically
    --old-site-user     The user for the old site (to connect over SSH)
    --old-site-ip       The IP address of the old site SSH
    "
    exit 1

}

TEMP=$(getopt  -o t --long db-name:,db-user:,db-pass:,db-master-user:,db-master-pass:,old-site-user:,old-site-ip: -n '$0' -- "$@")
eval set -- "$TEMP"
# extract options and their arguments into variables.
while true ; do
    case "$1" in
        --db-master-user) DB_MASTER_USER="$2" ; shift 2;;
        --db-master-pass) DB_MASTER_PASS="$2" ; shift 2;;
        --db-name) DB_NAME="$2" ; shift 2;;
        --db-user) DB_USER="$2" ; shift 2;;
        --db-pass) DB_PASS="$2" ; shift 2;;
        --old-site-user) OLD_SITE_USER="$2" ; shift 2;;
        --old-site-ip) OLD_SITE_IP_ADDRESS="$2" ; shift 2;;        
        --) shift ; break ;;
        *) echo "No such argument: $1" ; exit 1 ;;
    esac
done
echo "Copy site $OLD_SITE_USER@OLD_SITE_PASS DB: $DB_NAME";
if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ] || [ -z "$OLD_SITE_USER" ] || [ -z "$OLD_SITE_PASS" ] || [ -z "$DB_MASTER_USER" ] || [ -z "$DB_MASTER_PASS" ]; then
    print_usage
fi

echo "Creating database $DB_NAME"
mysqladmin -h database -u "$DB_MASTER_USER" --password="$DB_MASTER_PASS" create $DB_NAME

echo "Creating user $DB_USER"
mysql  -h database -u $DB_MASTER_USER --password=$DB_MASTER_PASS << EOQ
        GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
EOQ

#Dump the db
ssh -p 2223 $OLD_SITE_USER@$OLD_SITE_IP_ADDRESS  "mysqldump -h database -u $DB_USER --password=$DB_PASS $DB_NAME" | mysql -h database -u $DB_USER --password=$DB_PASS $DB_NAME

