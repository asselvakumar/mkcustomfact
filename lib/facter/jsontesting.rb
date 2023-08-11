require 'json'
  
Facter.add(:portfolio_value) do
    setcode do
      tagsList_json = Facter.value('az_metadata.compute.tagsList')
      pets.each |$key, $value| {notice($value)}
    end
end