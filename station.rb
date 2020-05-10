###
#
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
