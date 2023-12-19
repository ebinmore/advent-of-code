require 'optparse'
require 'ostruct'
require 'csv'
require 'byebug'

# ------------------------------------
# METHODS
# ------------------------------------

# split input into game & grab_data 
PARSE_GAME = /^Game (\d*):(.*)$/
def parse_into_games(data)
    games = {}
    data.each do |datum|
        next if datum.strip.empty?
        match = PARSE_GAME.match(datum)
        byebug if match.nil?
        game = match[1].to_sym
        grab_data = match[2]
        
        games[game] = { grab_data: grab_data }
        games
    end

    games
end

# parse grab_data into details
PARSE_DETAILS = /(\d*)\s(blue|green|red)/
def transform_grab_data(game)
    grabs = game[:grab_data].split(";")
    game[:grabs] = []
    grabs.each_with_index do |grab, index|
        # 8 green, 6 blue, 20 red
        cube_data = grab.split(",")
        cubes = {}
        cube_data.each do |cube|
            detail_match = PARSE_DETAILS.match(cube)
            value = detail_match[1].to_i
            colour = detail_match[2].to_sym
            cubes[colour] = value
        end
        game[:grabs] <<  cubes
    end
    
    game
end

# get max number of cubes for each game by colour
def max_number_of_cubes_per_colour(game)
    red, green, blue = [0, 0, 0]
    game[:grabs].each do |grab|
        begin
            red = grab[:red] if grab.key?(:red) && red < grab[:red]
            green = grab[:green] if grab.key?(:green) && green < grab[:green]
            blue = grab[:blue] if grab.key?(:blue) && blue < grab[:blue]
        rescue Exception => ex
            byebug
        end
    end
    maximums = {
        red: red,
        green: green,
        blue: blue
    }
    game[:maximums] = maximums

    game
end

# ------------------------------------
# MAIN LOOP
# ------------------------------------
# get command line args
options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| options.debug = true }
  opt.on('-t', '--test-data', 'use testing data') { |o| options.use_test_data = true }
end.parse!

# get the input data
input = if options.use_test_data
    [
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
    ]
else
    File.readlines('input.csv') .compact
end

byebug
games = parse_into_games(input)
games.each do |key, game|
    games[key] = transform_grab_data(game)
end

games.each do |key, game|
    games[key] = max_number_of_cubes_per_colour(game)
end

# we have games with a maximum number of coloured cubes pulled for each game
MAX_CUBES_ALLOWED = {
    red: 12,
    green: 13,
    blue: 14,
}

# want to select games that have:
#  - less than or equal to the number of max coloured cubes allowed
passing_games = games.to_a.select do |game|
    game[1][:maximums][:red] <= MAX_CUBES_ALLOWED[:red] && 
    game[1][:maximums][:green] <= MAX_CUBES_ALLOWED[:green] && 
    game[1][:maximums][:blue] <= MAX_CUBES_ALLOWED[:blue]
end.to_h

sum_of_passing_games = passing_games.keys.reduce(0) { |memo, key| memo = memo + key.to_s.to_i }

puts "Sum of Passing Games:"
puts sum_of_passing_games
