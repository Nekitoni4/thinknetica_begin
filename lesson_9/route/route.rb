# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'
require_relative '../modules/accessors'

class Route
  include InstanceCounter
  include Accessors
  include Validation

  attr_reader :starting_station, :end_station, :intermediate_stations

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermediate_stations = []
    accounting_instances
  end

  def add_intermediate_station(station)
    intermediate_stations.push(station) unless station_existing?(station)
  end

  def delete_intermediate_station(station)
    intermediate_stations.delete(station) if station_existing?(station)
  end

  def all_stations
    [starting_station, *intermediate_stations, end_station]
  end

  def station_existing?(station)
    all_stations.include?(station)
  end
end
