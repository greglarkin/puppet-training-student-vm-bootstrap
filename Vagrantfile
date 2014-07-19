# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-64-x64-nocm"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-fusion503-nocm.box"

  config.pe_build.version       = '3.3.0'
  config.pe_build.download_root = 'https://s3.amazonaws.com/pe-builds/released/:version'

## Master
  config.vm.define :master do |master|

    master.vm.network :private_network, ip: "10.10.100.100"

    master.vm.hostname = 'master.puppetlabs.vm'
    master.vm.provision :hosts

    master.vm.provision :pe_bootstrap do |pe|
      pe.role = :master
    end

    master.vm.synced_folder "puppet/modules", "/etc/puppetlabs/puppet/modules"
    master.vm.synced_folder "puppet/manifests", "/etc/puppetlabs/puppet/manifests"

    config.vm.provision "shell", inline: "service iptables stop"

  end

## agent 1
  config.vm.define :agent1 do |agent|

    #agent.vm.provider :vmware_fusion
    agent.vm.network :private_network, ip: "10.10.100.111"

    agent.vm.hostname = 'agent1.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role   =  :agent
      pe.master = 'master.puppetlabs.vm'
    end
  end

## Gitlab 
  config.vm.define :gitlab do |agent|

    agent.vm.network :private_network, ip: "10.10.100.112"

    agent.vm.hostname = 'gitlab.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role = :agent
      pe.master = 'master.puppetlabs.vm'
    end

    agent.vm.provision "shell", inline: 'echo "PATH=$PATH:/opt/puppet/bin" >> $HOME/.bashrc'
    
    agent.vm.provision "puppet" do |p|
    	p.manifests_path = "agent_provision/manifests"
	p.module_path = "agent_provision/modules"
	p.manifest_file = "deploy_gitlab.pp"
    end
  end
end
