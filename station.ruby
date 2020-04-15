class Station 

  attr_accessor :color
  attr_reader :name, :trains

  # имеет название, которое указывается при создании
  def initialize(name)
    @name = name
    @trains = []
  end

  # может вовращать список всех поездов на станции,
  # находящиеся в текущий момент
  def show_trains 
    puts @trains
  end  

  # может возвращать список поездов на станции
  # по типу: кол-во грузовых, пассажирских
  def type
    puts @type
  end

  # может принимать поезда
  def add_train(train)
  @trains << train
  end

  # может отправлять поезда
  def del_train(train)
  @trains.delete(train)
  end  

end  
