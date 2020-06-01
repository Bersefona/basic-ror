require_relative 'manufacturer.rb'
require_relative 'validation.rb'

class Van
  include Manufacturer
  include Validation
  attr_reader :number, :total_value

  def initialize(total_value)
    @number = generate_number
    @total_value = total_value
    validate!
    @occupied_value = 0
  end

  def take_up(value)
    return if free_value < value
    self.occupied_value += value
  end  

  def free_up(value)
    return if occupied_value < value
    self.occupied_value -= value
  end
   
  def free_value
    total_value - occupied_value
  end

  def occupied_value
    self.value
  end

  def to_s
    "Вагон №#{number} | Тип: #{self.class} | #{free_value} своб. | #{occupied_value} зан."
  end


  protected
  
  attr_accessor :value, :occupied_value
  attr_writer :free_value

  def validate!
    raise "Число не может быть отрицательным." if self.total_value <= 0
  end

  def generate_number
    srand.to_s.slice(0..9)
  end
  
end
