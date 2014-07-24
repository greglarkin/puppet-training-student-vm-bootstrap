# Puppet Training Bootstrap
This vagrant environment deploys a puppet master, agent and ubuntu agent for use in public/private trainings.

## Deployment
I wanted to create a way to easily write modules using my local editor and dotfiles (tmux etc) but have them available on the VM for class. 

To do this I wrote a Rakefile that pulls down modules via r10k (if needed) and adds them to puppet/modules, then deploys the three VM's I use most often in class.

1. Master

	A standard master VM 

2. Agent

	A standard agent for testing code on / demonstration

3. Ubuntu Agent

	Useful during the Apache lab to test multi-OS modules

## Pipeline

1. Add modules to ```puppet/Puppetfile```

	I usually add puppetlabs-apache, mysql, stdlib, etc that I will need during the training. 

1. ```rake setup```
2  ```rake deploy```

If for some reason you cloned this repo and the directory structure got hosed you can use

	```rake create_structure```


