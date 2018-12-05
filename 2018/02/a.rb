

box_ids = IO.readlines('./data').map(&:strip)

twos, threes = 0, 0
box_ids.each do |id|
  # take each id and group the multiple occurences of the letters
  chunks = id.chars.sort.chunk { |c| c.to_s }.to_h
  twos += 1 if chunks.values.select { |value| value.count == 2 }.count > 0
  threes += 1 if chunks.values.select { |value| value.count == 3}.count > 0
end

puts "# of twos: #{twos}"
puts "# of threes: #{threes}"
puts "Checksum: #{twos} x #{threes} = #{twos * threes}"
