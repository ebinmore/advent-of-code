# wire is made up of  line segments starting at the origin
class Wire
  attr_accessor :line_segments

  def initialize(trace)
    @line_segments = []
    start = [0, 0]
    trace.each do |instruction|
      vector = to_vector(instruction)
      terminus = [start[0] + vector[0], start[1] + vector[1]]
      @line_segments << { a: start, b: terminus }

      # the next line segment begins where this one ends
      start = terminus
    end
  end

  def to_vector(instruction)
    direction = instruction[0]
    scalar = instruction[1..-1].to_i
    case direction
    when 'U'
      [0, scalar]
    when 'D'
      [0, scalar * -1]
    when 'L'
      [scalar * -1, 0]
    when 'R'
      [scalar, 0]
    end
  end
end
