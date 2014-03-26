Infrastructure
==============
Below is a quick how-to setup the application on a Debian or Ubuntu box 
****

## Debian Setup

```sh
$ sudo apt-get update
$ sudo apt-get install nodejs mongodb nginx
```

## Node CLI tools
Make sure you have the latest NPM version availabe

```sh
$ sudo npm install -g gulp
$ sudo npm install -g forever
```

## Clone repo and install

```sh
$ git-clone https://github.com/apicatus/backend.git
$ cd backend
$ npm install
```

## Install nginx
NginX proxies two services, a landing site (no nessesary for development) and the API service. It also service all static content for the SPA
The landing site uses port 3000 and the API uses 8080 (configurable via config.js)

```sh
$ sudo apt-get install nginx
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ sudo cp ./apicatus.nginx /etc/nginx/sites-available/<yoursite>
$ sudo ln -s /etc/nginx/sites-available/<yoursite> /etc/nginx/sites-enabled/<yoursite>
$ sudo service nginx restart
```

# Running Apicatus as a service:
The application can be run as a service, directly from the command line or while developing by running `$ gulp develop`
There are mainly two ways to run it as a service all of whom require node monitor `forever` (link somewhere)
Make sure you modify the variables according to your onw configuration !

## Sysem V init
Init script `apicatus.server.sh` can be installed installed following the instrucctions below:

```sh
$ sudo npm install -g forever
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ sudo cp apicatus.server.sh /etc/init.d/apicatus
$ sudo update-rc.d apicatus defaults
$ sudo service apicatus start
```

## Upstart (Ubuntu & others)
Upstart script `apicatus.upstart` relies on forever to deamonize the service, make sure you change the $DEAMON variable inside the upstart script to target your service start/stop routines.

```sh
$ sudo npm install -g forever
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ cp apicatus.server.sh /<app-source>/apicatus.server.sh
$ sudo cp apicatus.upstart /etc/init/apicatus.conf
$ sudo initctl reload-configuration
$ start apicatus
```

## Log Rotation
The application logs all it's activity to `/var/log/apicatus` (by default), to keep things clean there is a logrotate configuration: `apicatus.logrotate`, to use it just:

```sh
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ sudo cp apicatus.logrotate /etc/logrotate.d/apicatus
```

## Complete Uninstall

```sh
$ sudo service apicatus stop 
$ sudo update-rc.d -f apicatus remove
$ sudo rm /etc/init.d/apicatus
$ sudo npm remove -g gulp
$ sudo npm remove -g forever
$ sudo apt-get remove node
$ service nginx stop
$ sudo unlink /etc/nginx/sites-enabled/<yoursite>
$ sudo rm /etc/nginx/sites-available/<yoursite>
$ sudo apt-get remove nginx
$ sudo mongod stop
$ sudo dpkg -r mongodb
```
