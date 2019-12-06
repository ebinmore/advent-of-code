require 'byebug'
require_relative 'setup.rb'
require_relative 'int_computer.rb'

puts '--- TEST RUN ---'
Setup.test_data.each do |data, expected|
  puts "data: #{data}"
  computer = IntComputer.new(data)
  memory = computer.run_program
  puts memory.join(',')
  puts expected
  puts "output == expected? #{memory.join(',') == expected}"
end

puts
puts '--- ACTUAL RUN ---'
computer = IntComputer.new(Setup.data, alarm_code: '1202')
memory = computer.run_program
puts memory.join(',')
puts "output of memory[0]: #{memory[0]}"
