require_relative "train_car.rb"

class CargoCar < TrainCar
  def log
    puts "This is cargo"
  end
end