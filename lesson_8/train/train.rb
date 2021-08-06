# frozen_string_literal: true

require_relative '../modules/manufacture_company'
require_relative '../modules/instance_counter'

class Train
  include ManufactureCompany
  include InstanceCounter

  class << self
    @train_storage = []

    attr_accessor :train_storage
  end

  attr_reader :number_name, :type
  attr_accessor :count_cars, :speed, :current_station, :route, :cars

  def initialize(type, number_name = 'test_train_number')
    @number_name = number_name
    @type = type
    @cars = []
    @speed = 0
    validate!
    self.class.send :save_train, self
    accounting_instances
  end

  def self.find(train_number)
    train_storage.detect { |train| train.number_name == train_number }
  end

  def train_on_the_way(route)
    init_route(route)
    init_current_station(route.starting_station)
    add_train_to_current_station
  end

  def acceleration(speed)
    self.speed = speed if speed > self.speed
  end

  def braking
    self.speed = 0
  end

  def add_car(car)
    cars.push(car) if type.eql? car.type
  end

  def uncoupling_car
    cars.pop
  end

  def previous_station
    all_stations_in_this_route[current_station_position - 1] unless start_station?
  end

  def next_station
    all_stations_in_this_route[current_station_position + 1] unless end_station?
  end

  def move_backward
    current_station.add_train(self) if (self.current_station = previous_station)
  end

  def move_forward
    current_station.add_train(self) if (self.current_station = next_station)
  end

  def start_station?
    current_station_position.zero?
  end

  def end_station?
    current_station_position == all_stations_in_this_route.length - 1
  end

  def valid?
    true if validate_number_name! && validate_type!
  rescue StandardError
    false
  end

  def each_car(&block)
    cars.each(&block)
  end

  def each_car_index(&block)
    cars.each_index(&block)
  end

  def number_cars
    cars.length
  end

  def self.save_train(instance)
    train_storage << instance
  end

  protected

  def validate!
    validate_number_name!
    validate_type!
  end

  def validate_number_name!
    raise 'Неверный формат имени поезда' unless /^[a-z0-9]{3}-*[a-z0-9]{2}/.match?(number_name)
  end

  def validate_type!
    raise 'Длина названия типа поезда меньше 5 символов' if type.length < 5
  end

  private

  def all_stations_in_this_route
    route.all_stations
  end

  def current_station_position
    all_stations_in_this_route.index(current_station)
  end

  def init_route(route)
    @route = route
  end

  def init_current_station(station)
    @current_station = station
  end

  def add_train_to_current_station
    current_station.add_train(self)
  end
end
