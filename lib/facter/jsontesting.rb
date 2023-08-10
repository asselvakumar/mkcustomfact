#!/usr/bin/ruby
require 'json'

$portfolio_value = ''

# Convert JSON-like string to a Puppet data structure
$tagsList = Facter.value('az_metadata.compute.tagsList')
#$tags = JSON.parse($tagsList.gsub('=>', ':'))

# Loop through the tags and find the "portfolio" value
$tagsList.each |$tag| {
  if $tag['name'] == 'portfolio' 
    $portfolio_value = $tag['value']
    break
  end
}

# Output the captured portfolio value
notice("Captured Portfolio Value: ${portfolio_value}")

