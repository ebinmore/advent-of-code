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
  # 0,0 is the upper-left corner
  # increasing x & y traversed down & rigth
  heredoc = <<~HEREDOC
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
  HEREDOC
  heredoc.split("\n")
else
  filename = 'input.txt'
  File.readlines(filename, chomp: true)
end

puts "DATA:"
pp data

# guard (^)
# travel pattern - straight until object (#), then turn right 90º
class Guard
  # UP, LEFT, DOWN, RIGHT
  GUARD_LOCATION = /[\^>v<]/
  # structure accommodates a 90º turn clockwise by taking the next
  # keys[(index + 1) % keys.length]
  GUARD_HEADINGS = {
    '^': [0, -1],
    '>': [1, 0],
    'v': [0, 1],
    '<': [-1, 0]
  }
  OBSTRUCTION = '#'

  # returns the guard's current location on the map as [x,y]
  def self.location(map)
    guard = nil
    map.each.with_index do |row, y|
      heading = GUARD_LOCATION.match(row)
      x = row.chars.find_index(heading[0]) if heading
      guard ||= { heading[0] => [x, y] } if x  
    end
    guard.first
  end

  def self.mark_position(map, position, character)
    row = map[position[1]].chars
    row[position[0]] = character
    map[position[1]] = row.join
    map
  end

  def self.change_heading(current_heading)
    GUARD_HEADINGS.keys[(GUARD_HEADINGS.keys.find_index(current_heading.to_sym) + 1) % GUARD_HEADINGS.keys.length]
  end

  # accepts a map and returns a new map with the guard in the next postion
  # travel path of guard is tracked with an 'X'
  # travel pattern - straight until object (#), then turn right 90º (clockwise)
  def self.travel(map)
    heading, position = self.location(map)
    puts "Guard #{heading} starts at #{position}"

    x, y = GUARD_HEADINGS[heading.to_sym]
    loop do
      # mark the current position as travelled
      map = mark_position(map, position, 'X')          

      if x < 0 || x > 0
        # puts "x: #{x}"
        # traverse in the string
        row = map[position[1]]
        break if (position[0] + x) < 0 || (position[0] + x) >= row.length
        if row.chars[position[0] + x] == OBSTRUCTION
          # turn clockwise 90º
          heading = change_heading(heading)
          x, y = GUARD_HEADINGS[heading]
          map = mark_position(map, position, heading)  
        else
          position = [position[0] + x, position[1] + y]
          map = mark_position(map, position, heading)
        end
      elsif y < 0 || y > 0
        # puts "y: #{y}"
        # traverse the array of strings
        break if (position[1] + y) < 0 || (position[1] + y) >= map.length

        # puts "next step contents - #{map[position[1] + y].chars[x]}"
        # puts "Obstruction? - #{map[position[1] + y].chars[x] == OBSTRUCTION}"
        if map[position[1] + y].chars[position[0]] == OBSTRUCTION
          heading = change_heading(heading)
          x, y = GUARD_HEADINGS[heading]
          map = mark_position(map, position, heading)          
        else
          position = [position[0], position[1] + y]
          map = mark_position(map, position, heading)
        end
      end
      pp map
    end

    map
  end
end

map = Guard.travel(data)

pp map

puts "Number of squares travelled: #{map.map{ |row| row.scan(/X/).count }.sum}"
