require 'optparse'
require 'ostruct'
require 'byebug'
require 'pp'

debug = false
use_test_data = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| debug = true }
  opt.on('-t', '--test', 'use testing data') { |o| use_test_data = true }
end.parse!

data = if use_test_data
  # reports = [[levels ...], ...]
  [
    [7, 6, 4, 2, 1],
    [1, 2, 7, 8, 9],
    [9, 7, 6, 2, 1],
    [1, 3, 2, 4, 5],
    [8, 6, 4, 4, 1],
    [1, 3, 6, 7, 9],
  ]
else
  reports = []
  filename = 'input.csv'
  File.foreach(filename, chomp: true) do |line|
    reports << line.split(/\s+/).map(&:to_i)
  end
  reports
end

puts "reports: #{data.count}"
pp data if debug

# analyze the reports by finding the differences between levels
analysis = []
data.each do |report|
  differences = []
  report.each.with_index do |level, index|
    next if index == report.count - 1
    difference = report[index + 1] - level
    puts "#{level}, #{report[index + 1]}, #{difference}"
    differences << difference
  end
  analysis << differences
end

puts "differences: #{analysis.count}"
pp analysis if debug

# determine if the report is safe
# all differences are increasing or decreasing
# adjacent levels must differ by at least 1, at most 3
# safe = analysis.select do |report|
#   (report.all? { |x| x < 0} || report.all? { |x| x > 0}) &&
#   report.all? { |x| x.abs >= 1 } && 
#   report.all? { |x| x.abs <= 3 }
# end

same_direction = analysis.select do |report|
  report.all? { |x| x < 0} || report.all? { |x| x > 0}
end

puts "same direction: #{same_direction.count}"
pp  same_direction if debug

within_bounds = same_direction.select do |report|
  report.all? { |x| x.abs >= 1} && report.all? { |x| x.abs <= 3}
end

puts "within bounds: #{within_bounds.count}"
pp  within_bounds if debug

# if debug
#   data.each.with_index do |datum, index|
#     puts "data"
#     pp data[index]
#     puts "difference"
#     pp analysis[index]
#   end
# end
puts "# of SAFE reports: #{within_bounds.length}"