require_relative '../modules/instance_counter'

class Station

  include InstanceCounter

  attr_reader :name, :trains

  @@station_storage = []

  def initialize(name)
    @name = name
    @trains = []
    self.class.send :save_station, self
    self.accounting_instances
  end

  def self.all
    @@station_storage
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
    self.trains.push(train) unless train_existing?(train)
  end

  def show_all_trains
    self.trains.each_with_index { |train, index| puts "#{index + 1}) #{train.number_name}" }
  end

  private_class_method

  def self.save_station(instance)
    @@station_storage << instance
  end
end