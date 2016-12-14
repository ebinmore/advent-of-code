
class StupidKeypad

  def initialize(params = {})
    @keypad = [ [nil, nil,   1, nil, nil],
                [nil,   2,   3,   4, nil],
                [  5,   6,   7,   8,   9],
                [nil, "A", "B", "C", nil],
                [nil, nil, "D", nil, nil] ]
    @last_position = [-2, 0]
    @x = -2
    @y = 0
  end

  def reset
    @last_position = [-2, 0]
    @x = -2
    @y = 0
  end

  def move_finger(direction)
    puts "\t\tMove #{direction}"
    case direction
    when "U"
      move -1, 0
    when "D"
      move 1, 0
    when "L"
      move 0, -1
    when "R"
      move 0, 1
    end
  end

  def move(y, x)
    @x += x
    @y += y

    @x = -2 if @x < -2
    @x = 2 if @x > 2

    @y = -2 if @y < -2
    @y = 2 if @y > 2

    @x, @y = @last_position if position.nil?
    @last_position = [@x, @y]
  end

  def position
    @keypad[@y + 2][@x + 2]
  end
end
