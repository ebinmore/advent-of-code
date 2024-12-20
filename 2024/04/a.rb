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

# def print_cartesian(array)
#   # reverse the order of the rows to print the highest y row first
#   array.reverse.each { |row| pp row }
# end

byebug
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
    ([char] + data.map { |row| row[column] }).join
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
  down_and_right << data.first.map.with_index do |char, index|
    diagonal = [char] + (0..data.first.length).map do |increment|
      data[index + increment][index + increment] if data[index + increment]
    end
    diagonal.join
  end
  puts "DOWN_AND_RIGHT (Step 1):"
  pp down_and_right
  puts
  # build diagonal strings along the y-axis
  down_and_right << data.map.with_index do |row, index|
    next if index == 0
    diagonal = [row[0]] + (0..data.length).map do |increment|
      data[index + increment][index + increment] if data[index + increment]
    end
    # byebug
    diagonal.join
  end
  puts "DOWN_AND_RIGHT (Step 2):"
  pp down_and_right.flatten!.compact!
  puts
  byebug

  # return [right, up, down_right, down_left]
end

right, up, up_and_right, down_right = transform(data)


