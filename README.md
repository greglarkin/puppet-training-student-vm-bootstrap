# puppet-module-devtest-skeleton
This Rake/Vagrantfile deploys a master and agent VM with modules declared in puppet/Puppetfile. On deploy it will pull down the modules in the Puppetfile with r10k, boot a master VM and symlink in the modules live, boot a agent VM and attach it to the master. 

You can add manifests to puppet/manifests (such as a site.pp) and have the agent VM get it's classification as soon as it boots. 

If you make changes to your code locally on your host you can easily push the code to a forked upstream repo or where ever you like. It stays local and is live on the VM.

Wnat to quickly add in a bunch of modules? Great, update the Puppetfile and 'rake pull', ssh into the master and find them in $confdir/modules.

This will allow you to quickly edit the modules in puppet/modules on your host machine, in your favorite editor, while also allowing you to locally push upstream changes directly from you host while testing thost changes on live VMs.

You can pull in modules easily on deploy, for repeatable and easy to distribute environment (ie, fork this repo, add in all your modules with specific refs in git or whatever, and ship it around for QA or whatever - it'll run basically anywhere with the deps installed). 

You'll need to have downloaded and installed the following:
* VirtualBox
* Vagrant

For additional dependencies and setup see the Install section below.

# Install
```bash
$ sudo gem install bundler
$ sudo bundle
```
To check whether or not your system has all of the dependencies necessary to run the Vagrant environments:

```bash
$ rake deps
Checking environment dependencies...
...
Congratulations! Everything looks a-ok.
```

If the above step fails on available Vagrant modules, run:

```bash
$ sudo rake setup
$ rake deps
```

# Usage
To start up the environment: Pulls down modules in the Puppetfile, boots a master and an agent and symlinks in the modules in puppet/modules to the master VM. 

```bash
$ rake deploy 
```

To pull down new modules live while the VM is running:

```
Add mods to puppet/Puppetfile
$ rake pull
```

To destroy the environment:

```
$ rake destroy
```

