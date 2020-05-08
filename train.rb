###
#
#   Разделить поезда на два типа PassengerTrain и CargoTrain
#   Сделать родителя для классов, который будет содержать общие методы и свойства
#   Разделить вагоны на класс "грузовые" и класс "пассажирские"
#   К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые.
#
###

class Train

  attr_reader :speed, :route, :number, :current_station_index, :type

  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @vans = []
    @route = nil
    @current_station_index = nil
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
  
  def delete_van(van)
    @vans.delete(van) if @speed == 0 && @vans.lenght > 0
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
  
  # добавлен для того, чтобы:
  # показать, что методы будут использоваться в подклассах;
  # скрыть доступ "из вне" класса.
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
