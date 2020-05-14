require_relative 'van.rb'

class PassengerVan < Van
  
  attr_reader :seats_on_train
  
  def initialize(seats_on_train)#, type='passenger')
    @number = generate_number
    @seats_on_train = seats_on_train
    validate!
    self.seats = []
  end
  
  def take_up_seat
    self.seats << 1 if self.busy_seats_on_train <= self.seats_on_train
  end

  def free_up_seat
    return if self.free_seats_on_train == seats_on_train
    self.seats.pop
  end
  
  def free_seats_on_train
    self.seats_on_train - self.busy_seats_on_train
  end
  
  def busy_seats_on_train
    self.seats.length
  end

  def to_s
    "Вагон '№#{number}' тип '#{self.class}' места своб.|зан.: '#{free_seats_on_train}|#{busy_seats_on_train}'"
  end
  
  protected
  
  attr_accessor :seats

  def validate!
    raise "Число мест не может быть отрицательным числом." if self.seats_on_train <= 0
  end

  def valid?
    validate!
    true
  rescue
    false
  end
  
end
