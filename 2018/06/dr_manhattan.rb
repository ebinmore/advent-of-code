class DrManhattan
  def initialize(data)
    @data = data
  end

  def grid
    max_x, max_y = grid_size
    (0..max_x).each do |x|
      (0..max_y).each do |y|
        if index = @data.index([y, x]) #why? because the example in the question is fucked
          print "#{index.to_s.rjust(2, "0")}|" #need to print the index of the matching @data, masked with '00'; max handled is 99 elements
        else
          print '..|' #two place holders
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
