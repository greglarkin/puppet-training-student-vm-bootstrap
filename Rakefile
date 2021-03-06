begin
  require 'open3'
  require 'os'
  require 'ptools'
rescue LoadError => e
  puts "Error during requires: \t#{e.message}"
  abort "You may be able to fix this problem by running 'bundle'."
end

task :default => 'deps'
necessary_programs = %w(VirtualBox vagrant puppet)
necessary_plugins = %w(vagrant-hosts vagrant-auto_network vagrant-pe_build)
necessary_gems = %w(bundle r10k)
dir_structure = %w(puppet puppet/modules puppet/manifests) 
file_structure = %w(puppet/Puppetfile puppet/manifests/site.pp)

# Build the environment string to pass to the vagrant commands
env_str = ""
if !ENV['NUM_AGENTS'].nil?
  env_str += "NUM_AGENTS="+ENV['NUM_AGENTS']+" "
end
if !ENV['AGENT_MEM'].nil?
  env_str += "AGENT_MEM="+ENV['AGENT_MEM']+" "
end

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
    unless bak =~ /^\.\.?$/
      puts "Backing up #{bak} to #{confdir}/puppet/#{bak}"
      unless system("rsync -av --exclude='.*' \"#{moduledir}/#{bak}\" \"#{bakmodule}\"") 
        abort "Failed to copy #{bak}, aborting..."
      end
    end
  end
  puts "Re-populating #{moduledir} with modules from Puppetfile."
  unless system("PUPPETFILE=\"#{puppetfile}\" PUPPETFILE_DIR=\"#{moduledir}\" /usr/bin/r10k puppetfile install -v")
    abort 'Failed to build out Puppet module directory. Exiting...'
  end
  puts "Pulling down pltraining/fundamentals"
  unless system("puppet module install pltraining/fundamentals --modulepath \"#{moduledir}\"")
    abort "Failed to pull down pltraining/fundamentals"
  end
end

desc "Deploy environment"
task :deploy do
  Rake::Task[:pull].execute

  puts "Bringing up vagrant machines"
  unless system("#{env_str}vagrant up --provider virtualbox") 
    abort 'Vagrant up failed. Exiting...'
  end
  puts "Training VMs Up Successfully\n"
  puts "-----"
  puts "Access master at 'vagrant ssh master' or 'ssh root@10.10.100.100'\n"
  puts "Password: puppet"
  puts "-----"
  if !ENV['NUM_AGENTS'].nil? && ENV['NUM_AGENTS'].to_i > 0
    puts "Access agents at:\n"
    1.upto(ENV['NUM_AGENTS'].to_i) do |i|
      stdout, status = Open3.capture2(ENV, 'vagrant', 'ssh', "student#{i}", '--', '/sbin/ifconfig')
      if !status
        puts "  student#{i}: Could not determine IP address"
      else
        # Ugh - search for "eth2" since the 3rd interface is bridged to
        # the host.  Then extract the IP address attached to it and print
        # the command that the student should use to connect.
        node_ip = stdout[stdout.index("eth2"),stdout.length].match(/inet addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/)[1]
        if node_ip
          puts "  student#{i}: ssh root@#{node_ip} (Password: puppet)"
        else
          puts "  student#{i}: Could not determine IP address"
        end
      end
    end
    puts "-----"
  end
  puts "Puppet modules brought in via puppet/Puppetfile are available on the Vagrant master VM at /etc/puppetlabs/puppet/modules"
  puts "-----"
  puts "Contact git owner for PRs & bug fixes"
  puts "-----"
  Rake::Task['docs']
end

desc 'Destroy Vagrant Machines'
task :destroy do
	puts "Are you sure you want to destroy the environment? [y/n]"
	STDOUT.flush
	ans = STDIN.gets.chomp
	if ans =~ /^y/
		system("#{env_str}vagrant destroy -f")
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


