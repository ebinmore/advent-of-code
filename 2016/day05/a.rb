require_relative 'haxzor_password'

door_id = "abc"
password = HaxzorPassword.new({door_id: door_id})

puts "The password for door #{door_id} is #{password.value}"
