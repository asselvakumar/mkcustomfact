#!/usr/bin/ruby
require 'json'

$portfolio_value = undef

# Convert JSON-like string to a Puppet data structure
$tagsList = Facter.value('az_metadata.compute.tagsList')
#$tags = JSON.parse($tagsList.gsub('=>', ':'))

# Loop through the tags and find the "portfolio" value
each($tagsList) |$tag| {
  if $tag['name'] == 'portfolio' {
    $portfolio_value = $tag['value']
  }
}

# Output the captured portfolio value
if $portfolio_value != undef {
  notify { "Portfolio Value: ${portfolio_value}": }
} else {
  notify { "Portfolio Value not found": }
}

