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
apt-get -y install libapache2-mod-php5 php5-cli php5-mysql
a2enmod headers
a2enmod rewrite
cp /tmp/apache2-vhost.conf /etc/apache2/sites-available/000-default.conf
service apache2 restart

# Installation de MySQL
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
apt-get install -y mysql-server

# Installation de PhpMyAdmin
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install -y phpmyadmin

# Création de la base de données
apt-get install -y rpl
mysql --defaults-file=/etc/mysql/debian.cnf -e "drop database if exists wordpress"
mysql --defaults-file=/etc/mysql/debian.cnf -e "create database wordpress default charset utf8 collate utf8_general_ci"
rpl traficdinfluences.incongru.org traficdinfluences.vagrant.test /vagrant/src/data/fixtures/wordpress.sql
mysql --defaults-file=/etc/mysql/debian.cnf wordpress < /vagrant/src/data/fixtures/wordpress.sql

# Configuration du projet
apt-get -y install ant
cd /vagrant
ABT_USER="$PROFILE" ./composer.phar install --prefer-dist --no-progress
ant configure build -Dprofile="$PROFILE"

# Suppression du cache Wordpress
rm -rf /vagrant/src/wp-content/cache/*

# Installation des dépendances supplémentaires
apt-get install -y eyed3 jq

# Informations
echo
echo -e "Le site est disponible à l'adresse : http://$PROJECT_NAME.vagrant.test"
echo -e "PhpMyAdmin est disponible à l'adresse : http://$PROJECT_NAME.vagrant.test/phpmyadmin (root / root)"