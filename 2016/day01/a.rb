require_relative "taxi"

easter_bunny_recruiting_document = IO.read("a.input")


taxi = Taxi.new
easter_bunny_recruiting_document.split(",").map(&:strip).each do |instruction|
  turn = instruction
  puts "instruction = #{instruction}"
  taxi.turn_left if turn == "L"
  taxi.turn_right if turn == "R"

  distance = instruction[1..-1]
  taxi.travel(distance.to_i)
end

puts "The final location is #{taxi.current_position}, facing #{taxi.current_facing.to_s}"
puts "Total distance away is #{taxi.current_position[0] + taxi.current_position[1]} blocks away."
