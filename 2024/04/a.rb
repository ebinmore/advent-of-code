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
# [0][0] is the origin
# The rows print down (higher index, lower down)
# The columns move to the right (higher index, further right)
# transform data into the directions to search:
# RIGHT (reverse for LEFT)
# DOWN   (reverse for UP)
# DOWN_LEFT   (reverse for DOWN_LEFT)
# DOWN_RIGHT  (reverse for DOWN_RIGHT)
def transform(data)
  # travel RIGHT
  right = ([] + data).map { |row| row.join }
  puts "RIGHT:"
  pp right
  puts

  # travel DOWN (higher Y) 
  # start at the first column and traverse the rows
  down = data.first.map.with_index do |char, column|
     (data.map { |row| row[column] }).join
  end
  puts "DOWN:"
  pp down
  puts

  # travel DOWN and RIGHT (increasing x & y)
  # start at origin, two passes 
  # - traverse row & column
  # - column & row, but skip the origin
  # Optimization: don't include strings shorter than XMAS
  down_and_right =[]
  # width = data.first.length
  # height = data.length
  # build diagonal strings along the x-axis
  row = data.first
  down_and_right << row.map.with_index do |char, index|
    puts "char: #{char} index: #{index} - row: #{row.join}"
    diagonal = (0..row.length).map do |increment|
      puts "increment: #{increment} - data[#{increment}][#{index + increment}]: #{data[increment][index + increment]}" if data[increment]
      data[increment][index + increment] if data[increment]
    end
    diagonal.join
  end
  puts "DOWN_AND_RIGHT (Step 1):"
  pp down_and_right
  puts
  # build diagonal strings along the y-axis
  down_and_right << data.map.with_index do |row, index|
    next if index == 0
    diagonal = (0..data.length).map do |increment|
      data[index + increment][increment] if data[index + increment]
    end
    diagonal.join
  end
  puts "DOWN_AND_RIGHT (Step 2):"
  pp down_and_right.flatten!.compact!
  puts

  # travel UP and RIGHT (decreasing y, increasing x)
  # start at the last row and travel up & right
  up_and_right = []
  up_and_right << data.reverse.first.map.with_index do |char, index|
    puts "char: #{char} index: #{index} - row: #{row.join}"
    diagonal = (0..data.first.length).map do |increment|
      puts "increment: #{increment} - data[#{increment}][#{index + increment}]: #{data[increment][index + increment]}" if data.reverse[increment]
      data.reverse[increment][index + increment] if data.reverse[increment]
    end
    diagonal.join
  end
  puts "UP_AND_RIGHT (Step 1):"
  pp up_and_right
  puts
  # build diagonal strings along the y-axis
  up_and_right << data.reverse.map.with_index do |row, index|
    next if index == 0
    diagonal = (0..data.length).map do |increment|
      data.reverse[index + increment][increment] if data.reverse[index + increment]
    end
    diagonal.join
  end
  puts "UP_AND_RIGHT (Step 2):"
  pp up_and_right.flatten!.compact!
  puts
  
  return [right, down, down_and_right, up_and_right]
end

right, down, down_and_right, up_and_right = transform(data)

# now that the data has been transformed, search for XMAS in the directions
XMAS = /XMAS/

searching = {}
searching[:right] = right.map { |row| row.scan(XMAS).count }.sum
searching[:left] = right.map { |row| row.reverse.scan(XMAS).count }.sum
searching[:down] = down.map { |row| row.scan(XMAS).count }.sum
searching[:up] = down.map { |row| row.reverse.scan(XMAS).count }.sum
searching[:down_right] = down_and_right.map { |row| row.scan(XMAS).count }.sum
searching[:up_left] = down_and_right.map { |row| row.reverse.scan(XMAS).count }.sum
searching[:up_right] = up_and_right.map { |row| row.scan(XMAS).count }.sum
searching[:down_left] = up_and_right.map { |row| row.reverse.scan(XMAS).count }.sum
searching[:total] = 
  searching[:right] + 
  searching[:left] +
  searching[:down] +
  searching[:up] +
  searching[:down_right] +
  searching[:up_left] +
  searching[:up_right] +
  searching[:down_left]

pp searching

puts "Total found: #{searching[:total]}"

