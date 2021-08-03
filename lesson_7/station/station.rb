require_relative '../modules/instance_counter'

class Station

  include InstanceCounter

  attr_reader :name, :trains

  @@station_storage = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.send :save_station, self
    self.accounting_instances
  end

  def self.all
    @@station_storage
  end

  def trains_by_type(type)
    self.trains.find_all { |train| train.type.eql?(type)}
  end

  def count_trains_by_type(type)
    trains_by_type(type).length
  end

  def train_existing?(train)
    self.trains.include?(train)
  end

  def train_departure(train)
    self.trains.delete(train) if train_existing?(train)
  end

  def add_train(train)
    self.trains << train unless train_existing?(train)
  end

  def show_all_trains
    self.trains.each_with_index { |train, index| puts "#{index + 1}) #{train.number_name}" }
  end

  def valid?(type)
    validate type
    true
  rescue
    false
  end

  def each_train
    self.trains.each { |train| yield train }
  end

  private_class_method

  def self.save_station(instance)
    @@station_storage << instance
  end

  protected

  def validate!
    validate_name!
  end

  def validate_name!
    raise 'Длина названия станции меньше 10 символов' if self.name.length < 10
  end
end