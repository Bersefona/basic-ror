###
#
# (+) Имеет начальную и конечную станцию,
# (+) а также список промежуточных станций.
# (+) Начальная и конечная станции указываются
# (+) при создании маршрута, а промежуточные
# (+) могут добавляться между ними.
# (+) Может добавлять промежуточную станцию в список
# (+) Может удалять промежуточную станцию из списка
# (+) Может выводить список всех станций по порядку
# (+) от начальной до конечной
#
###

class Route

  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
  end

  def add_station(station)
    @stations.insert(-2, station) if station.is_a?(Station)
  end
  
  def delete_station(station)
    @stations.delete_at(-2) if  station != @stations[0] && station != @stations[-1]
  end
  
  def show_stations
     @stations.each { |station| puts station }
  end

end
