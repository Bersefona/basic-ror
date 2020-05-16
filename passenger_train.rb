require_relative 'train.rb'

class PassengerTrain < Train
  
  def initialize(number)
    super(number)
  end
 
  def add_van(van)
    super(van) if van.is_a?(PassengerVan)
  end

end

