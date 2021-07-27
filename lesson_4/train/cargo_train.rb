class CargoTrain < Train
  TRAIN_TYPE = "cargo"

  def initialize(name)
    super(name, TRAIN_TYPE)
  end
end
