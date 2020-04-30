class CargoTrain < Train

  def add_van(van)
    super(van) if van.is_a?(CargoVan)
  end

end
