#!/bin/sh

# Envirounment variables
# PROXY_PKG= \                # Format: http[s]://<name_or_ip>[:<port>]
# PROXY_HTTP= \               # Format: http[s]://<name_or_ip>[:<port>]
# RCMAIL_USER=roundcube \
# RCMAIL_PASS=roundcube \
# RCMAIL_HOST=db \
# RCMAIL_DB=roundcubemail \
# RCMAIL_CREATEDB=false \
# RCMAIL_IMAP=localhost \     # Format: [imap|imaps|tls|ssl]://<ip_or_name_imap_host>
# RCMAIL_SMTP=localhost \     # Format: [smtp|smtps|tls|ssl]://<ip_or_name_smtp_host>
# RCMAIL_CALENDAR=false\
# PHP_DATEZONE=

#if [ ! $RCMAIL_USER ]
#  then export RCMAIL_USER=roundcube
#elif [ ! $RCMAIL_PASS ]
#  then export RCMAIL_PASS=roundcube
#elif [ ! $RCMAIL_DB ]
#  then export RCMAIL_DB=roundcubemail
#elif [ ! $RCMAIL_HOST ]
#  then export RCMAIL_HOST=localhost
#fi

# Adjust database
#sed -i -e "s|roundcube:roundcube@localhost/roundcubemail|$RCMAIL_USER:$RCMAIL_PASS@$RCMAIL_HOST/$RCMAIL_DB|" /var/www/webmail/config/config.inc.php
# Adjust imap and smtp servers
#sed -i -e "s/$config['default_host']\ =\ 'localhost';/$config['default_host']\ =\ '$RCMAIL_IMAP';/"  /var/www/webmail/config/config.inc.php
#sed -i -e "s/$config['smtp_server']\ =\ 'localhost';/$config['smtp_server']\ =\ '$RCMAIL_SMTP';/"  /var/www/webmail/config/config.inc.php
# Adjust timezone of PHP
#sed -i -e "s/;date.timezone\ =/date.timezone\ =\ $PHP_DATEZONE/" /etc/php5/fpm/php.ini

cd /etc/init.d/
./php5-fpm restart && \
./nginx restart

if [ ! -f /var/www/webmail/logs/errors ]; then touch /var/www/webmail/logs/errors ; chown www-data:www-data /var/www -R ; fi

tail -f /var/www/webmail/logs/errors
