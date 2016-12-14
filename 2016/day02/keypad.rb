
class Keypad

  def initialize(params = {})
    @keypad = [ [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9] ]
    @x = 0
    @y = 0
  end

  def reset
    @x = 0
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

    @x = -1 if @x < -1
    @x = 1 if @x > 1

    @y = -1 if @y < -1
    @y = 1 if @y > 1
  end

  def position
    @keypad[@y + 1][@x + 1]
  end
end
