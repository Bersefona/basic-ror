require_relative 'instance_counter.rb'
require_relative 'validation.rb'

class Route
  include InstanceCounter
  include Validation
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
    validate!
  end

  def add_station(station)
    @stations.insert(-2, station) if station.is_a?(Station)
  end
  
  def delete_station
    @stations.delete_at(-2) if self.stations.length > 2
  end
  
  def show_stations
     @stations.each { |station| puts station }
  end

  protected

  def validate!
    raise "Начальная и конечная станции не должны совпадать." if self.stations[0] == self.stations[-1]
  end

end
