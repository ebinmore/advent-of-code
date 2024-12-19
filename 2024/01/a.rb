require 'optparse'
require 'ostruct'

args = OpenStruct.new 
args.debug = false
args.use_test_data = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| args.debug = true }
  opt.on('-t', '--test', 'use testing data') { |o| args.use_test_data = true }
end.parse!

# location_ids
input = if args.use_test_data
  # // 3   4
  # // 4   3
  # // 2   5
  # // 1   3
  # // 3   9
  # // 3   3
  { 
      left: [3, 4, 2, 1, 3, 3],
      right: [4, 3, 5, 3, 9, 3]
  }
else
  data = { left: [], right: [] }
  filename = 'input.csv'
  File.foreach(filename, chomp: true) do |line|
    left, right = line.split(/\s+/)
    data[:left] << left.to_i
    data[:right] << right.to_i
  end
  data
end

# values in list_one & list_two pair when sorted ASC.
input[:left].sort!
input[:right].sort!

# difference between pair
puts "size: left == #{input[:left].count}, right == #{input[:right].count}"
if input[:left].count != input[:right].count
  puts "DATA MISMATCH!"
  abort
end

input[:difference] = []
input[:left].each.with_index do |left, index|
  difference = (left - input[:right][index]).abs
  input[:difference] << difference
end

# sum the differences => total distancee
puts "The total distance list is: #{input[:difference].sum}"