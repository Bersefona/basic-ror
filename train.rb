###
# Подключить модуль к классу Поезд
# Добавить к поезду атрибут Номер (произвольная строка), если его еще нет, который указыватеся при его создании
# В классе Train создать метод класса find, который принимает номер поезда (указанный при его создании)
# и возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.
# Подключить модуль InstanceCounter в класс поезда.
###

require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :speed, :route, :number, :current_station_index, :type
  
  @@trains = {}
  
  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @vans = []
    @route = nil
    @current_station_index = nil
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
    @vans << van if @speed == 0
  end
  
  def delete_van
    @vans.pop if @speed == 0 && @vans.length > 0
  end
  
  def route=(route)
    if route.is_a?(Route)
      @route = route
      @current_station_index = 0
      current_station.get_train(self)
    end
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
    move(self.current_station_index + 1) if next_station 
  end
  
  def move_back
    move(self.current_station_index - 1) if prev_station
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

end  
