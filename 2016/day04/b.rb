require_relative 'room'

possible_rooms = {}
File.open("a.input").each_line do |line|
  room = Room.new(line.strip)
  if room.valid?
    # puts "Decrypting room #{line.strip}"
    decrypted_room_name  = room.decrypt
    puts "#{decrypted_room_name} - #{room.sector_id}"

    possible_rooms[decrypted_room_name] = room.sector_id if decrypted_room_name.include?("north")
  end
end
puts
puts "Possbile rooms:"
puts "==============="
possible_rooms.keys.each do |key|
  puts "#{key} - sector_id: #{possible_rooms[key]}"
end
