# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mkcustomfact::packagesample
class mkcustomfact::packagesample {
    $tagsList = $::facts['az_metadata']['compute']['tagsList']
    $tagsList.each |$tag| {
      $name = $tag['name']
      $value = $tag['value']
      if $name == 'portfolio' {
        notify { "Tag Name: ${name}, Tag Value: ${value}": }
      }
    }
  }

include packagesample
