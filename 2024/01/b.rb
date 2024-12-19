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

puts "size: left == #{input[:left].count}, right == #{input[:right].count}"
if input[:left].count != input[:right].count
  puts "DATA MISMATCH!"
  abort
end

input[:similarity] = []
# calculate similarity score
# left value is in right x times, so similarity == value * x
input[:left].each do |left|
  count = input[:right].select { |right| right == left }.count
  input[:similarity] << left * count
end

# total similarity score is the sum of all similarities
# sum the similarity => total similarity
puts "The total similarity list is: #{input[:similarity].sum}"