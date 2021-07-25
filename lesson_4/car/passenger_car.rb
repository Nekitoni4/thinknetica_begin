require_relative "train_car.rb"

class PassengerCar < TrainCar
  def log
    puts "This is passenger"
  end
end