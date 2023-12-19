require 'csv'

# MATCH BOTH THE NUMERIC AND TEXTUAL VALUES
# THEN COMPARE THEM AND SEE WHICH IS SHORTER 
# (ie. closer the beginning or end of the string)
def choose_text_or_numeric(text_match, numeric_match)
    return numeric_match if text_match.nil?
    return text_match if numeric_match.nil?
    
    text_match[0].size < numeric_match[0].size ? text_match : numeric_match
end

# CONVERT THE NUMERIC OR TEXTUAL VALUES TO NUMBERS
def translate_to_number(input)
    # print "input: #{input} - "
    begin
        value = Integer(input)
    rescue ArgumentError
        # print "not a number"
    end

    unless value.is_a?(Integer)
        value = case input
        when 'one'
            1
        when 'two'
            2
        when 'three'
            3
        when 'four'
            4
        when 'five'
            5
        when 'six'
            6
        when 'seven'
            7
        when 'eight'
            8
        when 'nine'
            9
        when 'zero' 
            0
        end
    end

    # puts " #{value}"
    value
end


# READ THE INPUT FILE
filename = 'input.csv'
coordinates = CSV.read(filename)
coordinates = coordinates.map(&:first)

# REGULAR EXPRESSIONS TO MATCH THE "DIGIT"
first_text_digit = /^\D*?(one|two|three|four|five|six|seven|eight|nine)/
first_numeric_digit = /^\D*?(\d)/

last_text_digit = /(one|two|three|four|five|six|seven|eight|nine)\D*?$/
last_text_digit_by_reversing = /^\D*?(enin|thgie|neves|xis|evif|ruof|eerht|owt|eno)/
last_numeric_digit = /(\d)\D*?$/
last_numeric_digit_by_reversing = /^\D*?(\d)/

# TEST INPUT
test_input = %w[
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
]
# coordinates = test_input

# BEGIN PROCESSING THE INPUT

# get the match data for each input
matched = coordinates.map do |input|
    {
        first_text_match: first_text_digit.match(input),
        first_numeric_match: first_numeric_digit.match(input),
        last_text_match: last_text_digit.match(input),
        last_numeric_match: last_numeric_digit.match(input),
        last_text_digit_by_reversing: last_text_digit_by_reversing.match(input.reverse),
        last_numeric_digit_by_reversing: last_numeric_digit_by_reversing.match(input.reverse)
    }
end

# puts "matched:"
# puts matched

# choose the textual or numeric matched value
choosen = matched.map do |coordinate|
    {
        first: choose_text_or_numeric(coordinate[:first_text_match], coordinate[:first_numeric_match]),
        last: choose_text_or_numeric(coordinate[:last_text_digit_by_reversing], coordinate[:last_numeric_digit_by_reversing])
    }
end

# puts "chosen:"
# puts choosen

# convert the textual values to numbers
as_integers = choosen.map do |hash|
    [translate_to_number(hash[:first][1]), translate_to_number(hash[:last][1].reverse)]
end
# => [[2, 9], [3, 8], [1, 3], [1, 4], [4, 2], [8, 4], [7, 6]]
# puts "as_integers:"
# puts as_integers

# turn the front and tail together to form a single number
joined = as_integers.map { |array| "#{array[0]}#{array[1]}" }
# puts "joined:"
# puts joined

# sum the values
puts "totalling:"
total = joined.reduce(0) do |memo, coord|
    puts "Adding #{coord} to #{memo}"
    memo += coord.to_i
    memo
end

puts "total: #{total}"
# 53515