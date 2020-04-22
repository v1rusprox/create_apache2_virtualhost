#!/bin/bash

[ -z $1 ] || DOMAIN=$1
[ -z $2 ] || FOLDER=$2

CONTENT="<VirtualHost *:80>\n
	\tServerName ${DOMAIN}\n
	\tServerAlias www.${DOMAIN}\n

	\tDocumentRoot ${FOLDER}\n

	\t<Directory ${FOLDER}>\n
        \t\tOptions Indexes FollowSymLinks MultiViews\n
        \t\tAllowOverride All\n
        \t\tOrder allow,deny\n
        \t\tallow from all\n
	\t</Directory>\n

	\tErrorLog \${APACHE_LOG_DIR}/$DOMAIN-error.log\n
	\tCustomLog \${APACHE_LOG_DIR}/$DOMAIN-access.log combined\n

</VirtualHost>"

[ -z $DOMAIN ] && echo "Missing first argument: domain name (example.local)" || 
[ -z $FOLDER ]  && echo "Missing second argument: document root (/path/to/folder)" ||
(sudo echo -e $CONTENT > "/etc/apache2/sites-available/${DOMAIN}.conf" && 
sudo a2ensite "${DOMAIN}.conf" &&
sudo /etc/init.d/apache2 reload &&
echo 'VirtualHost has been created! in /etc/apache2/sites-available/')
