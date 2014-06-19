require 'os'
require 'ptools'

task :default => 'deps'

necessary_programs = %w(VirtualBox vagrant)
necessary_plugins = %w(vagrant-auto_network vagrant-pe_build oscar)
necessary_gems = %w(librarian-puppet)

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
      abort "You may be able to fix this by running \'sudo rake setup\'.\n"
    end
    puts "OK"
  end

  necessary_gems.each do |gem|
    printf "Checking for Ruby gem %s...", gem
    unless system("gem list --local -q --no-versions --no-details #{gem} | egrep '^#{gem}$'")
      puts "\nSorry, I wasn't able to find the \'#{gem}\' gem on your system."
#      abort "You may be able to fix this by running \'sudo rake setup\'.\n"
    end
    puts "OK"
  end

  puts "Congratulations! Everything looks a-ok."
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

end

desc 'Build out the modules directory for devtest'
task :modules do
  puts "Building out Puppet module directory..."
  unless system('cd puppet && librarian-puppet install --verbose')
    abort 'Failed to build out Puppet module directory. Exiting...'
  end
  puts "OK"
end
