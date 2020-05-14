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

  def each_train(&block)
    self.trains.each { |train| yield(train) } if block_given?
  end
  
  def get_train(train)
    @trains[train.number.to_i] = train if train.is_a?(Train)
  end
  
  def delete_train(number)
    self.trains.delete(number)
  end
  
  def types(type)
    @trains.select {|train| train.type == type}
  end  

  protected 
  
  def validate!
    raise "Станция не может быть пустой." if self.name.nil?
    raise "Некорректное имя (#{self.name})" if self.name !~ NAME_FORMAT
  end

  def valid?
    validate!
    true
  rescue
    false
  end
  
end 

