#!/usr/bin/env bash

echo "Update & Install applications (y/n): "
read answer
if echo "$answer" | grep -iq "^y" ;then
	# update system
	sudo add-apt-repository -y ppa:webupd8team/java
	sudo add-apt-repository ppa:ondrej/php
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get dist-upgrade

	# install application
	sudo apt-get install -y curl meld oracle-java8-installer oracle-java8-set-default geary filezilla wine gedit chromium-browser git plank kazam kdenlive audacious mpv
fi

echo "Install Apache PHP7.0 PHP5.6-DEV MySQL5.7 XDEBUG Phalcon Ice (y/n): "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo apt-get install -y apache2
	sudo apt-get install -y mysql-server
	sudo apt-get install -y php5.6-dev php5.6-mysql php5.6-intl php5.6-gettext php5.6-mbstring libapache2-mod-php5.6 php5.6-mcrypt php5.6-xml
	sudo apt-get install -y php-gettext php-mbstring
	sudo apt-get install -y php-xdebug
	sudo apt-get install -y phpmyadmin
	sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
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

	#install phalcon
	echo "Install Phalcon (PHP 5.6 only) (y/n): "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo git clone --depth=1 git://github.com/phalcon/cphalcon.git
		cd cphalcon/build
		sudo ./install
		echo 'extension=/usr/lib/php/20131226/phalcon.so' | sudo tee -a /etc/php/5.6/mods-available/phalcon.ini
		sudo phpenmod phalcon
	fi

	#install ice
	echo "Install Ice (PHP 5.6 only) (y/n): "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		git clone --depth=1 https://github.com/ice/framework.git
		cd framework/
		./install
		echo 'extension=/usr/lib/php/20131226/ice.so' | sudo tee -a /etc/php/5.6/mods-available/ice.ini
		sudo phpenmod ice
	fi

	echo "Install PHP7.0 (y/n): "
	read answer
	if echo "$answer" | grep -iq "^y" ;then
		sudo apt-get install php7.0 php7.0-gettext libapache2-mod-php7.0 php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-xml php7.0-mysql
		sudo a2dismod proxy_fcgi proxy

		# xdebug PHP 7.0
		if [ -f '/etc/php/7.0/apache2/php.ini' ]; then
			test="$(grep '/etc/php/7.0/apache2/php.ini' -e 'zend_extension="/usr/lib/php/20131226/xdebug.so"')"
			if [ "$test" == "" ]; then
				echo "" >> /etc/php/7.0/apache2/php.ini
				echo '' >> /etc/php/7.0/apache2/php.ini
				echo '# Added for xdebug' >> /etc/php/7.0/apache2/php.ini
				echo 'zend_extension="/usr/lib/php/20131226/xdebug.so"' >> /etc/php/7.0/apache2/php.ini
				echo 'xdebug.remote_enable=1' >> /etc/php/7.0/apache2/php.ini
				echo 'xdebug.remote_handler=dbgp' >> /etc/php/7.0/apache2/php.ini
				echo 'xdebug.remote_mode=req' >> /etc/php/7.0/apache2/php.ini
				echo 'xdebug.remote_host=127.0.0.1' >> /etc/php/7.0/apache2/php.ini
				echo 'xdebug.remote_port=9000' >> /etc/php/7.0/apache2/php.ini
				echo 'xdebug.max_nesting_level=300' >> /etc/php/7.0/apache2/php.ini
			fi
		fi
	fi

	# xdebug PHP 5.6
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
if [ -f '/etc/default/apport' ]; then
	sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
	sudo service apport stop
fi

echo "Install Android Studio (y/n): "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo add-apt-repository -y ppa:paolorotolo/android-studio
	sudo apt-get update
	sudo apt-get install -y android-studio
fi

# clean up system
sudo apt-get -y autoremove
