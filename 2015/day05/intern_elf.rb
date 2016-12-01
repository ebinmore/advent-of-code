require 'set'

class InternElf

  def initialize(params = {})
    @naughty_and_nice = params.fetch(:naughty_and_nice, [])
    @naughty = Set.new
    @nice = Set.new

    @nice_conditions = params.fetch(:nice_conditions)
    @naughty_conditions = params.fetch(:naughty_conditions)
  end

  def naughty_or_nice?(name)

    @naughty_conditions.each do |condition|
      @naughty << name if condition.match(name)
    end

    unless @naughty.include?(name)
      meets_all_nice_conditions = true;
      @nice_conditions.each { |condition| meets_all_nice_conditions = meets_all_nice_conditions && (condition.match(name) != nil)}
      @nice << name if meets_all_nice_conditions 
    end

    @naughty << name unless @nice.include?(name) || @naughty.include?(name)

    @nice.include?(name) && ! @naughty.include?(name)
  end

  def go_through_list
    @naughty_and_nice.each do |name|
      puts "#{name.strip} is #{naughty_or_nice?(name) ? 'NICE' : 'naughty'}"
    end
  end

  def nice
    @nice
  end

  def naughty
    @naughty
  end

end