require_relative '../modules/instance_counter'
class PassengerTrain < Train

  include InstanceCounter

  TRAIN_TYPE = "passenger"

  def initialize(name)
    super(name, TRAIN_TYPE)
  end
end