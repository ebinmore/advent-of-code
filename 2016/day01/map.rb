
class Map

  def initialize(params = { start: [0,0] })
    @pen = params[:start]
    @canvas = { @pen : 1 }
    @intersections = [] # ordered
  end

  def trace_route(destination)
    # this only handles travel in one direction at a time / travel is orthogonal
    # @pen.index.each do |R|
    #   if @pen[R] != destination[R]
    #     # loop from @pen[R] to destination[R] and add each point on the line
    #     @pen[R]..destination[R].each do |plotter|
    #       # so how do i get each dimension? I'm making this more complicated by trying to be generalize the number of dimensions
    #     end
    #   end
    # end
    (@pen[0]..destination[0]).each do |x|
      point = [x, @pen[1]]
      @canvas[point] = 0 unless @canvas.include?(point)
      @canvas[point] += 1

      @intersections << point if @canvas[point] > 1
    end

    # now duplicate for y
    (@pen[1]..destination[1]).each do |y|
      point = [@pen[0], y]
      @canvas[point] = 0 unless @canvas.include?(point)
      @canvas[point] += 1

      @intersections << point if @canvas[point] > 1
    end
    # this isn't actually solving the problem... I want the first intersection, but that's easy enough... intersections[0] :-)
    @pen = destination
  end

  def intersections
    @intersections
  end

end
