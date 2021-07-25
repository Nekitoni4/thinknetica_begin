require_relative "car/passenger_car.rb"
require_relative "car/cargo_car.rb"
require_relative "car/passenger_car.rb"
require_relative "car/train_car.rb"
require_relative "route/route.rb"
require_relative "station/station.rb"
require_relative "train/train.rb"
require_relative "train/cargo_train.rb"
require_relative "train/passenger_train.rb"
require_relative "interface/text_interface.rb"

interface = TextInterface.new

interface.run