class PassengerTrain < Train
  TRAIN_TYPE = "passenger"

  def initialize(name)
    super(name, TRAIN_TYPE)
  end

  def add_car(car)
    super(car) if car.type.eql? "passenger"
  end
end