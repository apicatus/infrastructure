infrastructure
==============

Service setup (nginx, crontab, bashrc, etc...)

## Debian Setup

```sh
$ sudo apt-get install nodejs mongodb nginx
$ npm install
$ bower install
$ grunt watch
```

## NginX

```sh
$ git-clone https://github.com/apicatus/infrastructure.git
$ cd infrastructure
$ sudo cp ./apicatus.nginx /etc/nginx/sites-available/<yoursite>
$ sudo service nginx restart
```

