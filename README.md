# Student VM Bootstrap
Bootstraps VMs for class in the case that students can not boot their own VMs

## Usage

1. Choose the number of student VMs required

2. Modify puppet/Puppetfile with the modules you need for class.

3. Run the setup:

	```rake setup```

4. Deploy the environment:

	Will install PE 3.3.0 on <num> agents and deploy them along
	with a master
	
	```NUM_AGENTS=<num> rake deploy```

	A list of ssh commands will be emitted at the end of the deployment,
	one for each student VM. Distribute one command to each student that
	needs one.

5. Destroy the environment:

	```NUM_AGENTS=<num> rake destroy```
