


current_frequency = 0
readings = IO.readlines('./data', "\n").map(&:strip).map(&:to_i)
previous_frequencies = []
loop do
  previous_frequencies << current_frequency
  reading = readings.shift # get the next reading
  puts "current_frequency = #{current_frequency}\t\treading = #{reading}\t\tnext_frequency = #{current_frequency + reading}\t\tnumber_of_previous_frequencies = #{previous_frequencies.count}"
  current_frequency += reading
  readings << reading # append the reading so we can loop multiple times if needed
  break if previous_frequencies.include?(current_frequency)
  previous_frequencies << current_frequency
end

puts "The first duplicate frequency is #{current_frequency}"
