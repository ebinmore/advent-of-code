require_relative './pattern'

def map_pattern_to_canvas(canvas, pattern)
  leftmost, uppermost = pattern.upper_left_corner
  (0..pattern.width-1).each do |x|
    (0..pattern.height-1).each do |y|
      # puts "canvas[#{leftmost + x}][#{uppermost + y}] << #{pattern.id}"
      canvas[leftmost + x][uppermost + y] << pattern.id
    end
  end
end

def testing_setup
  @data = [
    '#1 @ 1,3: 4x4',
    '#2 @ 3,1: 4x4',
    '#3 @ 5,5: 2x2'
  ]
  @expected_value = 4

  # Three dimensional array 10 x 10 x nil
  @canvas = Array.new(10) { Array.new(10) { [] } } # [ [ [], ..., [] ], ..., [ [], ..., [] ] ]
  # visually
  # 0 1 2 . . . y
  # 1
  # 2
  # .
  # .
  # .
  # x
end

def setup
  @data = IO.readlines('./data').map(&:strip)
  size = 1000
  @canvas = Array.new(size) { Array.new(size) { [] } }
end


if ENV['TESTING']
  testing_setup
else
  setup
end

# map pattern data to the canvas
@data.each do |data|
  pattern = Pattern.new(data)
  map_pattern_to_canvas(@canvas, pattern)
end

# find overlaps
square_inches_of_overlap = 0
@canvas.each do |x|
  x.each do |y|
    square_inches_of_overlap +=1 if y.count > 1
  end
end
puts "There are #{square_inches_of_overlap} inches of contested material."
