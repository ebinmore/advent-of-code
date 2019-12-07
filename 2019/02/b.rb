require 'byebug'
require_relative 'setup.rb'
require_relative 'int_computer.rb'

# puts '--- TEST RUN ---'
# Setup.test_data.each do |data, expected|
#   puts "data: #{data}"
#   computer = IntComputer.new(data)
#   memory = computer.run_program
#   puts memory.join(',')
#   puts expected
#   puts "output == expected? #{memory.join(',') == expected}"
# end

memory = []
x, y = 0, 0
(0..99).each do |a|
  (0..99).each do |b|
    # need to pad out a & b? No.. I don't think so
    puts
    puts "--- RUN #{'%02d' % a}#{'%02d' % b} ---"

    computer = IntComputer.new(Setup.data, alarm_code: "#{'%02d' % a}#{'%02d' % b}")
    memory = computer.run_program
    puts memory.join(',')
    puts "output of memory[0]: #{memory[0]}"
    if memory[0] == 19690720
      y = b
      break;
    end
  end
  if memory[0] == 19690720
    x = a
    break
  end
end

puts "100 * x + y = #{100 * x + y}"

