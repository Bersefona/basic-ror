require_relative 'train.rb'

class CargoTrain < Train
  
  def initialize(name, type = 'cargo')
    super
  end

  def add_van(van)
    super(van) if van.is_a?(CargoVan)
  end

end
