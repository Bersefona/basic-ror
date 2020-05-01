###
#
#  Создать программу, которая будет позволять пользователю через текстовый интерфейс делать следующее:
# - (+) Создавать станции
# - (+) Создавать поезда
# - ( ) Создавать маршруты
# - ( ) Управлять станциями в нем (добавлять)
# - ( ) Управлять станциями в нем (удалять)
# - ( ) Назначать маршрут поезду
# - ( ) Добавлять вагоны к поезду
# - ( ) Отцеплять вагоны от поезда
# - ( ) Перемещать поезд по маршруту вперед и назад
# - ( ) Просматривать список станций и список поездов на станции
#
###

require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_van.rb'
require_relative 'cargo_train.rb'
require_relative 'cargo_van.rb'
require_relative 'van.rb'

class Main

  attr_reader :trains, :routes, :stations

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def context_menu 
    
    loop do 
      show_menu
      choice = gets.chomp.to_i
      case choice
      when 1 then create_station
      when 2 then create_train
      when 3 then create_route
      when 4 then add_route_station
      when 5 then delete_route_station
      when 6 then assign_route_to_train
      when 7 then add_van
      when 8 then delete_van
      when 9 then move_train
      when 10 then show_trains_and_stations
      when 0 then quit
      else
        return 'Некорректный выбор. Повторите ввод.'
      end
        
    end
        
  end
      
   
 def show_menu
    puts "Что вы хотите сделать?"
    puts '1. Создать станцию.'
    puts '2. Создать поезд.'
    puts '3. Создать маршрут.'
    puts '4. Добавить станцию в маршрут.'
    puts '5. Удалить станцию из маршрута.'
    puts '6. Назначить маршрут поезду.'
    puts '7. Добавить вагон к поезду.'
    puts '8. Отцепить вагон от поезда.'
    puts '9. Переместить поезд по маршруту.'
    puts '10. Просмотреть список станций и список поездов на станции.'
    puts '0. Выйти.'
  end


  def create_station
    puts "Введите название станции: "
    name = gets.chomp
    @stations << Station.new(name)
    puts @stations
  end
  
  def create_train
    puts 'Введите номер поезда: '
    number = gets.chomp
    
    puts 'Введите 1, если тип поезда пассажирский, и 2, если грузовой: '
    type = gets.to_i

    case type
    when 1 then @trains << PassengerTrain.new(number)
    when 2 then @trains << CargoTrain.new(number)
    end
    puts @trains
  end
  
  def add_van
    puts 'Выберите поезд, к которому хотите присоединить вагон: '
    # selected_train
    # return if selected_train.nil?

    if selected_train.is_a?(PassengerTrain)
      selected_train.add_van(PassengerVan.new)

    elsif selected_train.is_a?(CargoTrain)
      selected_train.add_van(CargoVan.new)
    end
    puts @trains
  end

  def delete_van
    puts 'Выберите поезд, от которого хотите отцепить вагон: '
    # selected_train
    # return if selected_train.nil?

    selected_train.delete_van
    puts @trains
  end



  def show_trains_and_stations
    stations.each do |station|
      puts "Станция: #{station.name}"
      puts 'Поезда:'
     # поезда?
    end
  end  
      
end     
