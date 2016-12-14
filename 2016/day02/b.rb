require_relative "stupid_keypad"

bathroom_code = []
keypad = StupidKeypad.new
keypad.reset
File.open("a.input").each_line do |line|
  puts "Current position is #{keypad.position}"
  line.strip.each_char do |character|
    keypad.move_finger(character)
    puts "\tMoved to #{keypad.position}"
  end

  bathroom_code << keypad.position
end

puts "The bathroom code is #{bathroom_code.join()}"
