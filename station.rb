###
#  В классе Station (жд станция) создать метод класса all,
#  который возвращает все станции (объекты), созданные на данный момент
###

class Station 

  attr_reader :name, :trains
  
  @@stations = []
  
  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
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
