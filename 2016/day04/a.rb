require_relative 'room'

sum_of_sector_ids_for_real_rooms = 0
File.open("a.input").each_line do |line|
  room = Room.new(line.strip)
  if room.valid?
    sum_of_sector_ids_for_real_rooms += room.sector_id
  end
end

puts "The sum of the sector ids of real rooms is #{sum_of_sector_ids_for_real_rooms}"
