require 'time'

class Time
  def begining_of_day
    Time.mktime(
      year, month, day, 0, 0, 0).send(gmt? ? :gmt : :localtime)
  end

  def end_of_day
    Time.mktime(
      year, month, day, 23, 59, 59).send(gmt? ? :gmt : :localtime) 
  end

  def add_days(days)
    self + days * 86400   
  end

  def subtract_days(days)
    self - days * 86400     
  end
  
  def self.parse_cli_interval(value)
    case value
    when /(.*):(.*)/
      from = Time.parse $1
      to = Time.parse $2
      [from, to]
    when /today([\+-]\d+)*/
      t1 = Time.now.begining_of_day
      addition = $1.to_i      
      t2 = if 0 == addition
        t2 = t1.end_of_day 
      else
        t1.add_days addition
      end
      if t2 > t1
        [t1, t2]
      else
        [t2, t1]
      end
    else
      raise ArgumentError, 'invalid date interval format' 
    end
  end
end

class Array
  def in_groups_of(n, default = nil)
    groups = []
    (self.size / n + 1).times do |i|
      group = []
      n.times do |j|
        group << (self[i * n + j] || default)
      end
      groups << group
    end
    groups
  end
end

class String
  def width(width)
    self.split(//).in_groups_of(width, '').map { |line| line.join }.join("\n")
  end
end
