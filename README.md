# Student VM Bootstrap
Bootstraps VM's for class in the case that students can not boot their own VMs

## Usage

1. Modify the Vagrantfile for agent VM's as you see fit, ensure the IPs are are in the correct subnet. 

2. Modify puppet/Puppetfile with the modules you need for class.

3. Run the setup:

	rake setup

4. Deploy the environment:

	Will install PE 3.3.0 on agents and deploy them along with a master
	
	```rake deploy```
	
	You *may* get an error on your first deploy for the MAC on the VM not being set, run ```rake deploy``` again **without** destroy and it should be fine. 
