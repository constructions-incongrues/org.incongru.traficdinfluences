#!/usr/bin/env bash

# Profil ABT
PROJECT_NAME=$1
PROFILE=$2

# Mise à jour des dépots
apt-get -y update

# Configuration de la timezone
echo "Europe/Paris" > /etc/timezone
apt-get -y install tzdata
dpkg-reconfigure -f noninteractive tzdata

# Installation de Apache et PHP
apt-get -y install libapache2-mod-php5 php5-cli
a2enmod headers
a2enmod rewrite
cp /tmp/apache2-vhost.conf /etc/apache2/sites-available/000-default.conf
service apache2 restart

# Configuration du projet
apt-get -y install ant
cd /vagrant
ABT_USER="$PROFILE" ./composer.phar install --prefer-dist --no-progress
ant configure build -Dprofile="$PROFILE"

# Informations
echo
echo -e "Le site est disponible à l'adresse : http://$PROJECT_NAME.vagrant.test"
