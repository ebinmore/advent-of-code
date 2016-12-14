require_relative 'triangle'

possible = 0
impossible = 0
total = 0

data = File.readlines('a.input').map do |line|
  line.split.map(&:to_i)
end

triangle_data = []
while !data.empty?
  a, b, c = data.slice!(0, 3)
  triangle_data << [a[0], b[0], c[0]]
  triangle_data << [a[1], b[1], c[1]]
  triangle_data << [a[2], b[2], c[2]]
end

triangle_data.each do |params|
  t = Triangle.new(params)
  possible += 1 if t.possible?
  impossible += 1 unless t.possible?
  total += 1
end

puts "#{possible} possible triangles out of #{total} potential triangles"
puts "check #{total - (possible + impossible)}"
