require_relative '../modules/manufacture_company'
require_relative '../modules/instance_counter'

class Train

  include ManufactureCompany
  include InstanceCounter

  @@train_storage = []

  attr_reader :number_name, :type
  attr_accessor :count_cars, :speed, :current_station, :route, :cars

  def initialize(number_name = "test_train_number", type)
    raise 'Некорректный номер поезда или тип' unless valid?(number_name, type)
    @number_name = number_name
    @type = type
    @cars = []
    @speed = 0
    self.class.send :save_train, self
    self.accounting_instances
  end

  def self.find(train_number)
    @@train_storage.detect { |train| train.number_name == train_number}
  end

  def set_train_on_the_way(route)
    set_route(route)
    set_current_station(route.starting_station)
    set_train_on_the_current_station
  end
  
  def acceleration(speed)
    self.speed = speed if speed > self.speed
  end

  def braking
    self.speed = 0
  end

  def add_car(car)
    self.cars.push(car) if self.type.eql? car.type; 
  end

  def uncoupling_car
    self.cars.pop
  end

  def previous_station
    self.all_stations_in_this_route[current_station_position - 1] unless start_station?
  end

  def next_station
    self.all_stations_in_this_route[current_station_position + 1] unless end_station?
  end

  def move_backward
    if previous_station
    self.current_station = previous_station
    self.current_station.add_train(self)
    end
  end

  def move_forward
    if next_station
    self.current_station = next_station
    self.current_station.add_train(self)
    end
  end

  def start_station?
    current_station_position == 0
  end

  def end_station?
    current_station_position == all_stations_in_this_route.length - 1
  end

  def valid?(number_name, type)
    validate_number_name(number_name)
    validate_type(type)
    true
  rescue
    false
  end


  private_class_method

    def self.save_train(instance)
      @@train_storage << instance
    end

  protected

  def validate_number_name(number_name)
    raise unless /^[a-z0-9]{3}-*[a-z0-9]{2}/.match?(number_name)
  end

  def validate_type(type)
    raise if type.length < 5
  end
  
  private

  def all_stations_in_this_route
    self.route.all_stations
  end

  def current_station_position
    all_stations_in_this_route.index(self.current_station)
  end

  def set_route(route)
    @route = route
  end

  def set_current_station(station)
    @current_station = station
  end

  def set_train_on_the_current_station
    self.current_station.add_train(self)
  end
end

