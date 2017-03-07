FROM filhocf/php7

MAINTAINER Claudio Ferreira "filhocf@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

ARG PKG_PROXY
ARG TOKEN
ARG RC_VERSION=1.3-beta

#:VOLUME /var/www

# Get Roundcube package
USER www-data
WORKDIR /var/www
RUN \
    wget https://github.com/roundcube/roundcubemail/releases/download/$RC_VERSION/roundcubemail-$RC_VERSION-complete.tar.gz; \
    # Get plugins
      wget https://github.com/JohnDoh/Roundcube-Plugin-Context-Menu/archive/master.tar.gz         -O contextmenu.tar.gz; \
      wget https://github.com/filhocf/contextmenu_folder/archive/master.tar.gz                     -O foldercontextmenu.tar.gz; \
      wget https://github.com/corbosman/message_highlight/archive/master.tar.gz                     -O messagehighlight.tar.gz; \
      wget https://github.com/messagerie-melanie2/Roundcube-Plugin-Infinite-Scroll/archive/master.tar.gz  -O infinitescroll.tar.gz; \
      # wget https://github.com/EstudioNexos/threecol/archive/master.tar.gz                        -O treecol.tar.gz; \
      wget https://github.com/mike-kfed/rcmail-thunderbird-labels/archive/master.tar.gz          -O tbirdlabel.tar.gz; \
      #wget https://github.com/dsoares/Roundcube-Plugin-RemoveAttachments/archive/0.2.3.tar.gz    -O removeattach.tar.gz; \
      wget https://github.com/filhocf/Roundcube-Plugin-RemoveAttachments/archive/master.tar.gz    -O removeattach.tar.gz; \
      #wget https://github.com/dapphp/Roundcube-Plugin-attachment_position/archive/1.0.0.tar.gz   -O attachposition.tar.gz; \
      wget https://github.com/filhocf/Roundcube-Plugin-attachment_position/archive/master.tar.gz   -O attachposition.tar.gz; \
      #wget https://github.com/teonsystems/roundcube-plugin-keyboard-shortcuts-ng/archive/v0.9.4.tar.gz -O kbshortcutsng.tar.gz; \
      #wget https://gitlab.awesome-it.de/filhocf/roundcube-plugins/repository/archive.tar.gz?ref=feature_caldav -O kolab.tar.gz; \
      #wget https://github.com/messagerie-melanie2/Roundcube-Plugin-Roundrive/archive/master.tar.gz  -O roundrive.tar.gz; \
      wget https://github.com/messagerie-melanie2/Roundcube-Skin-Melanie2-Larry-Mobile/archive/master.tar.gz -O melanie2-larry-mobile.tar.gz; \
      wget https://github.com/messagerie-melanie2/Roundcube-Plugin-Mobile/archive/master.tar.gz  -O plugin-mobile.tar.gz; \
      wget https://github.com/messagerie-melanie2/Roundcube-Plugin-JQuery-Mobile/archive/master.tar.gz -O jquery-mobile.tar.gz; \
    # Get themes
      wget https://github.com/EstudioNexos/mabola-blue/archive/master.tar.gz                     -O mabola-blue.tar.gz; \
      wget https://github.com/EstudioNexos/mabola/archive/master.tar.gz                          -O mabola.tar.gz; \
      wget https://github.com/filhocf/roundcubemail-skin-chameleon/archive/master.tar.gz         -O chameleon.tar.gz


RUN \
    tar xf roundcubemail-$RC_VERSION-complete.tar.gz; \
    mv roundcubemail-$RC_VERSION webmail; \
    rm roundcubemail-$RC_VERSION-complete.tar.gz; \
    echo "Unpack plugins ===============>>>>>>>>>>>>>"; \
      cd /var/www/webmail/plugins; \
      for i in contextmenu.tar.gz \
        foldercontextmenu.tar.gz \
        messagehighlight.tar.gz \
        infinitescroll.tar.gz \
        # treecol.tar.gz \
        tbirdlabel.tar.gz \
        removeattach.tar.gz \
        attachposition.tar.gz \
        #kbshortcutsng.tar.gz \
        #kolab.tar.gz \
        #roundrive.tar.gz \
        plugin-mobile.tar.gz \
        jquery-mobile.tar.gz; \
        do echo "Uncompressing $i"; tar xf ../../$i; echo "Removing file $i";  rm ../../$i; done; \
    echo "Adjust folder's names ===============>>>>>>>>>>>>>"; \
      mv -v Roundcube-Plugin-Context-Menu-master contextmenu; \
      mv -v contextmenu_folder-master contextmenu_folder; \
      mv -v Roundcube-Plugin-RemoveAttachments-master removeattachments; \
      mv -v Roundcube-Plugin-attachment_position-master attachment_position; \
      mv -v message_highlight-master message_highlight; \
      # mv -v threecol-master threecol; \
      mv -v rcmail-thunderbird-labels-master thunderbird_labels; \
      mv -v Roundcube-Plugin-Infinite-Scroll-master/ infinitescroll; \
      # mv -v roundcube-plugin-keyboard-shortcuts-ng-0.9.4/ keyboard_shortcuts_ng; \
      mv -v Roundcube-Plugin-JQuery-Mobile-master jquery_mobile; \
      mv -v Roundcube-Plugin-Mobile-master mobile; \
      #mv -v Roundcube-Plugin-Roundrive-master roundrive; \
      git clone -v https://gitlab.awesome-it.de/filhocf/roundcube-plugins.git; \
      ln -s roundcube-plugins/plugins/calendar; \
      ln -s roundcube-plugins/plugins/libcalendaring; \
      ln -s roundcube-plugins/plugins/piwik_analytics; \
      ln -s roundcube-plugins/plugins/pdfviewer; \
      ln -s roundcube-plugins/plugins/odfviewer; \
      ln -s roundcube-plugins/plugins/tasklist; \
    echo "Uncompressing themes ===============>>>>>>>>>>>>>"; \
      cd /var/www/webmail/skins; \
      for i in mabola.tar.gz mabola-blue.tar.gz chameleon.tar.gz melanie2-larry-mobile.tar.gz; \
        do echo "Uncompressing $i"; tar xf ../../$i; echo "Removing file $i";  rm ../../$i; done; \
      echo "Adjust folder's names ===============>>>>>>>>>>>>>"; \
        mv -v mabola-master mabola; \
        mv -v mabola-blue-master mabola-blue; \
        mv -v roundcubemail-skin-chameleon-master chameleon; \
        mv -v Roundcube-Skin-Melanie2-Larry-Mobile-master melanie2_larry_mobile; \
      chown www-data.www-data /var/www/webmail/ -R

# Install the Composer - package manager for PHP
USER root
WORKDIR /usr/local/bin
RUN wget https://getcomposer.org/installer -O composer-setup.php; \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php; \
    php -r "unlink('composer-setup.php');"; \
    mv composer.phar /usr/bin/composer
    #echo 'TLS_REQCERT never' >> /etc/ldap/ldap.conf

# Install dependencies for calendar
#USER www-data
#WORKDIR /var/www/webmail/plugins/calendar/lib
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
