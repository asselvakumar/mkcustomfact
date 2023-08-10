Facter.add(:portfolio_valuex) do
    setcode do
      tagsList = Facter.value('az_metadata.compute.tagsList')
      
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