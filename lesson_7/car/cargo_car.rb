class CargoCar < TrainCar

  CAR_TYPE = "cargo"

  def initialize(volume)
    @volume = volume
    @filled_volume = 0
    super(CAR_TYPE)
  end

  def fill(volume)
    increase_volume(volume)
  end

  def free_volume
    diff_filled_and_free_volume
  end

  private
  attr_accessor :volume, :filled_volume

  def increase_volume(volume)
    self.filled_volume += volume
  end

  def diff_filled_and_free_volume
    self.volume - self.filled_volume
  end
end