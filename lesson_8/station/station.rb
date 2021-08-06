# frozen_string_literal: true

require_relative '../modules/instance_counter'

class Station
  include InstanceCounter

  class << self
    @stations_storage = []

    attr_accessor :stations_storage
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    validate!
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

  def valid?(type)
    validate type
    true
  rescue StandardError
    false
  end

  def each_train(&block)
    trains.each(&block)
  end

  def self.save_station(instance)
    stations_storage << instance
  end

  protected

  def validate!
    validate_name!
  end

  def validate_name!
    raise 'Длина названия станции меньше 10 символов' if name.length < 10
  end
end
