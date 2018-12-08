

# box_ids = IO.readlines('./data').map(&:strip)

box_ids = %w[
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz]

partitioned = box_ids.map { |id| id.chars }

hash = box_ids.map do |id|
  [id, id.sort.chunk { |c| c.to_s }.to_h]
end.to_h


partitioned.each do |x|
  partitioned.each do |y|
    n = x - y

  end
end
