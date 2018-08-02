# Wordpress Tools


# install_wordpress.sh
This script installs the latest version of wordpress using WP-CLI.  You can also customise it to automatically install and activate themes and make any other
changes you can make using WP-CLI.

How to use:
- Create a site in Idealstack
- Create a database in Idealstack for the site
- Run the command like this: 

````
#If running it over ssh on an idealstack site
curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/wordpress/install_wordpress.sh | bash -s -- <arguments>

#Or run it on your local machine like this:
ssh -p 2223 <idealstack user>@<idealstack ip> 'curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/wordpress/install_wordpress.sh | bash -s -- <arguments>'
````

## Arguments

````
    --db-master-user    (optional) Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-master-pass:   (optional) Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-name :         Name of the mysql database you've created for this site
    --db-user :         Name of the database user for this site
    --db-pass :         Mysql password for this site
    --url     :         URL for the wordpress site
    --title :           Title for the wordpress site
    --admin-email:      Email address of the admin user of the site
    --admin-pass:       (Optional) Admin password for the site.  If omitted a random password will be generated  

````

## Examples


````
ssh -p 2223 test1@52.41.208.161 'curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/wordpress/install_wordpress.sh | bash -s -- wordpress1 wordpress1 wordpress1 http://test1.dxp32qvm517.jon.idealstack.net "Example Site" admin test@example.com fg3cclkas '

````

Example Output:

````
$ ssh -p 2223 test1@52.41.208.161 'curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/ma ster/wordpress/install_wordpress.sh | bash -s -- wordpress1 wordpress1 wordpress1 http://test1.dxp32qvm517.jon.id ealstack.net "Example Site" admin test@example.com fg3cclkas '
Warning: Permanently added '[10.12.1.39]:32770' (ECDSA) to the list of known hosts.
Downloading WordPress 4.9.7 (en_US)...
md5 hash verified: 50efc5822bf550e9a526b9b9f4469b0d
Success: WordPress downloaded.
Success: Generated 'wp-config.php' file.
Success: WordPress installed successfully.
````

## Customising
If you are planning to use this script as part of your own deployment scripts, we recomending forking and adding it to your own github repository.  Update the url in the examples above to use the correct raw url.  You can also use gist.github.com in the same way
