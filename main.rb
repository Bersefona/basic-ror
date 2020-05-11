require_relative 'cargo_train.rb'
require_relative 'cargo_van.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_van.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'van.rb'

class Menu

  attr_accessor :stations, :routes, :trains, :vans
  
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
      when 8 then delete_van_from_train
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
    @stations << Station.new(station_name)
    puts "Создана станция '#{station_name}'."
  end

  def create_train
    begin
      puts "Введите тип passenger или cargo."
      type = gets.chomp.to_s
      case type
        when 'passenger' then create_passenger_train
        when 'cargo' then create_cargo_train
      end
    rescue RuntimeError => e
      puts "#{e.message}"
      retry
    end
  end

  def create_passenger_train
    begin
      number = get_train_number
      return if number.empty?
      train = PassengerTrain.new(number)
      self.trains << train
      "Создан поезд '№#{number}' пассажирского типа."
    rescue RuntimeError => e
      puts "#{e.message}"
      retry
    end
  end

  def create_cargo_train
    begin
      number = get_train_number
      return if number.empty?
      train = CargoTrain.new(number)
      self.trains << train
      "Создан поезд '№#{number}' грузового типа."
    rescue RuntimeError => e
      puts "#{e.message}"
      retry
    end
  end

  def create_route
    return if self.stations.length < 2
    
    self.show_stations
    start_index = get_start_index
    validate!(start_index, self.stations)

    finish_index = get_finish_index
    validate!(finish_index, self.stations)
    
    @routes << Route.new(self.stations[start_index], self.stations[finish_index])
    puts "Создан маршрут из '#{self.stations[start_index].name} в #{self.stations[finish_index].name}'."
  end

  def add_station_to_route
    return if self.routes.empty?

    self.show_stations
    station_index = get_station_index
    validate!(station_index, self.stations)

    self.show_routes
    route_index = get_route_index
    validate!(route_index, self.routes)

    self.routes[route_index].add_station(stations[station_index])
    puts "В маршрут добавлена станция '#{stations[station_index].name}'."
  end

  def delete_station_from_route
    return if self.routes.empty?

    self.show_routes
    route_index = get_route_index
    validate!(route_index, self.routes)

    station_name = self.routes[route_index].stations[-2].name
    self.routes[route_index].delete_station
    puts "Из маршрута удалена станция '#{station_name}'."
  end

  def add_route_to_train
    return if self.trains.empty? || self.routes.empty?

    self.show_routes
    route_index = get_route_index
    validate!(route_index, self.routes)

    self.show_all_trains
    train_index = get_train_index
    validate!(train_index, self.trains)
    
    self.trains[train_index].route=(self.routes[route_index])
    puts "Маршрут добавлен к поезду №#{self.trains[train_index].number}"
  end

  def add_van
    return if self.trains.empty?

    self.show_all_trains
    train_index = get_train_index
    validate!(train_index, self.trains)

    case self.trains[train_index].class.to_s
      when 'CargoTrain' then van = CargoVan.new
      when 'PassengerTrain' then van = PassengerVan.new
      else return
    end

    self.trains[train_index].add_van(van)
    puts "Вагон прицеплен к поезду №#{self.trains[train_index].number}."
  end

  def delete_van_from_train
    return if self.trains.empty?
    
    self.show_all_trains
    train_index = get_train_index
    validate!(train_index, self.trains)
    
    self.trains[train_index].delete_van
    puts "Вагон отцеплен от поезда №#{self.trains[train_index].number}."
  end

  def move_train_forward
    return if self.trains.empty? || self.routes.empty?

    self.show_all_trains
    train_index = get_train_index
    validate!(train_index, self.trains)

    if self.trains[train_index].route.nil?
      puts "У поезда №#{self.trains[train_index].number} нет назначенного маршрута."
    else
      self.trains[train_index].move_on
      puts "Поезд №#{self.trains[train_index].number} прибыл на станцию '#{self.trains[train_index].current_station.name}'."
    end
    
    puts '-----'
  end

  def move_train_backward
    return if self.trains.empty? || self.routes.empty?

    self.show_all_trains
    train_index = get_train_index
    validate!(train_index, self.trains)

    if self.trains[train_index].route.nil?
      puts "У поезда №#{self.trains[train_index].number} нет назначенного маршрута."
    else
      self.trains[train_index].move_on
      puts "Поезд №#{self.trains[train_index].number} прибыл на станцию '#{self.trains[train_index].current_station.name}'."
    end
    
    puts '-----'
  end


  def show_stations
    self.stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
    puts '-----'
  end

  def show_trains_on_station
    return if self.trains.empty? || self.stations.empty?

    self.show_stations
    station_index = get_station_index
    validate!(station_index, self.stations)

    trains = [] 
    self.stations[station_index].trains.each { |train| trains << train }
    show_trains(trains)

    puts '-----'
  end
      
  def show_routes
    self.routes.each_with_index do |route, index|
      stations = []
      route.stations.each { |station| stations << station.name }
      puts "[#{index}] #{stations.join(" -> ")}"
    end
    puts '---'
  end
   
  def show_all_trains
    show_trains(self.trains)
    puts '---'
  end
      
  protected
      
  def validate!(index, object)
    raise "Индекс [#{index}] не найден." if !index.is_a?(Integer) || object[index].nil?
  end
  

  private

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
    return (input.empty? || /\D/.match(input)) ? input : input.to_i
  end

  def show_trains(trains)
    trains.each_with_index do |train, index|
      showing_info = [
        "[#{index}] Поезд №#{train.number}",
        "Тип: #{train.type}"
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

