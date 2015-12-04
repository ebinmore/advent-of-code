class Present

  def initialize(params = {}) 
    @length = params.fetch(:length, 0)
    @width = params.fetch(:width, 0)
    @height = params.fetch(:height, 0)

    @length_x_width = @length * @width
    @length_x_height = @length * @height
    @width_x_height = @width * @height
    @slack = [@length_x_width, @length_x_height, @width_x_height].sort.first
  end

  def wrapping_paper_required
    2 * @length_x_width + 2 * @length_x_height + 2 * @width_x_height + @slack
  end
end