begin
  require 'os'
  require 'ptools'
rescue LoadError => e
  puts "Error during requires: \t#{e.message}"
  abort "You may be able to fix this problem by running 'bundle'."
end

task :default => 'deps'
necessary_programs = %w(VirtualBox vagrant)
necessary_plugins = %w(vagrant-hosts vagrant-auto_network vagrant-pe_build)
necessary_gems = %w(bundle r10k)
dir_structure = %w(puppet puppet/modules puppet/manifests) 
file_structure = %w(puppet/Puppetfile puppet/manifests/site.pp)

desc "Setup the local environment" 
task :setup do
  puts 'Checking environment dependencies...'

  printf "Is this a POSIX OS?..."
  unless OS.posix?
    abort 'Sorry, you need to be running Linux or OSX to use this Vagrant environment!'
  end
  puts "OK"
 
  necessary_programs.each do |prog| 
    printf "Checking for %s...", prog
    unless File.which(prog)
      abort "\nSorry but I didn't find require program \'#{prog}\' in your PATH.\n"
    end
    puts "OK"
  end

  
  necessary_plugins.each do |plugin|
	printf "Checking for vagrant plugin %s...", plugin
    	unless %x{vagrant plugin list}.include? plugin
		puts "The Vagrant plugin #{plugin} wasn't found, installing..."
    		unless system("vagrant plugin install #{plugin} --verbose")
      			abort "Install of #{plugin} failed. Exiting..."
		end
    	end
	puts "OK"
  end

  necessary_gems.each do |gem|
 	printf "Checking for Ruby gem %s...", gem
    	unless system("gem list --local -q --no-versions --no-details #{gem} | egrep '^#{gem}$' > /dev/null 2>&1")
		puts "The Gem #{gem} wasn't found, installing..."
    		unless system("gem install #{gem}")
      			abort "Install of #{gem} failed. Exiting..."
		end
    	end
	puts "OK"
	printf "Checking for additional gems via 'bundle check'..."
  	unless %x{bundle check}
    		abort ''
  	end
  	puts "OK"
  end

  unless %x{bundle check} 
    system('bundle install')
  end
  Rake::Task[:create_structure].execute
end

desc "Create dir structure"
task :create_structure do 
puts "Checking CWD for directory structure..."
  dir_structure.each do |d|
	cwd = Dir.getwd
	check_dir = "#{cwd}/#{d}"
	if Dir.exists?(check_dir)
		puts "#{check_dir} exists, moving on."
	else
		puts "#{check_dir} does not exist, creating it."
		Dir.mkdir("#{check_dir}", 0777)
	end
  end
  file_structure.each do |f|
	fqp = "#{Dir.getwd}/#{f}"
	if File.exists?(fqp)
		puts "#{fqp} exists, moving on."
	elsif f == "puppet/Puppetfile" 
		puts "Writing a base Puppetfile with 'stdlib'"
		File.open(fqp, 'w') {|file| file.write("mod 'stdlib', :git => 'https://github.com/puppetlabs/puppetlabs-stdlib'")}
	else
		puts "Creating stub file for #{f}"
		File.open(fqp, 'w') {|file| file.write("# STUB FILE FOR #{f}")}
	end
  end
end

desc 'Deploying modules from Puppetfile and booting master and agent VMs' 
task :pull do
  puts "Building out Puppet module directory..."
  confdir = Dir.pwd
  moduledir = "#{confdir}/puppet/modules"
  bakmodule = "#{confdir}/puppet/bak_modules"
  puppetfile = "#{confdir}/puppet/Puppetfile"
  existing_mods = Dir.foreach(moduledir) do |bak|
	puts "Backing up #{bak} to #{confdir}/puppet/#{bak}"
	unless system("rsync -av --exclude='.*' \"#{moduledir}/#{bak}\" \"#{bakmodule}\"") 
		abort "Failed to copy #{bak}, aborting..."
	end
  end
  puts "Re-populating #{moduledir} with modules from Puppetfile."
  unless system("PUPPETFILE=\"#{puppetfile}\" PUPPETFILE_DIR=\"#{moduledir}\" /usr/bin/r10k puppetfile install -v")
    abort 'Failed to build out Puppet module directory. Exiting...'
  end
  puts "Pulling down pltraining/fundamentals"
  unless system("/opt/puppet/bin/puppet module install pltraining/fundamentals --modulepath \"#{moduledir}\"")
	  abort "Failed to pull down pltraining/fundamentals"
  end
end

desc "Deploy environment"
task :deploy do
  Rake::Task[:pull].execute

  puts "Bringing up vagrant machines"
  unless system("vagrant up") 
	  abort 'Vagrant up failed. Exiting...'
  end
  puts "Training VM's Up Successfully\n"
  puts "-----"
  puts "Access master at 'vagrant ssh master' or 'ssh root@10.10.100.100'\n"
  puts "Password = puppet"
  puts "-----"
  puts "Student VM's:\n"
  puts "agent[1-5].puppetlabs.vm"
  puts "root/puppet"
  puts "-----"
  puts "Puppet modules brought in via puppet/Puppetfile are available on the Vagrant master VM at /etc/puppetlabs/puppet/modules"
  puts "-----"
  puts "Contact git owner for PR's & bug fixes"
  puts "-----"
  Rake::Task['docs']
end

desc 'Destroy Vagrant Machines'
task :destroy do
	puts "Are you sure you want to destroy the environment? [y/n]"
	STDOUT.flush
	ans = STDIN.gets.chomp
	if ans =~ /^y/
		system("vagrant destroy -f")
	else
		abort 'Aborting vagrant destroy, exiting...'
	end		
end

desc 'serve the puppet docs website locally'
task :docs do
	puts "Is this your first time running docs? (we may need to generate the content if so)"
	gen = STDIN.gets 
	if gen =~ /^y/
		Dir.chdir('puppet-docs')
		unless system('rake generate')
			abort 'Failed to generate docs, aborting.'
		end
	else
		puts "Ok, serving docs - if you have content issues or need to update consider running 'rake docs' and 'y' to the previous question\n"
		puts "---"
	end
	Dir.chdir('puppet-docs')
	unless system('rackup')
		abort 'Failed to serve docs'
	end
end


