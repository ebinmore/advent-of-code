require_relative 'triangle'

possible = 0
impossible = 0
total = 0

File.open("a.input").each_line do |line|
  params = eval("[#{line.strip.gsub(/\s+/, ",")}]")
  t = Triangle.new(params)
  possible += 1 if t.possible?
  impossible += 1 unless t.possible?
  total += 1
end

puts "#{possible} possible triangles out of #{total} potential triangles"
puts "check #{total - (possible + impossible)}"
