# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/puppet-training-centos-6.5-pe-3.3.0"
  config.pe_build.download_root = 'https://s3.amazonaws.com/pe-builds/released/:version'
  config.pe_build.version = "3.3.0"

## Default number of nodes - can be overridden with env var on command line:
#
#  NUM_AGENTS=4 vagrant up [...]
#
#
DEFAULT_NUM_AGENTS=2

## Default agent memory size - can be overridden with env var on command line:
#
#  AGENT_MEM=768 vagrant up [...]
#
#
DEFAULT_AGENT_MEM=512

## Master
  config.vm.define :master do |master|
    master.vm.provider 'virtualbox' do |p|
      p.memory = '4096'
      p.cpus = '4'
      p.name = 'master'
      p.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    master.vm.network :private_network, ip: "10.10.100.100", :bridge => 'eth0'
    master.vm.network :public_network, :bridge => "en0: Wi-Fi (AirPort)"
    master.vm.hostname = 'master.puppetlabs.vm'
    master.vm.provision :hosts
    master.vm.provision :pe_bootstrap do |pe|
      pe.role = :master
    end
    master.vm.synced_folder "puppet/modules", "/tmp/modules"
    master.vm.synced_folder "puppet/manifests", "/tmp/manifests"
    master.vm.provision "shell", path: "bootscripts/master.sh"
  end

## Agents
  if !ENV['NUM_AGENTS'].nil?
    NUM_AGENTS = ENV['NUM_AGENTS']
  else
    NUM_AGENTS = DEFAULT_NUM_AGENTS
  end
  if !ENV['AGENT_MEM'].nil?
    AGENT_MEM = ENV['AGENT_MEM']
  else
    AGENT_MEM = DEFAULT_AGENT_MEM
  end

  1.upto(NUM_AGENTS.to_i) do |i|
    node_name = "student#{i}"
    node_ip = "10.10.100.11#{i}"

    config.vm.define node_name do |agent|
      agent.vm.provider 'virtualbox' do |p|
         p.memory = AGENT_MEM
         p.cpus = '1'
         p.name = node_name
      end
      agent.vm.network :private_network, :ip => node_ip, :bridge => 'eth0'
      agent.vm.hostname = "#{node_name}.puppetlabs.vm"
      agent.vm.provision :hosts
      agent.vm.provision :pe_bootstrap do |pe|
        pe.role   =  :agent
        pe.master = 'master.puppetlabs.vm'
      end
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

