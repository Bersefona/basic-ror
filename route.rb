###
# Подключить модуль InstanceCounter в класс маршрута.
###
require_relative 'instance_counter.rb'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]
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

end
