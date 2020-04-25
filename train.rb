###
#
# (+) Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
# (+) эти данные указываются при создании экземпляра класса
# (+) Может набирать скорость
# (+) Может возвращать текущую скорость
# (+) Может тормозить (сбрасывать скорость до нуля)
# (+) Может возвращать количество вагонов
# (+) Может прицеплять/отцеплять вагоны (по одному вагону за операцию,
# (+) метод просто увеличивает или уменьшает количество вагонов).
# (+) Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# (+) Может принимать маршрут следования (объект класса Route). 
# (+) При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# (+) Может перемещаться между станциями, указанными в маршруте.
# (+) Перемещение возможно вперёд и назад, но только на 1 станцию за раз.
# (+) Возвращать предыдущую станцию, текущую, следующую на основе маршрута.
#
###

class Train

  attr_reader :speed, :route, :number, :type, :current_station_index, :vans

  def initialize(number, type, vans)
    @number = number
    @type = type
    @vans = vans
    @speed = 0
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

  def add_van
    @vans += 1 if @speed == 0
  end

  def delete_van
    @vans -= 1 if @vans > 0 && @speed == 0
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

  private
  
  def move(value)
    current_station.delete_train(self.number) 
    @current_station_index = value
    current_station.get_train(self)
  end
  
  def station(value)
    if (self.route.is_a?(Route) && value >= 0 && value <= self.route.stations.length - 1)
      self.route.stations[value] 
    end
  end

end  