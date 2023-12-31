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
  opt.on('-v', '--verbose', 'more output') { |o| args.verbose = true }
end.parse!

# get the input data
input = if args.use_test_data
    [
        "seeds: 79 14 55 13",
        "",
        "seed-to-soil map:",
        "50 98 2",
        "52 50 48",
        "",
        "soil-to-fertilizer map:",
        "0 15 37",
        "37 52 2",
        "39 0 15",
        "",
        "fertilizer-to-water map:",
        "49 53 8",
        "0 11 42",
        "42 0 7",
        "57 7 4",
        "",
        "water-to-light map:",
        "88 18 7",
        "18 25 70",
        "",
        "light-to-temperature map:",
        "45 77 23",
        "81 45 19",
        "68 64 13",
        "",
        "temperature-to-humidity map:",
        "0 69 1",
        "1 0 69",
        "",
        "humidity-to-location map:",
        "60 56 37",
        "56 93 4",
    ]
else
    file = File.open('input.txt')
    file.readlines(chomp: true)
end

def build_range(start, size)
    start..(start + size - 1)
end

def build_almanac(data, opts: {})
    almanac = OpenStruct.new
    almanac.categories = {}

    mapping = nil
    data.each do |line|
        next if line.empty? # skip empty lines

        if line.start_with?("seeds:")
            almanac.seed_data = line.split(":").last.split(" ").compact.map(&:to_i)
            almanac.seed_ranges = []
            almanac.seed_data.each_with_index do |seed, index|
                next if index % 2 == 1
                almanac.seed_ranges << build_range(seed, almanac.seed_data[index + 1])
            end
        elsif line.end_with?("map:")
            name = line.gsub(" map:", "")
            source, destination = name.split("-to-")
            mapping = OpenStruct.new(
                name: name, 
                source: OpenStruct.new(category: source, ranges: []),
                destination: OpenStruct.new(category: destination, ranges: []),
                map_data: [],
            )
            almanac.categories[mapping.name] = mapping
        else
            destination, source, size = line.split(" ").map(&:to_i)
            mapping.map_data << OpenStruct.new(
                destination: destination,
                source: source,
                size: size
            )
            mapping.source.ranges << build_range(source, size)
            mapping.destination.ranges << build_range(destination, size)
        end
    end

    almanac
end

# each line has three digits - destination, source, range size
# source
## The first line has a destination range start of 50, a source range start of 98, and a range length of 2. This line means that the source range starts at 98 and contains two values: 98 and 99. The destination range is the same length, but it starts at 50, so its two values are 50 and 51. With this information, you know that seed number 98 corresponds to soil number 50 and that seed number 99 corresponds to soil number 51.
## The second line means that the source range starts at 50 and contains 48 values: 50, 51, ..., 96, 97. This corresponds to a destination range starting at 52 and also containing 48 values: 52, 53, ..., 98, 99. So, seed number 53 corresponds to soil number 55.
# Any source numbers that aren't mapped correspond to the same destination number. 
## So, seed number 10 corresponds to soil number 10.
def map_source_to_destination(value, _source, destination, opts: {})
    # check if value is in any of the source ranges
    range = _source.ranges.find { |range| range.include?(value) }

    destination_value = if range.nil?
        value # if no value, destination == source
    else
        index = _source.ranges.each_index.find { |i| _source.ranges[i] == range }
        offset = value - range.begin
        destination.ranges[index].begin + offset
    end

    print "#{destination.category}:#{destination_value}" if opts.verbose
    destination_value
end

# map the seed to the final destination in the almanac maps
def add_seed_map(seed, almanac, opts: {})
    almanac.planting_info[seed] = []

    # initial loop values
    category = 'seed'
    value = seed

    print "#{category}:#{value}" if opts.verbose

    # loop through all mappings walking from source -> destination categories
    # until no mapping is found
    loop do
        _name, mapping = almanac.categories.find do |_name, mapping| 
            mapping.source.category == category
        end
        break if mapping.nil?
        
        print " -> " if opts.verbose
        destination_value = map_source_to_destination(value, mapping.source, mapping.destination, opts: opts)
        almanac.planting_info[seed] << {
            source: mapping.source.category, 
            source_value: value,
            destination: mapping.destination.category,
            destination_value: destination_value,
        }
        # setup next iteration of loop
        category = mapping.destination.category
        value = destination_value
    end
    puts "" if opts.verbose
end

almanac = build_almanac(input, opts: args)

puts "generating planting info... this will take a while"

almanac.planting_info = {}
almanac.seed_ranges.each do |seed_range|
    seed_range.each do |seed|
        add_seed_map(seed, almanac, opts: args)
    end
end

lowest_location = almanac.planting_info.values.first.last[:destination_value]
almanac.planting_info.values.each do |seed|
    lowest_location = seed.last[:destination_value] if seed.last[:destination_value] < lowest_location
end

puts "Lowest location is #{lowest_location}"

puts "~ Fin ~"
