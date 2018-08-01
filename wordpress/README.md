# Wordpress Tools


# install_wordpress.sh

How to use:
    - Create a site in Idealstack
    - Create a database in Idealstack for the site
    - Run the command like this: ```
ssh -p 2223 <idealstack user>@<idealstack ip> 'curl -s  https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/wordpress/install_wordpress.sh | bash -s -- <arguments>'
```

eg 
```
ssh -p 2223 test1@52.41.208.161 'curl https://raw.githubusercontent.com/Idealstack/idealstack-user-tools/master/wordpress/install_wordpress.sh | bash -s -- wordpress1 wordpress1 wordpress1 http://test1.dxp32qvm517.jon.idealstack.net admin fg3cclkas '

```