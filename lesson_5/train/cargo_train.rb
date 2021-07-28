require_relative '../modules/instance_counter'
class CargoTrain < Train

  include InstanceCounter

  TRAIN_TYPE = "cargo"

  def initialize(name)
    super(name, TRAIN_TYPE)
  end
end
