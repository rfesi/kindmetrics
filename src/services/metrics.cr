class Metrics
  def initialize(@domain : Domain)

  end

  def get_days
    past_time = 7.days.ago
    time_zone = @domain.time_zone
    today_date = Time.utc
    sql = <<-SQL
    SELECT DATE_TRUNC('day', created_at) AT TIME ZONE '#{time_zone}' as date, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{past_time}'
    GROUP BY DATE_TRUNC('day', created_at) AT TIME ZONE '#{time_zone}'
    ORDER BY DATE_TRUNC('day', created_at) AT TIME ZONE '#{time_zone}' asc;
    SQL
    grouped = AppDatabase.run do |db|
      db.query_all sql, as: StatsDays
    end
    grouped2 = [] of StatsDays
    range = (past_time..today_date)
    puts range.size
    range.each do |e|
      date = nil
      grouped.each do |g|
        if e.day == g.date.day && e.month == g.date.month
          date = StatsDays.new(date: e, count: g.count.not_nil!)
        end
      end
      date = StatsDays.new(date: e, count: 0) if date.nil?
      grouped2 << date.not_nil! unless date.nil?
    end
    days = grouped2.map { |d| d.date }
    data = grouped2.map { |d| d.count }
    today = data.clone
    data.pop
    today_data = today[today.size-2..today.size]
    today = today[0..today.size-3].fill {|i| nil}
    today_data.each { |t| today.push t }
    return days, today, data
  end

  def get_referrers
    sql = <<-SQL
    SELECT referrer_domain, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY referrer_domain;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsReferrer
    end
    pages.reject! { |r| r.referrer_domain.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_pages
    sql = <<-SQL
    SELECT path as address, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY path
    ORDER BY COUNT(id) desc;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsPages
    end
    pages = count_percentage(pages)
    return pages
  end

  def get_devices
    sql = <<-SQL
    SELECT device, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY device
    ORDER BY COUNT(id) desc;
    SQL
    devices = AppDatabase.run do |db|
      db.query_all sql, as: StatsDevice
    end
    devices = count_percentage(devices)
    return devices
  end

  def get_browsers
    sql = <<-SQL
    SELECT browser_name as browser, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY browser_name
    ORDER BY COUNT(id) desc;
    SQL
    browsers = AppDatabase.run do |db|
      db.query_all sql, as: StatsBrowser
    end
    browsers = count_percentage(browsers)
    return browsers
  end

  def get_os
    sql = <<-SQL
    SELECT operative_system, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY operative_system;
    SQL
    browsers = AppDatabase.run do |db|
      db.query_all sql, as: StatsOS
    end
    browsers = count_percentage(browsers)
    return browsers
  end

  private def count_percentage(array)
    total = array.sum { |p| p.count }
    array.map do |p|
      p.percentage = p.count / total.to_f32
      p
    end
  end
end
