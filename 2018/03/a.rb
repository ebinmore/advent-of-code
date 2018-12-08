require_relative './setup'

data, canvas = Setup.apply_patterns_to_canvas

# find overlaps
square_inches_of_overlap = 0
canvas.each do |x|
  x.each do |y|
    square_inches_of_overlap +=1 if y.count > 1
  end
end
puts "There are #{square_inches_of_overlap} inches of contested material."
