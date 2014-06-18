## site.pp ##

# Force noop mode unless specified otherwise in hiera
$force_noop = hiera('force_noop')
unless false == $force_noop {
    notify { "Puppet noop safety latch is enable in site.pp": }
    noop()
}

# Allow hiera to assign classes
hiera_include('classes')

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
}
