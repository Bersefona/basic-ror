require_relative 'instance_counter.rb'

class Station 
  include InstanceCounter
  attr_reader :name, :trains
  NAME_FORMAT = /^[a-zа-я]{1,50}([ \-][a-zа-я]{1,50})?([ \-][\d]{1,5})?$/i

  @@stations = []
  
  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
  end
  
  def get_train(train)
    raise StandardError "Можно разместить только поезд" unless train.is_a?(Train)
    @trains[train.number.to_i] = train
  end
  
  def delete_train(number)
    raise StandardError "Не найден поезд с номером №#{number}" if self.trains[number].nil?
    self.trains.delete(number)
  end
  
  def types(type)
    @trains.select {|train| train.type == type}
  end  

  protected 
  
  def validate!
    raise "Станция не может быть пустой." if self.name.nil?
    raise StandardError, "Некорректное имя (#{self.name})" if self.name !~ NAME_FORMAT
  end

  def valid?
    validate!
    true
  rescue
    false
  end
  
end 
