require 'byebug'
require_relative 'setup.rb'
require_relative 'breadboard.rb'
require_relative 'wire.rb'

puts '--- TEST RUN ---'
Setup.test_data.each do |name, test|
  next unless name == :simple
  puts "--------------------------------------"
  puts "Performing test: #{name}"
  puts "--------------------------------------"
  trace_one = test[:data][0]
  trace_two = test[:data][1]
  answer = test[:answer]

  puts "trace_one: #{trace_one}"
  puts "trace_two: #{trace_two}"

  breadboard = Breadboard.new(trace_one, trace_two)
  breadboard.find_intersections

  puts "answer: #{answer}"
  puts "--------------------------------------"
end
