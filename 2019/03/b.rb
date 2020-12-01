require 'byebug'
require_relative 'setup.rb'
require_relative 'breadboard.rb'
require_relative 'wire.rb'

puts '--- TEST RUN ---'
Setup.test_data.each do |name, test|
  # next unless name == :simple
  puts '--------------------------------------'
  puts "Performing test: #{name}"
  puts '--------------------------------------'
  trace_one = test[:data][0]
  trace_two = test[:data][1]

  puts "trace_one: #{trace_one}"
  puts "trace_two: #{trace_two}"

  breadboard = Breadboard.new(trace_one, trace_two)
  breadboard.find_intersections

  intersections = breadboard.intersections

  # get the steps per intersection
  wire_one = breadboard.wire_one
  wire_two = breadboard.wire_two

  steps = intersections.map do |intersection|
    index = wire_one.line_segments.index(intersection[:line_segments][:one])
    # need a deep clone of the objects in wire_one
    path = { wire_one: Marshal.load(Marshal.dump(wire_one.line_segments[0..index])), steps: 0 }
    # need to end the last line segment at the intersection point
    path[:wire_one].last[:b] = intersection[:point]

    path[:steps] = path[:wire_one].reduce(0) do |memo, seg|
      memo = memo + (seg[:a][0] - seg[:b][0]).abs + (seg[:a][1] - seg[:b][1]).abs
      memo
    end

    index = wire_two.line_segments.index(intersection[:line_segments][:two])
    # need a deep clone of the object in wire_two
    path[:wire_two] = Marshal.load(Marshal.dump(wire_two.line_segments[0..index]))
    # need to end the last line segment at the intersection point
    path[:wire_two].last[:b] = intersection[:point]

    path[:steps] = path[:wire_two].reduce(path[:steps]) do |memo, seg|
      memo = memo + (seg[:a][0] - seg[:b][0]).abs + (seg[:a][1] - seg[:b][1]).abs
      memo
    end

    puts "Number of steps for intersection #{intersection[:point]} is #{path[:steps]}"
    puts
    path[:steps]
  end

  puts "Minimum number of steps is #{steps.min}"
  puts "Confirmation: #{test[:steps]}"
end


puts '--------------------------------------'
puts '--- ACTUAL RUN                     ---'
puts '--------------------------------------'
breadboard = Breadboard.new(Setup.wire_one, Setup.wire_two)
breadboard.find_intersections

# get the steps per intersection
wire_one = breadboard.wire_one
wire_two = breadboard.wire_two

steps = breadboard.intersections.map do |intersection|
  index = wire_one.line_segments.index(intersection[:line_segments][:one])
  # need a deep clone of the objects in wire_one
  path = { wire_one: Marshal.load(Marshal.dump(wire_one.line_segments[0..index])), steps: 0 }
  # need to end the last line segment at the intersection point
  path[:wire_one].last[:b] = intersection[:point]

  path[:steps] = path[:wire_one].reduce(0) do |memo, seg|
    memo = memo + (seg[:a][0] - seg[:b][0]).abs + (seg[:a][1] - seg[:b][1]).abs
    memo
  end

  index = wire_two.line_segments.index(intersection[:line_segments][:two])
  # need a deep clone of the object in wire_two
  path[:wire_two] = Marshal.load(Marshal.dump(wire_two.line_segments[0..index]))
  # need to end the last line segment at the intersection point
  path[:wire_two].last[:b] = intersection[:point]

  path[:steps] = path[:wire_two].reduce(path[:steps]) do |memo, seg|
    memo = memo + (seg[:a][0] - seg[:b][0]).abs + (seg[:a][1] - seg[:b][1]).abs
    memo
  end

  puts "Number of steps for intersection #{intersection[:point]} is #{path[:steps]}"
  puts
  path[:steps]
end

puts "Minimum number of steps is #{steps.min}"
puts '--------------------------------------'
