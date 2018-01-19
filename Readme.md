# docker-roundcube

Docker container for [Roundcube Mail](https://roundcube.net/)

> Roundcube webmail is a browser-based multilingual IMAP client with an application-like user interface. It provides full functionality you expect from an email client, including MIME support, address book, folder manipulation, message searching and spell checking.

This package runs Roundcube over Nginx and PHP-FPM.

## Install dependencies

### Docker

To install docker in a Linux flavor [follow this instructions](https://docs.docker.com/engine/installation/linux/).

To install docker in other operating systems check [docker online documentation](http://docs.docker.com)


## Usage

The simplest method is to run the official image:

```
docker run -e ROUNDCUBEMAIL_DEFAULT_HOST=mail -d roundcube/roundcubemail
```

### Configuration/Environment Variables

The following env variables can be set to configure your Roundcube Docker instance:

`ROUNDCUBEMAIL_DEFAULT_HOST` - Hostname of the IMAP server to connect to

`ROUNDCUBEMAIL_DEFAULT_PORT` - IMAP port number; defaults to `143`

`ROUNDCUBEMAIL_SMTP_SERVER` - Hostname of the SMTP server to send mails

`ROUNDCUBEMAIL_SMTP_PORT`  - SMTP port number; defaults to `587`

`ROUNDCUBEMAIL_PLUGINS` - List of built-in plugins to activate. Defaults to `archive,attachment_position,contextmenu,contextmenu_folder,message_highlight,infinite_scroll,html5_notifier,thunderbird_labels,remove_attachments,zipdownload`


By default, the image will use a local SQLite database for storing user account metadata.
It'll be created inside the `/var/www/html` volume and can be backed up from there. Please note that
this option should not be used for production environments.

### Connect to a MySQL Database

The recommended way to run Roundcube is connected to a MySQL database. Specify the following env variables to do so:

`ROUNDCUBEMAIL_DB_TYPE` - Database provider; currently supported: `mysql`, `pgsql`, `sqlite`

`ROUNDCUBEMAIL_DB_HOST` - Host (or Docker instance) name of the database service; defaults to `mysql` or `postgres` depending on linked containers.

`ROUNDCUBEMAIL_DB_USER` - The database username for Roundcube; defaults to `root` on `mysql`

`ROUNDCUBEMAIL_DB_PASSWORD` - The password for the database connection

`ROUNDCUBEMAIL_DB_NAME` - The database name for Roundcube to use; defaults to `roundcubemail`

Before starting the container, please make sure that the supplied database exists and the given database user
has privileges to create tables.

Run it with a link to the MySQL host and the username/password variables:

```
docker run --link=mysql:mysql -d roundcube/roundcubemail
```

### Advanced configuration

Apart from the above described environment variables, the Docker image also allows to add custom config files
which are merged into Roundcube's default config. Therefore the image defines a volume `/var/roundcube/config`
where additional config files (`*.php`) are searched and included. Mount a local directory with your config
files - check for valid PHP syntax - when starting the Docker container:

```
docker run -v ./config/:/var/roundcube/config/ -d filhocf/roundcubemail
```

Check the RoundCube wiki for a reference of [Roundcube config options](https://github.com/roundcube/roundcubemail/wiki/Configuration).


## Plugins bundle

This image also add the follow plugins:

### Roundcube Webmail ContextMenu
This plugin creates contextmenus for various parts of Roundcube using commands from the toolbars.
https://github.com/johndoh/roundcube-contextmenu

### message_highlight
With this plugin you can colorize the message index rows based on specific criteria like sender, recipient and subject.
https://github.com/corbosman/message_highlight

### Roundcube-Plugin-Infinite-Scroll
Remove nav page for messages and support infinite scroll in the message list.
https://github.com/messagerie-melanie2/Roundcube-Plugin-Infinite-Scroll

### Thunderbird Labels Plugin
Displays the message rows using the same colors as Thunderbird does Label of a message can be changed/set exactly like in Thunderbird Keyboard shortcuts on keys 0-5 work like in Thunderbird Integrates into contextmenu plugin when available Works for skins classic and larry
https://github.com/mike-kfed/rcmail-thunderbird-labels

### Roundcube Webmail RemoveAttachments
This plugin adds an option to remove one or more attachments from a message.
https://github.com/dsoares/Roundcube-Plugin-RemoveAttachments

### Roundcube Plugin attachment_position
This plugin adds an option to Roundcube mail that adds a setting allowing users to choose where the attachment upload pane should appear when composing a message.
https://github.com/dapphp/roundcube-attachment-position

### HTML5 Notifier
It displays Desktop Notifications like the ones you might know from Google Mail. Just keep Roundcube opened in a (minimized) tab and enjoy getting notifications every time a new mail arrives.
https://github.com/stremlau/html5_notifier

### CalDAV/iCAL Support for Roundcube Calendar
This repository was forked from roundcubemail-plugins-kolab and contains a modified version of the Roundcube calendar plugin that enables client support for CalDAV and iCAL calendar resources. We added a feature branch feature_caldav with the modified calendar plugin and we try to frequently merge the latest release tags from upstream. You can find further information and a short introduction to this plugin on our website.
https://gitlab.awesome-it.de/kolab/roundcube-plugins

And the follow themes:

### Mabola: Skin for Roundcube Webmail
Mabola is a clean and usable skin for latest Roundcube Webmail (http://roundcube.net). Is based on Material Design, Bootstrap and inherits from Larry Skin, so there should be no unstyled content. Also blue version.
https://github.com/EstudioNexos/mabola-blue
https://github.com/EstudioNexos/mabola

### Chamaleon: Skin for Roundcube Webmail
Roundcube skin based in Kolab Community edition, with a blue version.
https://github.com/filhocf/roundcube-chameleon
https://github.com/Anisotropic/Chameleon-blue


## More Info

About RoundCube Mail: [roundcube.net](https://roundcube.net/)

To help improve this container [docker-roundcube](https://github.com/filhocf/docker-roundcube)
