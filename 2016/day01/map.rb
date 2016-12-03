
class Map

  @draw_x = Proc.new do |x|
    point = [x, @pen[1]].to_s
    @canvas[point] = 0 unless @canvas.include?(point)
    @canvas[point] += 1
    puts "adding point #{point}:#{@canvas[point]}"
    @intersections << [x, @pen[1]] if @canvas[point] > 1
  end

  @draw_y = Proc.new do |y|
    point = [@pen[0], y].to_s
    @canvas[point] = 0 unless @canvas.include?(point)
    @canvas[point] += 1
    puts "adding point #{point}:#{@canvas[point]}"
    @intersections << [@pen[0], y] if @canvas[point] > 1
  end

  def initialize(params = { start: [0,0] })
    @pen = params[:start]
    @canvas = {}
    @canvas[@pen.to_s] = 1
    @intersections = [] # ordered
  end

  def trace_route(destination)
    puts "tracing a route from #{@pen} to #{destination}"
    # we drop(1) because (0..0).each iterates once, but our @pen is already there...
    # next adventure (3..1).each does not iterate from 3 to 1. we can't trace our route west or south :-\

    #  a.downto(b)
    (@pen[0] > destination[0] ? @pen[0].downto(destination[0]) : @pen[0]..destination[0]).drop(1).each do |x|
      point = [x, @pen[1]].to_s
      @canvas[point] = 0 unless @canvas.include?(point)
      @canvas[point] += 1
      puts "adding point #{point}:#{@canvas[point]}"
      @intersections << [x, @pen[1]] if @canvas[point] > 1
    end

    (@pen[1] > destination[1] ? @pen[1].downto(destination[1]) : @pen[1]..destination[1]).drop(1).each do |y|
      point = [@pen[0], y].to_s
      @canvas[point] = 0 unless @canvas.include?(point)
      @canvas[point] += 1
      puts "adding point #{point}:#{@canvas[point]}"
      @intersections << [@pen[0], y] if @canvas[point] > 1
    end

    @pen = destination
  end

  def intersections
    @intersections
  end

end
