#!/bin/bash
echo "Switch PHP to PHP 7.0 or PHP 5.6 (7/5): "
read answer
if echo "$answer" | grep -iq "^7" ;then
	echo "Switch to PHP 7.0"
	sudo a2dismod php5.6 ; sudo a2enmod php7.0 ; sudo service apache2 restart
else
	echo "Switch to PHP 5.6"
	sudo a2dismod php7.0 ; sudo a2enmod php5.6 ; sudo service apache2 restart
fi
