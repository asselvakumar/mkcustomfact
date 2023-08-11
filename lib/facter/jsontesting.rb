
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
