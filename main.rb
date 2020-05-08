###
#
#  Создать программу, которая будет позволять пользователю через текстовый интерфейс делать следующее:
# - (+) Создавать станции
# - (+) Создавать поезда
# - (+) Создавать маршруты
# - (+) Управлять станциями в нем (добавлять)
# - (+) Управлять станциями в нем (удалять)
# - (+) Назначать маршрут поезду
# - (+) Добавлять вагоны к поезду
# - (+) Отцеплять вагоны от поезда
# - (+) Перемещать поезд по маршруту вперед
# - (+) Перемещать поезд по маршруту назад
# - (+) Просматривать список станций
# - (+) Просматривать список поездов на станции
#
###

require_relative 'cargo_train.rb'
require_relative 'cargo_van.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_van.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'van.rb'

class Menu

  attr_reader :stations, :routes, :trains, :vans
  
  def initialize
    @stations = []
    @routes = []
    @trains = []
    @vans = []
  end

  def show_menu
  loop do 
      context_menu
      choice = gets.chomp.to_i
      case choice
      when 1 then create_station
      when 2 then create_train
      when 3 then create_route
      when 4 then add_station_to_route
      when 5 then delete_station_from_route
      when 6 then add_route_to_train
      when 7 then add_van
      when 8 then delete_van
      when 9 then move_train_forward
      when 10 then move_train_backward
      when 11 then show_trains_on_station
      when 12 then show_stations
      when 0 then quit
      else
        return 'Некорректный выбор. Повторите ввод.'
      end
        
    end
        
  end
      
   
 def context_menu
    puts "Что вы хотите сделать?"
    puts '1. Создать станцию.'
    puts '2. Создать поезд.'
    puts '3. Создать маршрут.'
    puts '4. Добавить станцию в маршрут.'
    puts '5. Удалить станцию из маршрута.'
    puts '6. Назначить маршрут поезду.'
    puts '7. Добавить вагон к поезду.'
    puts '8. Отцепить вагон от поезда.'
    puts '9. Переместить поезд вперёд.'
    puts '10. Переместить поезд назад.'
    puts '11. Просмотреть список поездов на станции.'
    puts '12. Просмотреть список станций.'
    puts '0. Выйти.'
  end

  def create_station
    station_name = get_station_name
    @stations << Station.new(station_name) unless station_name.empty?
  end

   def create_train
    puts 'Введите 1 для создания пассажиского поезда и 2 - для грузового.'
    choice = gets.chomp.to_i
      case choice
      when 1 then create_passenger_train
      when 2 then create_cargo_train
      else
        return 'Некорректный выбор. Повторите ввод.'
      end
    end

  def create_passenger_train
    number = get_train_number
    return if number.empty?
    train = PassengerTrain.new(number)
    self.trains << train
  end

  def create_cargo_train
    number = get_train_number
    return if number.empty?
    train = CargoTrain.new(number)
    self.trains << train
  end

  def create_route
    return if self.stations.length < 2
    
    self.show_stations
    start_index = get_start_index
    finish_index = get_finish_index
    
    return if start_index.nil? || self.stations[start_index].nil?
    return if finish_index.nil? || self.stations[finish_index].nil?

    @routes << Route.new(self.stations[start_index], self.stations[finish_index])
  end

  def add_station_to_route
    return if self.routes.empty?

    station_index = get_station_index
    return if station_index.nil? || self.stations[station_index].nil?

    route_index = get_route_index
    return if route_index.nil? || self.routes[route_index].nil?

    self.routes[route_index].add_station(stations[station_index])
  end

  def delete_station_from_route
    return if self.routes.empty?

    route_index = get_route_index
    return if route_index.nil? || self.routes[route_index].nil?

    self.routes[route_index].delete_station
  end

  def add_route_to_train
    return if self.trains.empty? || self.routes.empty?

    route_index = get_route_index
    return if route_index.nil? || self.routes[route_index].nil?

    train_index = get_train_index
    return if train_index.nil? || self.trains[train_index].nil?
    
    self.trains[train_index].route=(self.routes[route_index])    
  end

  def add_van
    return if self.trains.empty?

    train_index = get_train_index

    return if self.trains[train_index].nil?

    case self.trains[train_index].class.to_s
      when 'CargoTrain' then van = CargoVan.new
      when 'PassengerTrain' then van = PassengerVan.new
      else return
    end

    self.trains[train_index].add_van(van)
  end

  def delete_van
    return if self.trains.empty?

    train_index = get_train_index
  
    return if train_index.nil? || self.trains[train_index].nil?
    
    self.trains[train_index].delete_van
  end

  def move_train_forward
    return if self.trains.empty? || self.routes.empty?

    train_index = get_train_index
   
    return if train_index.nil? || self.trains[train_index].nil?

    return if self.trains[train_index].route.nil?

    self.trains[train_index].move_forward
  end

  def move_train_backward
    return if self.trains.empty? || self.routes.empty?

    train_index = get_train_index
    
    return if train_index.nil? || self.trains[train_index].nil?

    return if self.trains[train_index].route.nil?

    self.trains[train_index].move_backward
  end

  def show_stations
    self.stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
    puts '---'
  end


  def show_trains_on_station
    return if self.trains.empty? || self.stations.empty?

    self.show_stations
    station_index = get_station_index

    return if station_index.nil? || self.stations[station_index].nil?

    trains = [] 
    self.stations[station_index].trains.each { |number, train| trains << train }
    show_trains(trains)

    puts '---'
  end
  

  private

  def get_train_type_index
    print "Введите индекс типа поезда: "
    get_integer
  end

  def get_start_index
    print "Введите индекс начальной станции: "
    get_integer
  end
  
  def get_finish_index
    print "Введите индекс конечной станции: "
    get_integer
  end

  def get_station_name
    print "Введите название станции: "
    gets.chomp.lstrip.rstrip
  end

  def get_station_index
    print "Введите индекс станции: "
    get_integer
  end

  def get_train_number
    print "Введите номер поезда: "
    gets.chomp.lstrip.rstrip
  end

  def get_train_index
    print "Введите индекс поезда: "
    get_integer
  end

  def get_route_index
    print "Введите индекс маршрута: "
    get_integer
  end

  def get_integer
    input = gets.chomp.lstrip.rstrip
    return input.empty? ? nil : input.to_i
  end

  def show_trains(trains)
    trains.each_with_index do |train, index|
      showing_info = [
        "[#{index}] Поезд №#{train.number}",
        "Тип: #{train.type}",
        "Вагонов: #{train.vans.length} шт."
      ]
      showing_info << "Текущая станция: #{train.current_station.name}" unless train.route.nil?
      puts showing_info.join(" | ")
    end
  end

  def quit 
    exit!
  end
end

Menu.new.show_menu
