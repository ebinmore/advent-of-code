require_relative "taxi"
require_relative "map"

easter_bunny_recruiting_document = IO.read("a.input")

taxi = Taxi.new
map = Map.new({ start: taxi.current_position })
stops = []
stops << taxi.current_position

easter_bunny_recruiting_document.split(",").map(&:strip).each do |instruction|
  turn = instruction[0]
  puts "instruction = #{instruction}"
  taxi.turn_left if turn == "L"
  taxi.turn_right if turn == "R"

  distance = instruction[1..-1]
  taxi.travel(distance.to_i)

  stops << taxi.current_position
  map.trace_route(taxi.current_position)
end

puts "The Easter Bunny's HQ is located at #{map.intersections[0]}"
puts "Total distance away is #{map.intersections[0][0].abs + map.intersections[0][1].abs} blocks away."
