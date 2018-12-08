class Pattern
  attr_reader :id, :upper_left_corner, :width, :height

  def initialize(data)
    parse_expression = /#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/
    parsed = parse_expression.match(data)
    @id = parsed[1]
    @upper_left_corner = [parsed[2].to_i, parsed[3].to_i]
    @width = parsed[4].to_i
    @height = parsed[5].to_i
  end

  def area
    return width * height
  end
end
