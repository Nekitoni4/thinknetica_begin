# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../train/train'
class CargoTrain < Train
  include InstanceCounter

  TRAIN_TYPE = 'cargo'

  def initialize(name)
    super(TRAIN_TYPE, name)
  end
end
