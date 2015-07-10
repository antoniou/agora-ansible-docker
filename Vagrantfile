# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if ENV['AWS_SECRET_ACCESS_KEY'].nil?
        config.vm.box = "ubuntu/trusty64"

        # quarantined, do not need this in dev mode, vms communicate through private network
        # config.vm.network "forwarded_port", guest: 5000, host: 5000
        # config.vm.network "forwarded_port", guest: 4081, host: 4081
        # config.vm.network "forwarded_port", guest: 8081, host: 8081

        # https://coderwall.com/p/n2y79g
        config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            v.memory = 2048
            v.cpus = 1
        end

        # for development setup
        config.vm.network "private_network", ip: "192.168.50.3"
    else
        config.vm.box = "dummy"
        config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
        config.ssh.username = "ubuntu"

        config.vm.provider "aws" do |aws, override|
            override.ssh.private_key_path = ENV['AWS_PRIVKEY_PATH']
            override.ssh.username = "ubuntu"

            aws.access_key_id =  ENV['AWS_ACCESS_KEY_ID']
            aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
            aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
            aws.security_groups = [ENV["AWS_SECURITY_GROUP"]]
            aws.region = "eu-west-1"
            aws.ami = "ami-4c9b7d3b"
            aws.instance_type = "c1.medium"
            aws.tags = {
                Name: 'Vagrant AWS Election-orchestra'
            }

            aws.region_config "es-west-1" do |region|
                region.terminate_on_shutdown = true
            end
        end
    end

  config.vm.synced_folder "keys", "/home/vagrant/keys", type: "rsync"
  config.vm.synced_folder "certs", "/home/vagrant/certs"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "authority_server/deploy.yml"
    ansible.verbose = "v"
    ansible.extra_vars = "eo_env.yml"
  end
end