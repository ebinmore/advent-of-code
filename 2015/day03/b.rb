# Santa moves first, followed by robo-Santa
# directions, if array, Santa gets all the even numbers, including robo-Santa gets all elements with odd indices
# both start at zero
require_relative "santa"

horrible_directions = IO.read("directions.txt")

santas_directions = horrible_directions.chars.select.with_index { |direction, index| (index + 1) % 2 == 0 }
robo_santas_directions = horrible_directions.chars.select.with_index { |direction, index| (index + 1) % 2 == 1 }

santa = Santa.new(directions: santas_directions.join)
robo_santa = Santa.new(directions: robo_santas_directions.join)

santa.deliver_all_presents
robo_santa.deliver_all_presents
puts "Santa's deliveries #{santa.deliveries.size}"
puts "robo-Santa's deliveries #{robo_santa.deliveries.size}"

all_deliveries = Set.new
all_deliveries = santa.deliveries | robo_santa.deliveries
puts "Santa & robo-Santa delivered to #{all_deliveries.size} locations."
