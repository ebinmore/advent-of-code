# require_relative 'log_entry'
module Setup
  def self.test_data
    data = <<~HEREDOC
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    HEREDOC
    data.split("\n")
  end

  def self.data
    IO.readlines('./data').map(&:strip).join('')
  end

  def self.parse_coordinates(data: self.test_data)
    data.map do |string|
      coordinates = string.split(',')
      [coordinates[0].to_i, coordinates[1].to_i]
    end
  end
end
