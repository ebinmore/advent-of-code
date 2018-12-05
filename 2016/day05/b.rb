require_relative 'haxzor_password'

door_id = "uqwqemis"
password = HaxzorPassword.new({door_id: door_id})

puts "The password for first door #{door_id} is #{password.linear}"
puts "and the password for the second door is #{password.ordinal}"
