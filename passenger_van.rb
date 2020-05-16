require_relative 'van.rb'

class PassengerVan < Van
  
  def take_up
    super(1)
  end  

  def free_up
    super(1)
  end  
 
end
