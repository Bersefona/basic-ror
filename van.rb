# Подключить модуль к классам Вагон
require_relative 'manufacturer.rb'

class Van
  include Manufacturer
  attr_reader :number

  def initialize
    @number = generate_number
  end

  def generate_number
    srand.to_s.slice(0..9)
  end
  
end
