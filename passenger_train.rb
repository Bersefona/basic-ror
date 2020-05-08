require_relative 'train.rb'

class PassengerTrain < Train
  
  def initialize(name, type = 'passenger')
    super
  end
 
  def add_van(van)
    super(van) if van.is_a?(PassengerVan)
  end

end
