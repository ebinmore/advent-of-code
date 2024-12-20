require 'optparse'
require 'byebug'
require 'pp'

debug = false
use_test_data = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| debug = true }
  opt.on('-t', '--test', 'use testing data') { |o| use_test_data = true }
end.parse!

data = if use_test_data
  <<~HEREDOC
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  HEREDOC
else
  filename = 'input.txt'
  File.readlines(filename, chomp: true).join("")
end

MUL_EXP = /mul\((\d{1,3}),(\d{1,3})\)/
DO_EXP = /do\(\)/
DONT_EXP =/don\'t\(\)/

puts "DATA"
pp data

# split by don't() commands
donts = data.split(DONT_EXP)
puts "DON'T"
pp donts
# first split is a do
dos = []
dos << donts.delete_at(0)
dos << donts.map do |dont| 
  command_strings = dont.split(DO_EXP)
  # byebug if command_strings.length > 1
  command_strings[1..]
end
dos.flatten!.compact!
puts
puts "DO"
pp dos
puts
partial_sum = dos.map do |command_string|
  matches = command_string.scan(MUL_EXP)
  puts "MATCHES"
  pp matches
  puts
  matches.map {|x, y| x.to_i * y.to_i}.sum
end

puts "SUMS"
pp partial_sum
puts partial_sum.sum