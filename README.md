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
Upstart script `apicatus.upstart` can be installed installed following the instrucctions below:

```sh
$ sudo npm install -g forever
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ sudo cp apicatus.upstart /etc/init/apicatus.conf
$ start apicatus
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
