class PassengerTrain < Train
  TRAIN_TYPE = "passenger"

  def initialize(name)
    super(name, TRAIN_TYPE)
  end
end