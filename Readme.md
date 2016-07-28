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
$ docker run --name roundcube -p 80:80 -p 443:443 --link mydb:mydb -d filhocf/roundcube
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

## Plugins bundle

This image also add the follow plugins:
### Roundcube Webmail ContextMenu
This plugin creates contextmenus for various parts of Roundcube using commands from the toolbars.
https://github.com/JohnDoh/Roundcube-Plugin-Context-Menu

### message_highlight
With this plugin you can colorize the message index rows based on specific criteria like sender, recipient and subject.
https://github.com/corbosman/message_highlight

### Roundcube-Plugin-Infinite-Scroll
Remove nav page for messages and support infinite scroll in the message list https://github.com/messagerie-melanie2/Roundcube-Plugin-Infinite-Scroll

### Roundcube Webmail ThreeCol
This plugin adds an option to the mailbox settings to enable the user to display the preview pane either to the right had side of the message list or below it. https://github.com/EstudioNexos/threecol

### Thunderbird Labels Plugin for Roundcube Webmail
Displays the message rows using the same colors as Thunderbird does
Label of a message can be changed/set exactly like in Thunderbird
Keyboard shortcuts on keys 0-5 work like in Thunderbird
Integrates into contextmenu plugin when available
Works for skins classic and larry
https://github.com/mike-kfed/rcmail-thunderbird-labels

### Roundcube Webmail RemoveAttachments
This plugin adds an option to remove one or more attachments from a message.
https://github.com/dsoares/Roundcube-Plugin-RemoveAttachments

### Roundcube Plugin attachment_position
This plugin adds an option to Roundcube mail that adds a setting allowing users to choose where the attachment upload pane should appear when composing a message.
https://github.com/dapphp/Roundcube-Plugin-attachment_position

### Roundcube plugin - Keyboard Shortcuts NG
Plugin that enables keyboard shortcuts, and makes associations configurable by Roundcube admin.
https://github.com/teonsystems/roundcube-plugin-keyboard-shortcuts-ng

### CalDAV/iCAL Support for Roundcube Calendar
This repository was forked from roundcubemail-plugins-kolab and contains a modified version of the Roundcube calendar plugin that enables client support for CalDAV and iCAL calendar resources. We added a feature branch feature_caldav with the modified calendar plugin and we try to frequently merge the latest release tags from upstream. You can find further information and a short introduction to this plugin on our website.
https://gitlab.awesome-it.de/kolab/roundcube-plugins

And the follow themes:

### Mabola: Skin for Roundcube Webmail
Mabola is a clean and usable skin for latest Roundcube Webmail (http://roundcube.net). Is based on Material Design, Bootstrap and inherits from Larry Skin, so there should be no unstyled content. Also blue version.
https://github.com/EstudioNexos/mabola-blue
https://github.com/EstudioNexos/mabola

## More Info

About RoundCube Mail: [roundcube.net][1]

To help improve this container [docker-roundcube][5]


[1]:https://roundcube.net/
[2]:https://www.docker.com
[3]:https://docs.docker.com/engine/installation/linux/
[4]:http://docs.docker.com
[5]:https://github.com/filhocf/docker-roundcube
