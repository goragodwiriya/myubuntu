#!/usr/bin/env bash

echo "Update & Install applications (y/n): "
read answer
if echo "$answer" | grep -iq "^y" ;then
	# update system
	sudo add-apt-repository -y ppa:videolan/stable-daily
	sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
	sudo add-apt-repository -y ppa:gnome3-team/gnome3
	sudo add-apt-repository -y ppa:webupd8team/y-ppa-manager
	sudo add-apt-repository -y ppa:webupd8team/java
	sudo add-apt-repository -y ppa:gnome3-team/gnome3-staging
	sudo add-apt-repository -y ppa:yorba/ppa
	sudo add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get dist-upgrade

	# install application
	sudo apt-get install -y gksu aptitude synaptic gdebi-core gnome-system-monitor nautilus vlc git gimp gimp-data gimp-plugin-registry gimp-data-extras bleachbit flashplugin-installer unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview mpeg3-utils mpegdemux liba52-dev mpeg2dec vorbis-tools id3v2 mpg321 mpg123 icedax lame libmad0 libjpeg-progs libdvdread4 libdvdnav4 ubuntu-restricted-extras gedit chromium-browser pepperflashplugin-nonfree libavcodec-extra geary filezilla wine dconf-editor numlockx gnome-disk-utility audacious curl meld oracle-java8-installer oracle-java8-set-default ffmpeg python-software-properties dconf-editor
fi

echo "Install LEMP (Apache PHP7.0 MySQL5.7 phpMyAdmin) (y/n): "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo apt install -y apache2 mysql-server php-mysql php libapache2-mod-php php-mcrypt
	sudo apt install -y phpmyadmin php-mbstring php-gettext
	sudo mysql_secure_installation

	# change Server Root directory
	test="$(grep '/etc/apache2/apache2.conf' -e "<Directory /var/www/>")"
	if [ "$test" != "" ]; then
		# enabled mod_rewrite
		sudo a2enmod rewrite
		sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
    		echo 'Change apache document root to ... (eg `/mnt/Server/htdocs/`, empty not changed): '
		read answer
		if [ "$answer" != "" ]; then
			answer="$(echo "$answer" | sed 's/\//\\\//g')"
			sudo sed -i "s/\/var\/www\//$answer/" /etc/apache2/apache2.conf
			if [ -f '000-default.conf' ]; then
				sudo cp 000-default.conf /etc/apache2/sites-enabled/000-default.conf
			fi
			if [ -f 'hosts' ]; then
				sudo cp hosts /etc/hosts
			fi
		fi
	fi

	# install xdebug
	sudo apt install -y php-xdebug
	if [ -f '/etc/php/5.6/apache2/php.ini' ]; then
		test="$(grep '/etc/php/5.6/apache2/php.ini' -e 'zend_extension="/usr/lib/php/20131226/xdebug.so"')"
		if [ "$test" == "" ]; then
			echo "" >> /etc/php/5.6/apache2/php.ini
			echo '' >> /etc/php/5.6/apache2/php.ini
			echo '# Added for xdebug' >> /etc/php/5.6/apache2/php.ini
			echo 'zend_extension="/usr/lib/php/20131226/xdebug.so"' >> /etc/php/5.6/apache2/php.ini
			echo 'xdebug.remote_enable=1' >> /etc/php/5.6/apache2/php.ini
			echo 'xdebug.remote_handler=dbgp' >> /etc/php/5.6/apache2/php.ini
			echo 'xdebug.remote_mode=req' >> /etc/php/5.6/apache2/php.ini
			echo 'xdebug.remote_host=127.0.0.1' >> /etc/php/5.6/apache2/php.ini
			echo 'xdebug.remote_port=9000' >> /etc/php/5.6/apache2/php.ini
			echo 'xdebug.max_nesting_level=300' >> /etc/php/5.6/apache2/php.ini
		fi
	fi

	# restart apache
	sudo systemctl restart apache2
fi

# disabled apport
sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
sudo service apport stop

echo "Install Android Studio (y/n): "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo add-apt-repository -y ppa:paolorotolo/android-studio
	sudo apt-get update
	sudo apt-get install -y android-studio
fi

# clean up system
sudo apt-get -y autoremove
