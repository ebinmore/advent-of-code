require_relative 'setup.rb'
require_relative 'int_computer.rb'

Setup.data.each do |data, expected|
  puts "data: #{data}"
  computer = IntComputer.new(data)
  memory = computer.run_program
  puts memory.join(',')
  puts expected
  puts "output == expected? #{memory.join(',') == expected}"
end
