class Van
  
  attr_reader :number

  def initialize
    @number = generate_number
  end

  def generate_number
    srand.to_s.slice(0..9)
  end
  
end
