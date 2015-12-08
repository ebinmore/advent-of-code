require_relative "santa"

horrible_directions = IO.read("directions.txt")

santa = Santa.new(directions: horrible_directions)
santa.deliver_all_presents

puts "Santa delivered to #{santa.deliveries.uniq.count} locations."