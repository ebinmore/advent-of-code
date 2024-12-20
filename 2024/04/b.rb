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
  heredoc = <<~HEREDOC
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
  HEREDOC
  heredoc.split("\n").map(&:chars)
else
  filename = 'input.txt'
  File.readlines(filename, chomp: true).map(&:chars)
end
pp data

masks = [
  /M.M.A.S.S/,
  /S.M.A.S.M/,
  /M.S.A.M.S/,
  /S.S.A.M.M/,
]

# grab 3 x 3 block from data & compare to the mask
# blocks:
# MMM, MSA, AMX
# MMS, SAM, MXS
# MSX, AMX, XSX
# ...
# SAA, MMM, MAS
# AAA, MMM, ASX
blocks = data.map.with_index do |row, y|
  next if y + 3 > data.length
  (0..(row.length - 3)).map do |x|
    [
      [data[y][x], data[y][x + 1], data[y][x + 2]].join,
      [data[y + 1][x], data[y + 1][x + 1], data[y + 1][x + 2]].join,
      [data[y + 2][x], data[y + 2][x + 1], data[y + 2][x + 2]].join
  ].join if data[y + 2]
  end
end.flatten.compact

puts "3x3 BLOCKS"
pp blocks

# search blocks for _potential_ matches
matches = blocks.map do |txt|
  masks.map do |mask|
    mask.match?(txt) ? 1 : 0
  end
end

puts "MATCHES"
pp matches

puts "Total found: #{matches.map { |row| row.sum }.sum}"
