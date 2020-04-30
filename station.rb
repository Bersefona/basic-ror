###
#
# (+) Имеет название, которое указывается при ее создании
# (+) Может принимать поезда (по одному за раз)
# (+) Может возвращать список всех поездов на станции, находящиеся в текущий момент
# (+) Может возвращать список поездов на станции по тип (см. ниже): кол-во грузовых, пассажирских
# (+) Может отправлять поезда.
#
###

class Station 

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end
  
  def get_train(train)
    self.trains << train if train.is_a?(Train)
  end
  
  def delete_train(train)
    self.trains.delete(train)
  end
  
  def types(type)
    @trains.select {|train| train.type == type}
  end  
  
end 
