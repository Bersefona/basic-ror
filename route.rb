require_relative 'instance_counter.rb'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
    validate!
  end

  def add_station(station)
    raise "В маршрут уже входит станция '#{station.name}'." if stations.include?(station)
    raise StandardError, "Станция должна быть объектом типа Station." unless station.is_a?(Station)
    @stations.insert(-2, station)
  end
  
  def delete_station
    raise "Отсутствуют промежуточные станции в маршруте." unless self.stations.length > 2
    @stations.delete_at(-2) 
  end
  
  def show_stations
     @stations.each { |station| puts station }
  end

  protected

  def validate!
    raise "Начальная и конечная станции не должны совпадать." if self.stations[0] == self.stations[-1]
    self.stations.each do |station|
      raise StandardError "Станция должна быть объектом типа Station." unless station.is_a?(Station)
    end
  end

  def valid?
    validate!
    true
  rescue
    false
  end

end
