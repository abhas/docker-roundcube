FROM filhocf/docker-php7

MAINTAINER Claudio Ferreira <filhocf@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ARG RC_VERSION=1.3-beta

#:VOLUME /var/www

# Get Roundcube package
USER www-data
WORKDIR /var/www
RUN \
    wget -O- https://github.com/roundcube/roundcubemail/releases/download/$RC_VERSION/roundcubemail-$RC_VERSION-complete.tar.gz | \
    tar xz --strip-components=1; \
    # Get plugins
    # Attention: need to create the final directory before donwload and extract the respective plugin
      mkdir plugins/contextmenu plugins/contextmenu_folder plugins/message_highlight plugins/infinitescroll \
        plugins/thunderbird_labels plugins/removeattachments plugins/attachment_position skins/melanie2_larry_mobile \
        plugins/mobile plugins/jquery_mobile skins/mabola-blue skins/mabola skins/chameleon; \
    # Download and install each plugin/skin
      wget -O- https://github.com/JohnDoh/Roundcube-Plugin-Context-Menu/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/contextmenu; \
      wget -O- https://github.com/filhocf/contextmenu_folder/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/contextmenu_folder; \
      wget -O- https://github.com/corbosman/message_highlight/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/message_highlight; \
      wget -O- https://github.com/messagerie-melanie2/Roundcube-Plugin-Infinite-Scroll/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/infinitescroll; \
      wget -O- https://github.com/mike-kfed/rcmail-thunderbird-labels/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/thunderbird_labels; \
      #wget -O- https://github.com/dsoares/Roundcube-Plugin-RemoveAttachments/archive/0.2.3.tar.gz    -O removeattach.tar.gz; \
      wget -O- https://github.com/filhocf/Roundcube-Plugin-RemoveAttachments/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/removeattachments; \
      #wget -O- https://github.com/dapphp/Roundcube-Plugin-attachment_position/archive/1.0.0.tar.gz   -O attachposition.tar.gz; \
      wget -O- https://github.com/filhocf/Roundcube-Plugin-attachment_position/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/attachment_position; \
      #wget -O- https://github.com/teonsystems/roundcube-plugin-keyboard-shortcuts-ng/archive/v0.9.4.tar.gz -O kbshortcutsng.tar.gz; \
      #wget -O- https://gitlab.awesome-it.de/filhocf/roundcube-plugins/repository/archive.tar.gz?ref=feature_caldav -O kolab.tar.gz; \
      #wget -O- https://github.com/messagerie-melanie2/Roundcube-Plugin-Roundrive/archive/master.tar.gz  -O roundrive.tar.gz; \
      wget -O- https://github.com/messagerie-melanie2/Roundcube-Skin-Melanie2-Larry-Mobile/archive/master.tar.gz | \
      tar xz --strip-components=1 -C skins/melanie2_larry_mobile; \
      wget -O- https://github.com/messagerie-melanie2/Roundcube-Plugin-Mobile/archive/master.tar.gz  | \
      tar xz --strip-components=1 -C plugins/mobile; \
      wget -O- https://github.com/messagerie-melanie2/Roundcube-Plugin-JQuery-Mobile/archive/master.tar.gz | \
      tar xz --strip-components=1 -C plugins/jquery_mobile; \
    # Get themes
      wget -O- https://github.com/EstudioNexos/mabola-blue/archive/master.tar.gz | \
      tar xz --strip-components=1 -C skins/mabola-blue; \
      wget -O- https://github.com/EstudioNexos/mabola/archive/master.tar.gz | \
      tar xz --strip-components=1 -C skins/mabola; \
      wget -O- https://github.com/filhocf/roundcubemail-skin-chameleon/archive/master.tar.gz | \
      tar xz --strip-components=1 -C skins/chameleon


RUN \
    echo "Add Awesome's plugin ===============>>>>>>>>>>>>>"; \
      cd plugins; \
      git clone -v https://gitlab.awesome-it.de/filhocf/roundcube-plugins.git; \
      ln -s roundcube-plugins/plugins/calendar; \
      ln -s roundcube-plugins/plugins/libcalendaring; \
      ln -s roundcube-plugins/plugins/piwik_analytics; \
      ln -s roundcube-plugins/plugins/pdfviewer; \
      ln -s roundcube-plugins/plugins/odfviewer; \
      ln -s roundcube-plugins/plugins/tasklist; \
    chown www-data.www-data /var/www/ -R

# Install the Composer - package manager for PHP
USER root
WORKDIR /usr/local/bin
RUN wget https://getcomposer.org/download/1.4.0/composer.phar -O /usr/bin/composer; \
    chmod +x /usr/bin/composer; \
    echo 'TLS_REQCERT never' >> /etc/ldap/ldap.conf

# Install dependencies for calendar
#USER www-data
#WORKDIR /var/www//plugins/calendar/lib
#RUN \
    #composer -vv remove -n sabre/dav; \
    #composer -vv remove -n fkooman/oauth-client; \
    #composer -vv require -n sabre/dav 1.8.12; \
    #composer -vv require -n sabre/http; \
    #composer -vv require -n fkooman/oauth-client; \
    #rm -rf `find /var -iname .composer`; \
    #rm -rf `find /var -iname .git`

USER root
COPY run.sh /run.sh
EXPOSE 80 443

CMD ["/run.sh"]
