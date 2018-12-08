require_relative './pattern'

module Setup
  def self.apply_patterns_to_canvas
    data, canvas = if ENV['TESTING']
      testing_setup
    else
      setup
    end

    # map pattern data to the canvas
    data.each do |datum|
      pattern = Pattern.new(datum)
      map_pattern_to_canvas(canvas, pattern)
    end

    [data, canvas]
  end

  private #--------------------------------------------------------------------------
  def self.testing_setup
    # Three dimensional array 10 x 10 x nil
    canvas = Array.new(10) { Array.new(10) { [] } } # [ [ [], ..., [] ], ..., [ [], ..., [] ] ]
    # visually
    # 0 1 2 . . . y
    # 1
    # 2
    # .
    # .
    # .
    # x

    data = [
      '#1 @ 1,3: 4x4',
      '#2 @ 3,1: 4x4',
      '#3 @ 5,5: 2x2'
    ]

    [data, canvas]
  end

  def self.setup
    size = 1000
    canvas = Array.new(size) { Array.new(size) { [] } }
    data = IO.readlines('./data').map(&:strip)
    [data, canvas]
  end

  def self.map_pattern_to_canvas(canvas, pattern)
    leftmost, uppermost = pattern.upper_left_corner
    (0..pattern.width-1).each do |x|
      (0..pattern.height-1).each do |y|
        puts "canvas[#{leftmost + x}][#{uppermost + y}] << #{pattern.id}" if ENV['TESTING']
        canvas[leftmost + x][uppermost + y] << pattern.id
      end
    end
  end
end
