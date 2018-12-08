require_relative './pattern'
require_relative './setup'

canvas = Setup.apply_patterns_to_canvas

# find the sole pattern without overlap
uncontested_squares, contested_squares = [], []
canvas.each do |x|
  x.each do |y|
    uncontested_squares << y if y.count == 1
    contested_squares << y if y.count > 1
  end
end

patterns_w_no_contested_squares = uncontested_squares.flatten.uniq - contested_squares.flatten.uniq

puts "The following patterns have no overlap:\n#{patterns_w_no_contested_squares.join("\n")}"
