# Generic Tools

# copy_site_database.sh

Copy a database and it's user from one Idealstack stack to another

The only tricky thing is you need to run an ssh-agent on your computer.  On "unix like"systems (linux, macos, windows-subsystem-for-linux or cygwin) that should be as simple as 'eval `ssh-agent`' and making sure you have the -A option to ssh (eg ssh -A -p 2223 <is user>@<is ip>).  If you are ssh'ing with putty or kitty on windows you run 'pageant' and import your key, and make sure ssh agent forwarding is turned on


````
#If running it over ssh on an idealstack site
curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/generic/copy_site.sh | bash -s -- <arguments>

#Or run it on your local machine like this:
ssh -p 2223 <idealstack user>@<idealstack ip> 'curl -s https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/generic/copy_site.sh | bash -s -- <arguments>'
````

## Arguments

````
    --db-master-user    Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-master-pass:   Master user for the database server.  If passed, the db user, pass and database for wordpress will be created automatically
    --db-name :         Name of the mysql database you've created for this site
    --db-user :         Name of the database user for this site.  This user will be created on the new stack database automatically
    --db-pass :         Mysql password for this site. This user will be created on the new stack database automatically
    --old-site-user     The user for the old site (to connect over SSH)
    --old-site-ip       The IP address of the old site SSH

````

## Examples


````
#Run SSH Agent : this assumes both old and new sites have the same ssh key, it will then forward that key securely onto the other site
eval `ssh-agent`

ssh -A -p 2223 test2@52.41.208.161 'curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/generic/copy_site_database.sh | bash -s -- --db-master-user=masterdb --db-master-pass='*#9!fI9zPv+rxtlu-si3Mq[R3N^Wvof2' --db-name=wordpress1 --db-user=wordpress1 --db-pass=wordpress1 --old-site-user=test444 --old-site-ip=31.23.4.22 '

````

## Customising
If you are planning to use this script as part of your own deployment scripts, we recomending forking and adding it to your own github repository.  Update the url in the examples above to use the correct raw url.  You can also use gist.github.com in the same way

# Copy site files
Copying the files of a site is easy enough that it doesn't need a script

```
#Ensure SSH agent is running
eval `ssh-agent`

#SSH to the new site
ssh -A -p 2223 newsite@52.41.208.161 

#Copy the files
scp olduser@31.23.4.22:~/public_html/* public_html/ 

```

