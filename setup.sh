#!/usr/bin/env bash

# update system
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
sudo add-apt-repository -y ppa:gnome3-team/gnome3
sudo add-apt-repository -y ppa:webupd8team/y-ppa-manager
sudo add-apt-repository -y ppa:webupd8team/java
sudo add-apt-repository -y ppa:gnome3-team/gnome3-staging
sudo add-apt-repository -y ppa:yorba/ppa
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
sudo add-apt-repository -y ppa:paolorotolo/android-studio
sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-0
sudo add-apt-repository ppa:obsproject/obs-studio
sudo add-apt-repository ppa:sunab/kdenlive-release
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade

# install application
sudo apt-get install -y gksu aptitude synaptic gdebi-core gnome-system-monitor nautilus vlc git gimp gimp-data gimp-plugin-registry gimp-data-extras bleachbit flashplugin-installer unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview mpeg3-utils mpegdemux liba52-dev mpeg2dec vorbis-tools id3v2 mpg321 mpg123 icedax lame libmad0 libjpeg-progs libdvdread4 libdvdnav4 ubuntu-restricted-extras gedit chromium-browser pepperflashplugin-nonfree libavcodec-extra geary filezilla wine dconf-editor numlockx gnome-disk-utility audacious curl meld oracle-java7-installer oracle-java7-set-default ffmpeg python-software-properties dconf-editor obs-studio kazam kdenlive

# install libreoffice 5.0.x
sudo apt-get install -y libreoffice

# install Android Studio
sudo apt-get install -y android-studio

# install Apache PHP5 mariadb
sudo apt-get install -y apache2 python-software-properties php5-dev php5-intl
sudo apt-get install -y mariadb-client mariadb-server
sudo mysql_secure_installation
sed -i -e '1iServerName localhost\' /etc/apache2/sites-enabled/000-default.conf

# install xdebug
sudo apt-get install -y php5-xdebug
echo "" >> /etc/apache2/apache2.conf
echo "# Include phpMyAdmin configurations" >> /etc/apache2/apache2.conf
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# install phpmyadmin
sudo apt-get install -y phpmyadmin
echo '' >> /etc/php5/apache2/php.ini
echo '# Added for xdebug' >> /etc/php5/apache2/php.ini
echo 'zend_extension="/usr/lib/php5/20131226/xdebug.so"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_enable=1' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_handler=dbgp' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_mode=req' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_host=127.0.0.1' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_port=9000' >> /etc/php5/apache2/php.ini
echo 'xdebug.max_nesting_level=300' >> /etc/php5/apache2/php.ini

# enabled mod_rewrite
sudo a2enmod rewrite
sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf

# install phalcon
sudo git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build
sudo ./install
echo 'extension=phalcon.so' | sudo tee -a /etc/php5/mods-available/phalcon.ini
cd /etc/php5/mods-available
sudo php5enmod phalcon

# restart apache
sudo service apache2 restart

# disabled apport
sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
sudo service apport stop

# clean system
sudo apt-get -y autoremove
