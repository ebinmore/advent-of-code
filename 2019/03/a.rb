require 'byebug'
require_relative 'setup.rb'
require_relative 'breadboard.rb'
require_relative 'wire.rb'

puts '--- TEST RUN ---'
Setup.test_data.each do |name, test|
  puts '--------------------------------------'
  puts "Performing test: #{name}"
  puts '--------------------------------------'
  trace_one = test[:data][0]
  trace_two = test[:data][1]
  manhattan_distance = test[:manhattan_distance]

  puts "trace_one: #{trace_one}"
  puts "trace_two: #{trace_two}"

  breadboard = Breadboard.new(trace_one, trace_two)
  breadboard.find_intersections

  intersections = breadboard.intersections
  manhattan_distances = intersections.map do |intersection|
    intersection[:point][0].abs + intersection[:point][1].abs
  end

  puts "the shortest manhattan distance is: #{manhattan_distances.min}"

  puts "confirmation: #{manhattan_distance}"
  puts '--------------------------------------'
end


puts '--------------------------------------'
puts '--- ACTUAL RUN                     ---'
puts '--------------------------------------'
breadboard = Breadboard.new(Setup.wire_one, Setup.wire_two)
breadboard.find_intersections

intersections = breadboard.intersections
manhattan_distances = intersections.map do |intersection|
  intersection[:point][0].abs + intersection[:point][1].abs
end

puts "the shortest manhattan distance is: #{manhattan_distances.min}"
puts '--------------------------------------'
