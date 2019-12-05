class IntComputer

  def initialize(program)
    @initial_state = program.to_s.split(',').map(&:to_i)
  end

  def perform_operation
    # read the current position and determine the operation
    operation = @memory[@position]
    case operation
    when 1
      # grab the values from position @memory[@position+1] and @memory[@position+2]
      pos_a = @memory[@position + 1]
      pos_b = @memory[@position + 2]
      pos_c = @memory[@position + 3]

      a = @memory[pos_a]
      b = @memory[pos_b]
      # add them
      c = a + b
      # store them in position @memory[@position+3]
      @memory[pos_c] = c
      # increment @position = @position+4
      @position += 4
      puts "adding pos #{pos_a} (#{a}) and pos #{pos_b} (#{b}) and storing in #{pos_c} (#{c})"
    when 2
      # grab the two values - @memory[@position+1] and @memory[@position+2]
      pos_a = @memory[@position + 1]
      pos_b = @memory[@position + 2]
      pos_c = @memory[@position + 3]

      a = @memory[pos_a]
      b = @memory[pos_b]
      # multiply them
      c = a * b
      # store them in position @memory[@position+3]
      @memory[pos_c] = c
      # increment @position = @position+4
      @position += 4
      puts "multiplying pos #{pos_a} (#{a}) and pos #{pos_b} (#{b}) and storing in #{pos_c} (#{c})"
    when 99
      # stop
      puts 'terminating program'
      return false
    end

    # more to process
    true
  end

  def run_program
    puts "initial_state: #{@initial_state}"
    @memory = @initial_state
    @position = 0

    loop do
      puts "memory: #{@memory.join(',')}"
      puts "current position: #{@position}"
      puts "performing operation: #{@memory[@position]}"
      break unless perform_operation
    end

    @memory
  end
end
