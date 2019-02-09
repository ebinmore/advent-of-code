require_relative 'setup'
require_relative 'reactor'

# puts "Using the test data -- #{Setup.test_data}"
# polymer = Setup.test_data

polymer = Setup.data

puts "Removing reagent and reacting"
reagents = Reactor.breakdown(polymer)
reacted_polymers = reagents.map do |reagent|
  stripped = Reactor.scrub(polymer, reagent)
  # puts "stripped #{stripped}"
  {reagent: reagent, polymer: Reactor.ignite(stripped)}
end

reacted_polymers.each do |reacted|
  puts "#{reacted[:reagent]} reduced to #{reacted[:polymer].length}"
end

shortest_polymer = reacted_polymers.min_by do |reacted|
  puts "#{reacted[:polymer].length} : #{reacted}"
  reacted[:polymer].length
end
puts "The shortest polymer is #{shortest_polymer[:reagent]} and has a length of #{shortest_polymer[:polymer].length}"


# puts "Putting the polymer in the reactor..."
# puts
# final_polymer = Reactor.ignite(Setup.data)
# puts
# puts "There are #{final_polymer.length} units left."
