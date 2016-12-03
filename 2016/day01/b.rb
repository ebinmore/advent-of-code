require_relative "taxi"

easter_bunny_recruiting_document = IO.read("a.input")

stops = []
taxi = Taxi.new
stops << taxi.current_position

easter_bunny_recruiting_document.split(",").map(&:strip).each do |instruction|
  turn = instruction[0]
  puts "instruction = #{instruction}"
  taxi.turn_left if turn == "L"
  taxi.turn_right if turn == "R"

  distance = instruction[1..-1]
  taxi.travel(distance.to_i)
  break if stops.include?(taxi.current_position)
  stops << taxi.current_position
end

puts "The Easter Bunny's HQ is located at #{taxi.current_position}"
puts "Total distance away is #{taxi.current_position[0].abs + taxi.current_position[1].abs} blocks away."
