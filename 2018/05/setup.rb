# require_relative 'log_entry'
module Setup
  def self.test_data
    'dabAcCaCBAcCcaDA'
  end

  def self.data
    IO.readlines('./data').map(&:strip).join('')
  end
end
