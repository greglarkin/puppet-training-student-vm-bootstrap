# Make sure that Hiera is configured for the master so that we
# enabling the use of Hiera within student environments.
#
# Paramters:
# * $autoteam: automatically create simple teams for Capstone. Defaults to false.
#
class fundamentals::master::hiera (
  $autoteam = false,
) {
  validate_bool($autoteam)

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/puppetlabs/puppet/hieradata':
    ensure => directory,
  }

  file { '/etc/puppetlabs/puppet/hieradata/defaults.yaml':
    ensure  => file,
    source  => 'puppet:///modules/fundamentals/defaults.yaml',
    replace => false,
  }

  # place the environments link in place only on the master
  file { '/etc/puppetlabs/puppet/hieradata/environments':
    ensure => link,
    target => '/etc/puppetlabs/puppet/environments',
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure => file,
    source => 'puppet:///modules/fundamentals/hiera.master.yaml',
  }

  if $autoteam {
    file { '/etc/puppetlabs/puppet/hieradata/teams.yaml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('fundamentals/teams.yaml.erb'),
      replace => false,
    }
  }
}
