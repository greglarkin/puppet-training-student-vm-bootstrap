# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/puppet-training-centos-6.5-pe-3.3.0"
  config.pe_build.download_root = 'https://s3.amazonaws.com/pe-builds/released/:version'
  config.pe_build.version = "3.3.0"

## Master
  config.vm.define :master do |master|
    master.vm.network :private_network, ip: "10.10.100.100", :bridge => 'eth0', :mac => "080027XXXXXX"
    master.vm.hostname = 'master.puppetlabs.vm'
    master.vm.provision :hosts
    master.vm.provision :pe_bootstrap do |pe|
      pe.role = :master
    end
    master.vm.synced_folder "puppet/modules", "/tmp/modules"
    master.vm.synced_folder "puppet/manifests", "/tmp/manifests"
    master.vm.provision "shell", inline: "service iptables stop"
    master.vm.provision "shell", inline: "rm -rf /etc/puppetlabs/puppet/modules/ && ln -s /tmp/modules/ /etc/puppetlabs/puppet/"
    master.vm.provision "shell", inline: "rm -rf /etc/puppetlabs/puppet/manifests/ && ln -s /tmp/manifests/ /etc/puppetlabs/puppet/"
  end

## Agent 
  config.vm.define :agent1 do |agent|
    agent.vm.network :private_network, ip: "10.10.100.111", :bridge => 'eth0', :mac => "080027XXXXXX"
    agent.vm.hostname = 'agent1.puppetlabs.vm'
    agent.vm.provision :hosts
    agent.vm.provision :pe_bootstrap do |pe|
      pe.role   =  :agent
      pe.master = 'master.puppetlabs.vm'
    end
  end

## Ubuntu Agent 
#  config.vm.define :agent1 do |agent|
#    agent.vm.box = "ubuntu-6.5-pe-3.3.0"
#    config.vm.box_url = "puppetlabs/ubuntu--pe-3.3.0.box"
#    agent.vm.network :private_network, ip: "10.10.100.112", :bridge => 'eth0', :mac => "080027XXXXXX"
#    agent.vm.hostname = 'ubuntu_agent.puppetlabs.vm'
#    agent.vm.provision :hosts
#    agent.vm.provision :pe_bootstrap do |pe|
#      pe.role   =  :agent
#      pe.master = 'master.puppetlabs.vm'
#    end
#  end
end

