infrastructure
==============

Service setup (nginx, crontab, bashrc, etc...)

## Debian Setup

```sh
$ sudo apt-get update
$ sudo apt-get install nodejs mongodb nginx
```

## NginX

NginX proxies two services, a landing site (no nessesary for development) and the API service.
The landing site uses port 3000 and the API uses 8080

```sh
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ sudo cp ./apicatus.nginx /etc/nginx/sites-available/<yoursite>
$ sudo service nginx restart
```

## Uninstall

```sh
$ sudo dpkg -r node
$ service nginx stop
$ sudo dpkg -r nginx
```
