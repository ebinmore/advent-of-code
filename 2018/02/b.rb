

# box_ids = IO.readlines('./data').map(&:strip)

box_ids = %w[
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz]


boxes = box_ids.map do |id|
  [
    id,
    id.chars.sort.chunk { |c| c.to_s }.to_h
  ]
end.to_h
chunks = id.chars.sort.chunk { |c| c.to_s }.to_h
  twos += 1 if chunks.values.select { |value| value.count == 2 }.count > 0

hash = box_ids.map do |id|
  [id, id.sort.chunk { |c| c.to_s }.to_h]
end.to_h


partitioned.each do |x|
  partitioned.each do |y|
    z = true
    z = true &&

  end
end


def convert_to_base26(alpha)
  alpha.tr( "abcdefghijklmnopqrstuvwxyz", "0123456789abcdefghijklmnopq" ).to_i(26)
end
