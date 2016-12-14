
class Triangle

  def initialize(*params)
    @lengths = params.flatten.sort

    puts "lengths: #{@lengths}"
  end

  def possible?
    @lengths[0] + @lengths[1] > @lengths[2]
  end
end
