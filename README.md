# puppet-module-devtest-skeleton

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
$ rake pull
```

To destroy the environment:

```
$ rake destroy
```

