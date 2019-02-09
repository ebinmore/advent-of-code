require_relative 'setup'
require_relative 'reactor'

# puts "Using the test data -- #{Setup.test_data}"
# final_polymer = Reactor.ignite(Setup.test_data)
# puts final_polymer
# puts 'dabCBAcaDA'

puts "Putting the polymer in the reactor..."
puts
final_polymer = Reactor.ignite(Setup.data)
puts
puts "There are #{final_polymer.length} units left."
