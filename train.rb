require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'

class Train

  include Manufacturer
  include InstanceCounter
  attr_reader :speed, :route, :number, :current_station_index, :type
  NUMBER_FORMAT = /^([a-zа-я]|\d){3}-?([a-zа-я]|\d){2}$/i
  TYPE_FORMAT = /^cargo$|^passenger$/i
  
  @@trains = {}
   

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @vans = []
    @route = nil
    @current_station_index = nil
    validate!
    @@trains[number] = self
  end

  def self.find(train_number)
    @@trains[train_number]
  end

  def faster(value)
    @speed += value
  end  

  def slower(value)
    @speed = self.speed >= value ? self.speed - value : stop
  end

  def stop
    @speed = 0
  end
  
  def add_van(van)
    raise "Невозможно прицепить вагон, покуда поезд движется." if self.speed > 0
    @vans << van
  end
  
  def delete_van
    raise "Невозможно отцепить вагон, покуда поезд движется." if self.speed > 0
    raise "Невозможно отцепить вагон, которого нет." if @vans.length < 0
    @vans.pop
  end
  
  def route=(route)
    raise "В качестве маршрута можно назначить только маршрут." unless route.is_a?(Route)
    @route = route
    @current_station_index = 0
    current_station.get_train(self)
  end

  def prev_station
    station(self.current_station_index - 1)
  end

  def current_station
    station(self.current_station_index)
  end

  def next_station
    station(self.current_station_index + 1)
  end

  def move_on
    raise "Поезд прибыл на конечную станцию." unless next_station
    move(self.current_station_index + 1)
  end
  
  def move_back
    raise "Поезд прибыл на начальную станцию." unless prev_station
    move(self.current_station_index - 1)
  end
  
  
  protected
  
  def move(value)
    current_station.delete_train(self.number) 
    @current_station_index = value
    current_station.get_train(self)
  end
  
  def station(value)
    self.route.stations[value] 
  end

  def validate!
    raise "Неправильный формат номера поезда." if self.number !~ NUMBER_FORMAT
    raise "Неправильный формат типа поезда." if self.type !~ TYPE_FORMAT
  end

  def valid?
    validate!
    true
  rescue
    false
  end 

end  
