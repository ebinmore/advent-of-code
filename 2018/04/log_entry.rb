class LogEntry
  attr_reader :raw, :year, :month, :day, :hour, :minute, :status, :time
  attr_accessor :guard

  def initialize(data)
    parse_expression = /\[(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2})\]\s((Guard #(\d+) begins shift)|(falls asleep)|(wakes up))/
    @raw = data
    parsed = parse_expression.match(data)
    @year = parsed[1].to_i
    @month = parsed[2].to_i
    @day = parsed[3].to_i
    @hour = parsed[4].to_i
    @minute = parsed[5].to_i
    @time = Time.new(@year, @month, @day, @hour, @minute, 0)
    @guard = parsed[8].to_i

    @status = case parsed[6]
    when 'falls asleep'
      'sleeping'
    when 'wakes up'
      'waking'
    when "Guard ##{@guard} begins shift"
      'starting'
    end
  end

  def asleep?
    status == 'sleeping'
  end

  def awake?
    status == 'waking'
  end

  def starting?
    status == 'starting'
  end

  def to_s
    "#{format('%02d', @day)} #{format('%02d', @hour)}:#{format('%02d', @minute)}] Guard ##{@guard} #{@status}"
  end
end
