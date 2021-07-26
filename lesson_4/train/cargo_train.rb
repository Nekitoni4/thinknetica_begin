class CargoTrain < Train
  TRAIN_TYPE = "cargo"

  def initialize(name)
    super(name, TRAIN_TYPE)
  end

  def add_car(car)
    super(car) if car.type.eql? "cargo"
  end
end
