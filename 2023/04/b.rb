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
args.verbose = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| args.debug = true }
  opt.on('-t', '--test-data', 'use testing data') { |o| args.use_test_data = true }
  opt.on('-v', '--verbose', 'more logging output') { |o| args.verbose = true }
end.parse!

# get the input data
input = if args.use_test_data
    [
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
        "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
        "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
        "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
        "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
        "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
    ]
else
    file = File.open('input.txt')
    file.readlines(chomp: true)
end

def parse_scratch_card(data)
    card = OpenStruct.new
    game, game_data = data.split(":")

    # assign the card number
    byebug if game.nil?
    card.game = game.match(/\d+/).to_s.to_i

    # parse out the winning and game numbers
    winning, game = game_data.split("|").map { |numbers| numbers.split(" ").compact.map(&:to_i) }
    card.winning_numbers = winning
    card.game_numbers = game

    # find matching numbers
    card.matches = card.game_numbers.select do |game_number| 
        card.winning_numbers.include?(game_number)
    end

    card.multiple = 1

    card
end

scratch_cards = []
input.each do |line|
    scratch_cards << parse_scratch_card(line) unless line.empty?
end

# calculate the multiples
scratch_cards.each_with_index do |card, index|
    winning_numbers = card.matches.count

    puts "Card #{card.game}: winning_numbers #{winning_numbers} | multiple #{card.multiple}" if args.verbose
    byebug if args.debug
    if winning_numbers > 0
        (1..winning_numbers).each do |duplicate_index|
            byebug if args.debug
            duplicate_card = scratch_cards[index + duplicate_index]
            duplicate_card.multiple += 1 * card.multiple
            puts "\tduplicate card #{duplicate_card.game}: multiple #{duplicate_card.multiple}" if args.verbose
        end
    end
end

multiples = scratch_cards.map { |card| card.multiple }
total = multiples.reduce(0) { |sum, multiple| sum += multiple }

puts "Total: #{total}"
puts "~ Fin ~"

