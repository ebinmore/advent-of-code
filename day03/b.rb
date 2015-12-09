# Santa moves first, followed by robo-Santa
# directions, if array, Santa gets all the even numbers, including robo-Santa gets all elements with odd indices
# both start at zero

require_relative "santa"

horrible_directions = IO.read("directions.txt")

santa = Santa.new(directions: horrible_directions_even_elements)
robo_santa = Santa.new(directions: horrible_directions_odd_elements)

santa.deliver_all_presents.union(robo_santa.deliver_all_presents)

puts "Santa delivered to #{santa.deliveries.size} locations."
