Facter.add('yahoo') do
  setcode do
    'mytest'
  end
end

Facter.add(:factertestinglinux) do
  confine kernel: 'Linux'
  setcode do
    Facter::Core::Execution.execute('ls  -lrt /etc/puppetlabs/puppet/puppet.conf')
  end
end

Facter.add(:factertestingwindows) do
  confine kernel: 'windows'
  setcode do
    Facter::Core::Execution.execute('echo Hello', timeout: 10)
  end
end

Facter.add('puppetconfstat') do
  setcode do
    ENV['TZ'] = 'America/Adak'
    Facter::Core::Execution.execute('stat -c %z /etc/puppetlabs/puppet/puppet.conf | cut -d"." -f1')
  end
end

Facter.add('folder_exists') do
  setcode do
    folder_path = '/tmp/test'
    if File.directory?(folder_path)
      'true'
    else
      'false'
    end
  end
end

Facter.add(:findfilelinux) do
  confine kernel: 'Linux'
  setcode do
    if File.exist?('/tmp/check/elastic_agent_install.sh')
      'true'
    else
      'false'
    end
  end
end


Facter.add(:az_portfolio) do
  confine :cloud_provider do |value|
    value == 'azure'
  end

  setcode do
    if Facter.value(:osfamily) == 'windows'
      'windows'
    elsif Facter.value(:osfamily) == 'RedHat'
      'redhat'
    end
  end
end

Facter.add(:find_portfolio) do
  setcode do
    portfolio_value = ''
      # Convert JSON-like string to a Puppet data structure
      tagsList = Facter.value('az_metadata.compute.tagsList')
      tags = JSON.parse($tagsList.gsub('=>', ':'))

      # Loop through the tags and find the "portfolio" value
      tags.each |$tag| {
        if tag['name'] == 'portfolio' {
          portfolio_value = tag['value']
          break
        }
      }
      
      portfolio_value
  end
end

