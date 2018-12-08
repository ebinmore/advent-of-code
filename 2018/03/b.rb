require_relative './pattern'
require_relative './setup'

def canvas_to_s(canvas)
  canvas.each do |x|
    x.each do |y|
      print '.' if y.count == 0
      print y.first if y.count == 1
      print 'X' if y.count > 1
    end
    puts
  end
end

data, canvas = Setup.apply_patterns_to_canvas
# canvas_to_s(canvas)

# find the sole pattern without overlap
patterns_w_uncontested_squares, patterns_w_contested_squares = [], []
canvas.each do |x|
  x.each do |y|
    patterns_w_uncontested_squares << y if y.count == 1
    patterns_w_contested_squares << y if y.count > 1
  end
end

patterns_w_no_contested_squares = patterns_w_uncontested_squares.flatten.uniq - patterns_w_contested_squares.flatten.uniq

puts "The following patterns have no overlap:\n#{patterns_w_no_contested_squares.join("\n")}"
