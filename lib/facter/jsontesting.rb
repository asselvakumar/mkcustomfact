require 'json'

Facter.add(:portfolio_value) do
    setcode do
      tagsList_json = Facter.value('az_metadata.compute.tagsList')
      tagsList = JSON.parse(tagsList_json)
      portfolio_value = ''
  
      tagsList.each do |tag|
        if tag['name'] == 'portfolio'
          portfolio_value = tag['value']
          break
        end
      end
  
      portfolio_value
    end
end
  