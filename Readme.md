# docker-roundcube

Docker container for [roundcube][1]

> Roundcube webmail is a browser-based multilingual IMAP client with an application-like user interface. It provides full functionality you expect from an email client, including MIME support, address book, folder manipulation, message searching and spell checking.


## Install dependencies

  - [Docker][2]

To install docker in a Linux flavor [follow this instructions][3].

To install docker in other operating systems check [docker online documentation][4]

## Usage

Roundcube need a database server to run, so you need to install it and create a
user and database. To this, the suggestion is to use docker image of MySQL[5].
Process the follow steps:

```
$ docker run --name mydb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
$ docker exec -it mydb
<docker_mydb>$ mysql -p #password: my-secret-pw
mysql> CREATE DATABASE roundcubemail;
mysql> GRANT ALL PRIVILEGES ON roundcubemail.* TO username@localhost IDENTIFIED BY 'password';
mysql> FLUSH PRIVILEGES;
```
To run container use the command below:
```
$ docker run --name roundcube -p 80:80 -p 443:443 --link mydb:mydb filhocf/roundcube
```

To first time, you can access the installer and setting your parameters like IMAP and
SMTP server, database, activated plugins, etc. To access the installer, point your browser
to https://<ip_or_name_of_roundcube_docker>/installer.

You also can set your settings using the follow envirounment variables using '-e <variable>'
in the 'docker run' command:

```
PROXY_PKG=                 # Format: http[s]://<name_or_ip>[:<port>]
PROXY_HTTP=                # Format: http[s]://<name_or_ip>[:<port>]
RCMAIL_USER=roundcube 
RCMAIL_PASS=roundcube 
RCMAIL_HOST=db 
RCMAIL_DB=roundcubemail 
RCMAIL_IMAP=localhost      # Format: [imap|imaps|tls|ssl]://<ip_or_name_imap_host>
RCMAIL_SMTP=localhost      # Format: [smtp|smtps|tls|ssl]://<ip_or_name_smtp_host>
```

## More Info

About RoundCube Mail: [roundcube.net][1]

To help improve this container [docker-roundcube][5]


[1]:https://roundcube.net/
[2]:https://www.docker.com
[3]:https://docs.docker.com/engine/installation/linux/
[4]:http://docs.docker.com
[5]:https://github.com/filhocf/docker-roundcube
