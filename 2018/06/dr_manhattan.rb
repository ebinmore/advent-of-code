class DrManhattan
  def initialize(data)
    @data = data
  end

  def grid
    max_x, max_y = grid_size
    (0..max_x).each do |x|
      (0..max_y).each do |y|
        if @data.include?([y, x]) #why? because the example in the question is fucked
          print 'x'
        else
          print '.'
        end
      end
      puts ''
    end
  end

  # private #----------------------------
  def grid_size
    y = @data.max { |a, b| a[0] <=> b[0] }[0] + 1
    x = @data.max { |a, b| a[1] <=> b[1] }[1] + 1
    [x, y]
  end
end
