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

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-64-x64-nocm"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-fusion503-nocm.box"

  config.pe_build.version       = '3.1.0'
  config.pe_build.download_root = 'https://s3.amazonaws.com/pe-builds/released'

## Master
  config.vm.define :master do |master|

    master.vm.provider :vmware_fusion do |v|
      v.vmx["memsize"]  = "4096"
      v.vmx["numvcpus"] = "4"
    end

    master.vm.network :private_network, ip: "10.10.100.100"

    master.vm.hostname = 'master.puppetlabs.vm'
    master.vm.provision :hosts

    master.vm.provision :pe_bootstrap do |pe|
      pe.role = :master
    end
    
    master.vm.provision "shell", 
    	inline: 'echo "PATH=$PATH:/opt/puppet/bin" >> $HOME/.bashrc'
    
    master.vm.provision "puppet" do |p|
    	p.module_path = "master/modules"
	p.manifests_path = "master/manifests"
	p.manifest_file = "deploy_r10k.pp"
    end

    master.vm.provision "shell",
      inline: "service iptables stop"
    
  end

##  Gitlab VM 
  config.vm.define :gitlab do |agent|

    agent.vm.provider :vmware_fusion do |v|
      v.vmx["memsize"]  = "2048"
      v.vmx["numvcpus"] = "2"
    end

    agent.vm.network :private_network, ip: "10.10.100.111"

    agent.vm.hostname = 'gitlab.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role = :agent
      pe.master = 'master.puppetlabs.vm'
    end

    agent.vm.provision "shell", 
    	inline: 'echo "PATH=$PATH:/opt/puppet/bin" >> $HOME/.bashrc'
    
    agent.vm.provision "puppet" do |p|
    	p.manifests_path = "agent/manifests"
	p.module_path = "agent/modules"
	p.manifest_file = "deploy_gitlab.pp"
     end

  end

  config.vm.define :agent1 do |agent|

    agent.vm.provider :vmware_fusion do |v|
      v.vmx["memsize"]  = "1024"
      v.vmx["numvcpus"] = "2"
    end

    agent.vm.network :private_network, ip: "10.10.100.112"

    agent.vm.hostname = 'agent1.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role = :agent
      pe.master = 'master.puppetlabs.vm'
    end

    agent.vm.provision "shell", 
    	inline: 'echo "PATH=$PATH:/opt/puppet/bin" >> $HOME/.bashrc'

  end


  config.vm.define :agent2 do |agent|

    agent.vm.provider :vmware_fusion do |v|
      v.vmx["memsize"]  = "1024"
      v.vmx["numvcpus"] = "2"
    end

    agent.vm.network :private_network, ip: "10.10.100.113"

    agent.vm.hostname = 'agent2.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role = :agent
      pe.master = 'master.puppetlabs.vm'
    end

    agent.vm.provision "shell", 
    	inline: 'echo "PATH=$PATH:/opt/puppet/bin" >> $HOME/.bashrc'

  end

  config.vm.define :agent3 do |agent|

    agent.vm.provider :vmware_fusion do |v|
      v.vmx["memsize"]  = "1024"
      v.vmx["numvcpus"] = "2"
    end

    agent.vm.network :private_network, ip: "10.10.100.114"

    agent.vm.hostname = 'agent3.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role = :agent
      pe.master = 'master.puppetlabs.vm'
    end

    agent.vm.provision "shell", 
    	inline: 'echo "PATH=$PATH:/opt/puppet/bin" >> $HOME/.bashrc'

  end

  config.vm.define :agent4 do |agent|

    agent.vm.provider :vmware_fusion do |v|
      v.vmx["memsize"]  = "1024"
      v.vmx["numvcpus"] = "2"
    end

    agent.vm.network :private_network, ip: "10.10.100.115"

    agent.vm.hostname = 'agent4.puppetlabs.vm'
    agent.vm.provision :hosts

    agent.vm.provision :pe_bootstrap do |pe|
      pe.role = :agent
      pe.master = 'master.puppetlabs.vm'
    end

  end

end

