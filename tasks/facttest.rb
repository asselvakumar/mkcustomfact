#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task Name: facttest
#
# This is where you put the ruby code for your task.
#
# You can write Puppet tasks in any language you want and it's easy to
# adapt an existing Python, PowerShell, Ruby, etc. script. Learn more at:
# https://puppet.com/docs/bolt/0.x/writing_tasks.html
#

require 'facter'

kernel = Facter.value(:kernel)
puts "My kernel is #{kernel}"
