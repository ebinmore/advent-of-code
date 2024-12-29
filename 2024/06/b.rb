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

def print_map(map)
  puts "  #{(0..(map.first.length - 1)).map(&:to_s).join(" ")}"
  map.each_with_index do |row, index|
    puts "#{index} #{row.chars.join(" ")}"
  end
end

# guard (^)
# travel pattern - straight until object (#), then turn right 90º
class Guard
  # UP, LEFT, DOWN, RIGHT
  GUARD_LOCATION = /[\^>v<]/
  # structure accommodates a 90º turn clockwise by taking the next
  # keys[(index + 1) % keys.length]
  GUARD_HEADINGS = {
    '^' => [0, -1],
    '>' => [1, 0],
    'v' => [0, 1],
    '<' => [-1, 0]
  }
  MARKERS = {
    '^' => '|',
    '>' => '-',
    'v' => '|',
    '<' => '-',
    '90' => '+'
  }
  OBSTRUCTION = '#'
  TEMPORARY_OBSTRUCTION = 'O'

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
    if map[position[1]]&.chars
      row = map[position[1]].chars
      row[position[0]] = character unless [OBSTRUCTION, TEMPORARY_OBSTRUCTION].include?(row[position[0]])
      map[position[1]] = row.join
    else
      puts "NO CHARACTERS FOUND FOR"
      puts "position: #{position}"
      puts "character: #{character}"
      print_map(map)
    end
    map
  end

  def self.change_heading(current_heading)
    GUARD_HEADINGS.keys[(GUARD_HEADINGS.keys.find_index(current_heading) + 1) % GUARD_HEADINGS.keys.length]
  end

  def self.find_loop(map, heading, path)
    last_end = path.last[:end]
    
    (0..(path.length - 4)).each do |index|
      first = path[index]
      first_start = first[:start]

      new_heading = change_heading(heading)
      x, y = GUARD_HEADINGS[new_heading]

      # puts "((loop_end[0] - loop_start[0]) * GUARD_HEADINGS[heading][0]): #{((loop_end[0] - loop_start[0]) * GUARD_HEADINGS[heading][0])}"
      # puts "((loop_end[1] -  loop_start[1]) * GUARD_HEADINGS[heading][1]): #{((loop_end[1] -  loop_start[1]) * GUARD_HEADINGS[heading][1])}"
      # intersect the loop_start line segment from the loop_end travelling in the new_heading
      if (
          (((last_end[0] - first_start[0]) * GUARD_HEADINGS[heading][0]) == 0) && 
          (((last_end[1] -  first_start[1]) * GUARD_HEADINGS[heading][1]) == 0)
        )
        puts "last_end: #{last_end}"
        puts "loop_start: #{first_start}"
        puts "new heading: [x, y] = [#{x}, #{y}]"
        puts "new_heading: ((last_end[0] - first[:end][0]) * x) = #{((last_end[0] - first[:end][0]) * x)}"
        puts "new_heading: ((last_end[1] -  first[:end][1]) * y) = #{((last_end[1] -  first[:end][1]) * y)}"
        puts "mark_position? #{(((last_end[0] - first[:end][0]) * x) <= 0) && (((last_end[1] -  first[:end][1]) * y) <= 0)}"
        if (((last_end[0] - first[:end][0]) * x) <= 0) && (((last_end[1] -  first[:end][1]) * y) <= 0)
          # mark possible obstruction on the next space
          temporary_obstruction_position = [
            last_end[0] + GUARD_HEADINGS[heading][0], 
            last_end[1] + GUARD_HEADINGS[heading][1]
          ]
          byebug if temporary_obstruction_position == [2, 5]
          
          if (temporary_obstruction_position[0] >= 0 || temporary_obstruction_position[0] < map.first.length) || 
            (temporary_obstruction_position[1] >= 0 || temporary_obstruction_position[1] < map.length)
            map = mark_position(map, temporary_obstruction_position, TEMPORARY_OBSTRUCTION)
          end
        end
      end
    end
    
    map
  end

  # accepts a map and returns a new map with the guard in the next postion
  # travel path of guard is tracked with an 'X'
  # travel pattern - straight until object (#), then turn right 90º (clockwise)
  def self.travel(map)
    heading, position = self.location(map)
    puts "Guard #{heading} starts at #{position}"

    x, y = GUARD_HEADINGS[heading]
    travel_marker = MARKERS[heading]

    line_segments = []
    line_segments << { start: position, end: position }
    loop do
      # mark the current position as travelled
      map = mark_position(map, position, travel_marker)          

      if x < 0 || x > 0
        # traverse in the string
        row = map[position[1]]
        break if (position[0] + x) < 0 || (position[0] + x) >= row.length
        if row.chars[position[0] + x] == OBSTRUCTION
          # turn clockwise 90º
          heading = change_heading(heading)
          x, y = GUARD_HEADINGS[heading]
          travel_marker = MARKERS['90']
          line_segments << { start: position, end: position }
          map = mark_position(map, position, heading)  
        else
          travel_marker = MARKERS[heading]
          position = [position[0] + x, position[1] + y]
          map = mark_position(map, position, heading)
          line_segments.last[:end] = position
          map = find_loop(map, heading, line_segments) unless line_segments.length < 4
        end
      elsif y < 0 || y > 0
        # traverse the array of strings
        break if (position[1] + y) < 0 || (position[1] + y) >= map.length

        if map[position[1] + y].chars[position[0]] == OBSTRUCTION
          heading = change_heading(heading)
          x, y = GUARD_HEADINGS[heading]
          travel_marker = MARKERS['90']
          line_segments << { start: position, end: position }
          map = mark_position(map, position, heading)          
        else
          travel_marker = MARKERS[heading]
          position = [position[0], position[1] + y]
          map = mark_position(map, position, heading)
          line_segments.last[:end] = position
          map = find_loop(map, heading, line_segments) unless line_segments.length < 4
        end
      end
      pp map
    end

    [map, line_segments]
  end
end

map, line_segments = Guard.travel(data)

print_map(map)

pp line_segments

puts "Number of possible obstructions: #{map.map{ |row| row.scan(/O/).count }.sum}"
