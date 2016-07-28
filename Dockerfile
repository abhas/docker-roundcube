FROM debian

MAINTAINER Claudio Ferreira "filhocf@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

#:VOLUME /var/www

# Update all mirrors
RUN \
    # Set a package proxy in next line
    # echo 'Acquire::http { Proxy "http://www-mirrordf:3142"; };' > /etc/apt/apt.conf;
    echo deb http://httpredir.debian.org/debian jessie-backports main >> /etc/apt/sources.list; \
    apt-get update

# Install a tool set
RUN apt-get install -y vim less curl wget multitail tmux git telnet net-tools apt-utils unzip

# Adjust some env points
RUN echo 'syntax on' >> /etc/vim/vimrc; \
    echo 'set background=dark' >> /etc/vim/vimrc; \
    echo 'set number' >> /etc/vim/vimrc; \
    echo 'PS1="\[\e[36m\]DOCKER:\[\e[m\] \[\e[34m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\] \[\e[31m\]\d\[\e[m\] - \A\[\e[33m\]\n\w\[\e[m\]\\n# "' >> /root/.bashrc; \
    echo 'umask 022'  >> /root/.bashrc; \
    echo 'export LS_OPTIONS="--color=auto"'  >> /root/.bashrc; \
    echo 'eval "`dircolors`"'  >> /root/.bashrc; \
    echo 'alias ls="ls $LS_OPTIONS"'  >> /root/.bashrc

# Install PHP and Nginx with ssl
# Preferably use the mysqlnd driver. (ref: https://dev.mysql.com/downloads/connector/php-mysqlnd/)
# Install aditional tools to email and pdf, beyond pgsql and sqlite drivers
RUN apt-get install -y nginx php5 php5-cli php5-fpm php5-mysqlnd php5-pgsql php5-sqlite \
    php5-curl php5-cgi php5-mcrypt php5-ldap php5-intl php5-json php5-gd php5-pspell php-net-smtp \
    php-net-socket php-mail-mime php-net-sieve libmagic1 php-pear php-auth-sasl php-patchwork-utf8 \
    php-net-ldap3

# Adjust self-signned ssl certificate, php, nginx and date.timezone in php.
RUN mkdir /etc/nginx/ssl; \
    cd /etc/nginx/ssl; \
    openssl req -new -x509 -sha256 -days 2000 -nodes -out cert.pem -keyout nginx.key -newkey rsa:2048 -subj "/C=BR/ST=DF/L=Brasilia/O=Company/CN=www.company.com.br"; \
    echo "ssl_certificate /etc/nginx/ssl/cert.pem;" > /etc/nginx/snippets/snakeoil.conf; \
    echo "ssl_certificate_key /etc/nginx/ssl/nginx.key;" >> /etc/nginx/snippets/snakeoil.conf; \
    sed -i -e "s/#\ listen\ 443/listen\ 443/" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/#\ listen\ \[::\]:443/listen\ \[::\]:443/" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/#\ include\ snippets/include\ snippets/" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/root\ \/var\/www\/html/root\ \/var\/www\/webmail/" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/#location\ ~\ \\\.php/location\ ~\ \\\.php/" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/#\tinclude\ snippets/\tinclude\ snippets/" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/#\tfastcgi_pass\ unix/\tfastcgi_pass\ unix/" /etc/nginx/sites-enabled/default; \
    sed -i -e "/fastcgi_pass/ { n; s/#\}/\}/}" /etc/nginx/sites-enabled/default; \
    sed -i -e "s/index.nginx-debian.html/index.nginx-debian.html\ index.php/" /etc/nginx/sites-enabled/default

    # Get Roundcube package
    RUN cd /var/www; \
        # Uncomment the next line if need proxy
        # export https_proxy=http://10.0.220.11:8080;  export http_proxy=http://10.0.220.11:8080; \
        wget https://github.com/roundcube/roundcubemail/releases/download/1.2.0/roundcubemail-1.2.0-complete.tar.gz; \
        # Get plugins
          wget https://github.com/JohnDoh/Roundcube-Plugin-SieveRules-Managesieve/archive/2.3.tar.gz -O managesieve.tar.gz; \
          wget https://github.com/JohnDoh/Roundcube-Plugin-Context-Menu/archive/2.1.2.tar.gz         -O contextmenu.tar.gz; \
          wget https://github.com/corbosman/message_highlight/archive/2.6.tar.gz                     -O messagehighlight.tar.gz; \
          wget https://github.com/messagerie-melanie2/Roundcube-Plugin-Infinite-Scroll/archive/master.tar.gz  -O infinitescroll.tar.gz; \
          wget https://github.com/EstudioNexos/threecol/archive/master.tar.gz                        -O treecol.tar.gz; \
          wget https://github.com/mike-kfed/rcmail-thunderbird-labels/archive/v1.1.3.tar.gz          -O tbirdlabel.tar.gz; \
          wget https://github.com/dsoares/Roundcube-Plugin-RemoveAttachments/archive/0.2.3.tar.gz    -O removeattach.tar.gz; \
          wget https://github.com/corbosman/listcommands/archive/2.4.tar.gz                          -O listcommands.tar.gz; \
          wget https://github.com/dapphp/Roundcube-Plugin-attachment_position/archive/1.0.0.tar.gz   -O attachposition.tar.gz; \
          wget https://github.com/teonsystems/roundcube-plugin-keyboard-shortcuts-ng/archive/v0.9.4.tar.gz -O kbshortcutsng.tar.gz; \
          wget https://gitlab.awesome-it.de/kolab/roundcube-plugins/repository/archive.tar.gz?ref=feature_caldav -O kolab.tar.gz; \
        # Get themes
          wget https://github.com/EstudioNexos/mabola-blue/archive/master.tar.gz                     -O mabola-blue.tar.gz; \
          wget https://github.com/EstudioNexos/mabola/archive/master.tar.gz                          -O mabola.tar.gz


    RUN cd /var/www; \
        tar xf roundcubemail-1.2.0-complete.tar.gz; \
        mv roundcubemail-1.2.0 webmail; \
        rm /var/www/roundcubemail-1.2.0-complete.tar.gz; \
        echo "Unpack plugins ===============>>>>>>>>>>>>>"; \
          cd /var/www/webmail/plugins; \
          for i in managesieve.tar.gz \
            contextmenu.tar.gz \
            messagehighlight.tar.gz \
            infinitescroll.tar.gz \
            treecol.tar.gz \
            tbirdlabel.tar.gz \
            removeattach.tar.gz \
            listcommands.tar.gz \
            attachposition.tar.gz \
            kbshortcutsng.tar.gz \
            kolab.tar.gz; \
            do echo "Uncompressing $i"; tar xf ../../$i; echo "Removing file $i";  rm ../../$i; done; \
        echo "Adjust folder's names ===============>>>>>>>>>>>>>"; \
          mv -v Roundcube-Plugin-Context-Menu-2.1.2 contextmenu; \
          mv -v Roundcube-Plugin-RemoveAttachments-0.2.3 removeattachments; \
          mv -v Roundcube-Plugin-attachment_position-1.0.0 attachment_position; \
          mv -v Roundcube-Plugin-SieveRules-Managesieve-2.3 sieverules; \
          mv -v listcommands-2.4 listcommands; \
          mv -v message_highlight-2.6 message_highlight; \
          mv -v threecol-master threecol; \
          mv -v rcmail-thunderbird-labels-1.1.3 thunderbird_labels; \
          mv -v Roundcube-Plugin-Infinite-Scroll-master/ infinitescroll; \
          mv -v roundcube-plugin-keyboard-shortcuts-ng-0.9.4/ keyboard_shortcuts_ng; \
          mv -v `ls -d roundcube-plugins-feature_caldav-*`/plugins/calendar .; \
          mv -v `ls -d roundcube-plugins-feature_caldav-*`/plugins/libcalendaring .; \
          mv -v `ls -d roundcube-plugins-feature_caldav-*`/plugins/odfviewer .; \
          mv -v `ls -d roundcube-plugins-feature_caldav-*`/plugins/pdfviewer .; \
          mv -v `ls -d roundcube-plugins-feature_caldav-*`/plugins/piwik_analytics .; \
          rm -rf `ls -d roundcube-plugins-feature_caldav-*`; \
        echo "Uncompressing themes ===============>>>>>>>>>>>>>"; \
          cd /var/www/webmail/skins; \
          for i in mabola.tar.gz mabola-blue.tar.gz; \
            do echo "Uncompressing $i"; tar xf ../../$i; echo "Removing file $i";  rm ../../$i; done; \
          echo "Adjust folder's names ===============>>>>>>>>>>>>>"; \
            mv -v mabola-master mabola; \
            mv -v mabola-blue-master mabola-blue; \
          chown www-data.www-data /var/www/webmail/ -R; \
          echo 'TLS_REQCERT never' >> /etc/ldap/ldap.conf

# Install the Composer - package manager for PHP
RUN cd /var/www/webmail; \
    # Uncomment the next line if need proxy
    # export https_proxy=http://10.0.220.11:8080;  export http_proxy=http://10.0.220.11:8080 &&; \
    wget https://getcomposer.org/installer -O composer-setup.php; \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php; \
    php -r "unlink('composer-setup.php');"; \
    mv composer.phar /usr/local/bin/composer

# Install dependencies for calendar
RUN cd /var/www/webmail/plugins/calendar/lib; \
    # Uncomment the next line if need proxy
    # export https_proxy=http://10.0.220.11:8080;  export http_proxy=http://10.0.220.11:8080 &&; \
    composer config -g github-oauth.github.com 5b20d55525892090fb582e17395360088d40b1e8; \
    composer -v remove sabre/dav; \
    composer -v remove sabre/vobject; \
    composer -vv require --update-with-dependencies sabre/dav 3.2.0

COPY config.inc.php /var/www/webmail/config/config.inc.php
COPY run.sh /run.sh
EXPOSE 80 443

CMD ["/run.sh"]