require_relative 'train.rb'

class CargoTrain < Train
  
  def initialize(number)#, type = 'cargo')
    super(number)
  end

  def add_van(van)
    super(van) if van.is_a?(CargoVan)
  end

end

