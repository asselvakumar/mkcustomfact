require 'json'
  
Facter.add(:portfolio_value) do
    setcode do
      #tagsList_json = Facter.value('az_metadata.compute.tagsList')
      #tagsList_json.each do |key, value|
            notice(value)
        #end
        'testing'
    end
end