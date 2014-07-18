begin
  require 'os'
  require 'ptools'
rescue LoadError => e
  puts "Error during requires: \t#{e.message}"
  abort "You may be able to fix this problem by running 'bundle'."
end

task :default => 'deps'

necessary_programs = %w(VirtualBox vagrant)
necessary_plugins = %w(vagrant-auto_network vagrant-pe_build vagrant-vmware-fusion)
necessary_gems = %w(bundle librarian-puppet)

desc 'Check for the environment dependencies'
task :deps do
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
      puts "\nSorry, I wasn't able to find the Vagrant plugin \'#{plugin}\' on your system."
      abort "You may be able to fix this by running 'rake setup\'.\n"
    end
    puts "OK"
  end

  necessary_gems.each do |gem|
    printf "Checking for Ruby gem %s...", gem
    unless system("gem list --local -q --no-versions --no-details #{gem} | egrep '^#{gem}$' > /dev/null 2>&1")
      puts "\nSorry, I wasn't able to find the \'#{gem}\' gem on your system."
      abort "You may be able to fix this by running \'gem install #{gem}\'.\n"
    end
    puts "OK"
  end

  printf "Checking for additional gems via 'bundle check'..."
  unless %x{bundle check}
    abort ''
  end
  puts "OK"

  puts "\n" 
  puts '*' * 80
  puts "Congratulations! Everything looks a-ok."
  puts '*' * 80
  puts "\n"
end

desc 'Install the necessary Vagrant plugins'
task :setup do
  necessary_plugins.each do |plugin|
    unless system("vagrant plugin install #{plugin} --verbose")
      abort "Install of #{plugin} failed. Exiting..."
    end
  end

  necessary_gems.each do |gem|
    unless system("gem install #{gem}")
      abort "Install of #{gem} failed. Exiting..."
    end
  end

  unless %x{bundle check} 
    system('bundle install')
  end

end

desc 'Build out the modules directory for devtest'
task :modules do
  puts "Building out Puppet module directory..."
  confdir = Dir.pwd
  moduledir = "#{confdir}/puppet/modules"
  puppetfile = "#{confdir}/puppet/Puppetfile"
  puts "Placing modules in #{moduledir}"
  puts "Using Puppetfile at #{puppetfile}"
  unless system("PUPPETFILE=#{puppetfile} PUPPETFILE_DIR=#{moduledir} /usr/bin/r10k puppetfile install")
    abort 'Failed to build out Puppet module directory. Exiting...'
  end
  puts "OK"
end
