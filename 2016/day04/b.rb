require_relative 'room'

possible_rooms = {}
File.open("test.input").each_line do |line|
  room = Room.new(line.strip)
  if room.valid?
    decrypted_room_name  = room.decrypt
    puts "#{decrypted_room_name} - #{room.sector_id}"

    possible_rooms[decrypted_room_name] = room.sector_id if decrypted_room_name.include?("north pole")
  end
end

puts "Possbile rooms:"
possible_rooms.keys.each do |key|
  puts "#{key} - sector_id: #{possible_rooms[key]}"
end
