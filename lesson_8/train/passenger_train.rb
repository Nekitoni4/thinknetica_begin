# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../train/train'
class PassengerTrain < Train
  include InstanceCounter

  TRAIN_TYPE = 'passenger'

  def initialize(name)
    super(TRAIN_TYPE, name)
  end
end
