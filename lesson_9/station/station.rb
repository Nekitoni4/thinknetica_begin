# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'
require_relative '../modules/accessors'

class Station
  include InstanceCounter
  include Validation
  include Accessors

  class << self
    @stations_storage = []

    attr_accessor :stations_storage
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    self.class.send :save_station, self
    accounting_instances
  end

  def self.all
    stations_storage
  end

  def trains_by_type(type)
    trains.find_all { |train| train.type.eql?(type) }
  end

  def count_trains_by_type(type)
    trains_by_type(type).length
  end

  def train_existing?(train)
    trains.include?(train)
  end

  def train_departure(train)
    trains.delete(train) if train_existing?(train)
  end

  def add_train(train)
    trains << train unless train_existing?(train)
  end

  def show_all_trains
    trains.each_with_index { |train, index| puts "#{index + 1}) #{train.number_name}" }
  end

  def each_train(&block)
    trains.each(&block)
  end

  def self.save_station(instance)
    stations_storage << instance
  end
end
