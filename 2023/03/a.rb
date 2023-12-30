require 'optparse'
require 'ostruct'
require 'csv'
require 'byebug'

# ------------------------------------
# MAIN LOOP
# ------------------------------------
# get command line args
args = OpenStruct.new 
args.debug = false
args.use_test_data = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| args.debug = true }
  opt.on('-t', '--test-data', 'use testing data') { |o| args.use_test_data = true }
end.parse!

# get the input data
input = if args.use_test_data
    %w[
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
    ]
else
    file = File.open('input.txt')
    file.readlines(chomp: true)
end

# find special characters
SPECIAL_CHARACTERS = /[\*@=%\+\$&\/\-#]/
def find_special_characters(data, opts: {})
    coordinates = [] # contains [x, y]

    puts "parsing SPECIAL_CHARACTERS:" if opts.debug
    data.each_with_index do |line, y|
        offset = 0
        line.scan(SPECIAL_CHARACTERS) do |match|
            x = line.index(match, offset)
            puts "x: #{x} y: #{y} - #{match}" if opts.debug
            coordinates << [x,y]
            offset = x + 1
        end
    end

    coordinates
end

# parse all numbers from the engine map
NUMBERS = /\d+/
def find_all_potential_parts(data, opts: {})
    potential_parts = []

    data.each_with_index do |line, y|
        line.scan(NUMBERS) do |match|
            potential_part = { number: match, coordinates: [] } 
            x = line.index(match)
            # add the coordinates of all digits for the match
            (1..(match.length)).each do |index| 
                potential_part[:coordinates] << [x + (index - 1), y]
            end
            potential_parts << potential_part unless potential_part[:coordinates].empty?
        end
    end

    # array of [{ number:, coordinates: [[x,y], ..., [x+n,y]] }, ...]
    potential_parts
end

# compare position of the special with the potential part numbers
# to determine the actual part numbers
def find_engine_parts(special_characters, potential_parts, map_size, opts: {})
    parts = []
    special_characters.each do |x, y|
        # look for numbers with coordinate that are x+/-1 and/or y+/-1
        min_x = x == 0 ? x : x - 1
        max_x = x == map_size[:x] ? x : x + 1
        x_range = (min_x)..(max_x)

        min_y = y == 0 ? y : y - 1
        max_y = y == map_size[:y] ? y : y + 1
        y_range = (min_y)..(max_y)

        puts "finding engine parts: for #{x}, #{y}" if opts.debug
        potential_parts.select do |potential_part|
            coordinates = potential_part[:coordinates]
            found = coordinates.select do |coordinate|
                coordinate.first >= x_range.first && 
                coordinate.first <= x_range.last &&
                coordinate.last >= y_range.first &&
                coordinate.last <= y_range.last
            end
            puts "found: #{potential_part}" if opts.debug && !found.empty?
            parts << potential_part unless found.empty?
        end
    end
    parts
end

def map_engine(engine, opts: {})
    map_size = { x: engine[:map].first.length - 1, y: engine[:map].count - 1 }
    engine[:special_characters] = find_special_characters(engine[:map], opts: opts)
    engine[:potential_parts] = find_all_potential_parts(engine[:map], opts: opts)
    engine[:parts] = find_engine_parts(engine[:special_characters], engine[:potential_parts], map_size, opts: opts)
end

engine = { map: input }
map_engine(engine, opts: args)

# calculate puzzle total
part_numbers = engine[:parts].map do |part|
    part[:number].to_i
end

total = part_numbers.reduce(0) { |sum, n| sum += n }

byebug

puts "total: #{total}"
puts "Fin"
