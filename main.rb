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
      when 7 then add_van_to_train
      when 8 then delete_van_from_train
      when 9 then move_train_forward
      when 10 then move_train_backward
      when 11 then show_trains_on_station
      when 12 then show_stations
      when 13 then use_van
      when 14 then free_van
      when 15 then show_trains_on_one_station
      when 16 then show_trains_on_each_station
      #when 17 then test
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
    puts '13. Занять вагон.'
    puts '14. Освободить вагон.'
    puts '15. Показать поезда на одной станции.'
    puts '16. Показать поезда на каждой станции.'
    #puts '17. Тест.'
    puts '0. Выйти.'
  end

=begin
  def test
    self.stations << Station.new('Seoul')
    self.stations << Station.new('Incheon')
    self.stations << Station.new('Daegu')
    self.stations << Station.new('Busan')
    self.routes << Route.new(stations[0], stations[-1])
    train1 = PassengerTrain.new("12345")
    train1 = route(routes[0])
    self.trains << train1
    15.times do
      seats = rand(100..200)
      van = PassengerVan.new(seats)
      train1.add_van(van)
    end   
  end  
=end


  def create_station
    station_name = get_station_name
    @stations << Station.new(station_name) unless station_name.empty?
    puts "Создана станция '#{station_name}'."
  end

  def create_train
    begin
      print "Введите тип поезда (passenger/cargo): "
      type = gets.chomp.to_s
      number = get_train_number
      return if number.empty?
      train = PassengerTrain.new(number) if type == 'passenger'
      train = CargoTrain.new(number) if type == 'cargo'
      self.trains << train
    rescue RuntimeError => e
      puts "#{e.message}"
      retry
    end
  end

def create_route
    return if stations.length < 2
    start = get_station { puts 'Начальная станция: ' }
    finish = get_station { puts 'Конечная станция: ' }
    routes << Route.new(start, finish)
    puts "Создан маршрут '#{start.name} -> #{finish}'."
  end

  def add_station_to_route
    return if routes.empty?
    station = get_station
    route = get_route
    route.add_station(station)
    "В маршрут добавлена станция '#{station.name}'."
  end

  def delete_station_from_route
    return if self.routes.empty?

    self.show_routes
    route_index = get_route_index
    return if route_index.nil? || self.routes[route_index].nil?

    self.routes[route_index].delete_station
    puts "Из маршрута удалена станция '#{station_name}'."
  end

  def add_route_to_train
    return if trains.empty? || routes.empty?

    train = get_train
    train.route = get_route
    "Маршрут добавлен к поезду №#{train.number}."
  end

  def add_van_to_train
    return if trains.empty?

    train = get_train

    case train.class.to_s
    when 'CargoTrain' then train.add_van(create_cargo_van)
    when 'PassengerTrain' then train.add_van(create_passenger_van)
    end

    "Вагон добавлен к поезду №#{train.number}"
  end

  def use_van
    return if trains.empty?

    train = get_train
    van = get_van(train)

    case train.class.to_s
    when 'CargoTrain' then use_cargo_van(van)
    when 'PassengerTrain' then van.take_up_seat
    end

    "Пространство в вагоне №#{van.number} поезда №#{train.number} было успешно занято."
  end

  def free_van
    return if trains.empty?

    train = get_train
    van = get_van(train)

    case train.class.to_s
    when 'CargoTrain' then free_cargo_van(van)
    when 'PassengerTrain' then van.free_up_seat
    end

    "Пространство в вагоне №#{van.number} поезда №#{train.number} освобождено."
  end


  def delete_van_from_train
    return if trains.empty?

    train = get_train

    train.delete_van
    "Вагон отцеплен от поезда №#{train.number}."
  end

  def move_train_forward
    return if self.trains.empty? || self.routes.empty?

    self.show_all_trains
    train_index = get_train_index

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


  def show_trains_on_one_station
    return if stations.empty?
    station = get_station
    show_trains_on_station(station)
  end

  def show_trains_on_each_station
    return if stations.empty?

    stations.each do |station|
      show_trains_on_station(station)
      puts
    end

  end
 
 def show_trains_on_station(station)
    puts "Станция: #{station.name} (поездов: #{station.trains.length})"
    station.each_train do |train|
      puts train.to_s
      train.each_van { |van| puts van.to_s }
      puts
    end
  end

  def show_routes
    self.routes.each_with_index do |route, index|
      stations = []
      route.stations.each { |station| stations << station.name }
      puts "[#{index}] #{stations.join(" -> ")}"
    end
    puts '-----'
  end
   
  def show_all_trains
    show_trains(self.trains)
  end
    
  private

  def get_van(train)
    show_vans(train)
    print 'Введите индекс вагона: '
    van_index = get_integer
    return if van_index.nil?
    train.vans[van_index]
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
    gets.chomp.strip
  end

  def get_station
    show_stations
    print 'Введите индекс станции: '
    station_index = get_integer
    stations[station_index]
  end

  def get_station_index
    print "Введите индекс станции: "
    get_integer
  end

  def get_train_number
    print "Введите номер поезда: "
    gets.chomp.strip
  end

  def get_train
    show_all_trains
    print 'Введите индекс поезда: '
    train_index = get_integer
    trains[train_index]
  end  

  def get_train_index
    print "Введите индекс поезда: "
    get_integer
  end

  def get_route
    show_routes
    print 'Введите индекс маршрута: '
    route_index = get_integer
    routes[route_index]
  end  
  
  def get_route_index
    print "Введите индекс маршрута: "
    get_integer
  end

  def get_seats_on_train
    print 'Введите кол-во мест в вагоне: '
    get_integer
  end

  def get_volume
    print 'Введите объём: '
    get_integer
  end

  def get_integer
    input = gets.chomp.lstrip.rstrip
    return (input.empty? || /\D/.match(input)) ? input : input.to_i
  end

  def show_vans(train)
    train.vans.each_with_index { |van, index| puts "[#{index}] #{van}" }
  end

  def show_trains(trains)
    trains.each_with_index do |train, index|
      puts "[#{index}] Поезд №#{train.number}| ПАССАЖИРСКИЙ | Вагонов: #{train.vans.length}" if train.is_a?(PassengerTrain)
      puts "[#{index}] Поезд №#{train.number} | ГРУЗОВОЙ | Вагонов: #{train.vans.length}" if train.is_a?(CargoTrain)
    end
  end

  def free_cargo_van(van)
    volume = get_volume
    van.decrease_volume(volume)
  end

  def use_cargo_van(van)
    volume = get_volume
    van.increase_volume(volume)
  end

  def use_passenger_van(van)
    van.take_up_seat
  end

  def create_cargo_van
    CargoVan.new(get_volume)
  end

  def create_passenger_van
    PassengerVan.new(get_seats_on_train)
  end

  def quit 
    exit!
  end
end

Menu.new.show_menu

