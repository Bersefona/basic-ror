require_relative 'van.rb'

class CargoVan < Van

  attr_reader :total_volume
  
  def initialize(total_volume)
    @number = generate_number
    @total_volume = total_volume
    validate!
    @volume = 0
  end

  def increase_volume(volume)
    return if self.volume + volume > self.total_volume
    self.volume += volume
  end

  def decrease_volume(volume)
    return if self.volume - volume < 0
    self.volume -= volume
  end
   
  def free_volume
    self.total_volume - self.volume
  end

  def occupied_volume
    self.volume
  end

  def to_s
    "Вагон '№#{number}' тип '#{self.class}' объём своб.|зан.: '#{free_volume}|#{occupied_volume}'"
  end

  protected

  attr_accessor :volume

  def validate!
    raise "Объём не может быть отрицательным." if self.total_volume <= 0
  end

  def valid?
    validate!
    true
  rescue
    false
  end

end
