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
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  HEREDOC
else
  filename = 'input.txt'
  File.readlines(filename, chomp: true).join("")
end

OPERATOR_EXPRESSION = /mul\((\d{1,3}),(\d{1,3})\)/
matches = data.scan(OPERATOR_EXPRESSION)
puts matches.map {|x, y| x.to_i * y.to_i}.sum