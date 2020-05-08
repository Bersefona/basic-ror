require_relative 'train.rb'

class PassengerTrain < Train
  

  def add_van(van)
    super(van) if van.is_a?(PassengerVan)
  end

end
