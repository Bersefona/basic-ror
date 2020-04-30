###
# TODO
###
#
#   Разделить поезда на два типа PassengerTrain и CargoTrain (отдельными файлами)
#   Сделать родителя для классов, который будет содержать общие методы и свойства
#   (Train как родитель?)
#   Разделить вагоны на класс "грузовые" и класс "пассажирские" (отдельными файлами)
#   К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые.
#   (Не забыть пояснить за protected!!!)
#
###

class Train

   TYPES = [
    {
      type: 'PassengerTrain',
      name: 'пассажирский'
    },
    {
      type: 'CargoTrain',
      name: 'грузовой'
    }
  ]
  
  attr_reader :speed, :route, :number, :current_station_index

  def initialize(number)
    @number = number
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
  
  def delete_van
    @vans.pop if @speed == 0 && @vans.lenght > 0
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
  
  # чтобы методы нельзя было вызвать извне
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
