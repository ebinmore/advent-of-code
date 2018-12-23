class Guard
  attr_reader :id, :sleep_schedule

  def initialize(log_entries)
    @id = log_entries.first.guard
    @sleep_schedule = {}

    last_status = 'waking'
    start_time = nil
    log_entries.each do |entry|
      date = entry.time.strftime("%m-%d")
      @sleep_schedule[date] ||= Array.new(60, 0)

      if last_status == 'sleeping' && entry.status == 'waking'
        (start_time.min..entry.time.min-1).each do |minute|
          @sleep_schedule[date][minute] += 1
        end
        start_time = nil
      end
      if entry.status == 'sleeping'
        start_time = entry.time
      end
      last_status = entry.status
    end
  end

  def total_slept
    @sleep_schedule.values.reduce(0) { |total, date| total += date.sum }
  end

  def most_frequently_slept_minute
    minutes = @sleep_schedule.values.transpose
    minutes.map!(&:sum)
    minutes.each.with_index { |total_slept, minute| return minute if total_slept == minutes.max }
  end


  def to_s
    str =  "Date\t\tMinute\n"
    str += "    \t\t000000000011111111112222222222333333333344444444445555555555\n"
    str += "    \t\t012345678901234567890123456789012345678901234567890123456789\n"
    @sleep_schedule.each do |date, schedule|
      str +=  "#{date}\t\t#{schedule.map { |minute| minute > 0 ? "#" : "." }.join('')}\n"
    end
    str
  end
end
