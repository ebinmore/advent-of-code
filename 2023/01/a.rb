require 'csv'

filename = 'input.csv'
coordinates = CSV.read(filename)


first_digit_regex = /^\D*(\d)/
last_digit_regex = /(\d)\D*$/

coordinates = coordinates.map(&:first)

# get leftmost coordinate value
coordinates.map do |coord|
    {
        first: first_digit_regex.match(coord)[1],
        last: last_digit_regex.match(coord)[1]
    }
end


translated = coordinates.map do |coord|
    {
        first: first_digit_regex.match(coord)[1],
        last: last_digit_regex.match(coord)[1]
    }
end
joined = translated.map { |hash| "#{hash[:first]}#{hash[:last]}" }
total = joined.reduce(0) do |memo, coord|
    memo += coord.to_i
    memo
end
# 54388