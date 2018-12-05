

frequency = 0
File.open('./data').each_line do |reading|
  frequency += reading.to_i
end

puts "The resulting frequency is #{frequency}"
