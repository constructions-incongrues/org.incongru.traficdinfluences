# -*- mode: ruby -*-
# vi: set ft=ruby :

# Read CI configuration
require 'yaml'
ci = YAML.load_file('ci.yml')

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/ubuntu-14.04"

  # Setup networking
  config.vm.network "private_network", type: "dhcp", nictype: "virtio"

  # Copy Apache configuration
  config.vm.provision "file", source: 'etc/templates/apache2-vhost.conf', destination: '/tmp/apache2-vhost.conf'

  # Provision
  config.vm.provision "shell" do |s|
      s.path = "bin/provision-#{ci['type']}.sh"
      s.args = ["#{ci['name']}", "#{ci['profile']}"]
  end

  # Setup synced folders
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.synced_folder "/home/trivoallan/Dropbox/Musique/self/Trafic_d_Influences/import_wordpress", "/tmp/import_wordpress", type: "nfs"

  # Configure Virtualbox
  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
  end

  # Configure vagrant-vbguest
  config.vbguest.auto_reboot = true

  # @see https://github.com/phinze/landrush
  config.landrush.enabled = true
  config.vm.hostname = "#{ci['name']}.vagrant.test"
end
