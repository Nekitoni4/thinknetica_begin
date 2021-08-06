# frozen_string_literal: true

require_relative '../car/cargo_car'
require_relative '../car/passenger_car'
require_relative '../station/station'
require_relative '../route/route'
require_relative '../train/passenger_train'
require_relative '../train/cargo_train'

module RailwayHelpers
  def create_station_from_user_input
    name_station = gets.chomp
    create_station_instance(name_station)
  end

  def show_all_stations(stations)
    stations.each_with_index { |station, index| puts "#{index + 1})#{station.name}" }
  end

  def show_all_trains(trains)
    trains.each_with_index { |train, index| puts "#{index + 1})#{train.number_name}" }
  end

  def show_all_routes(routes)
    routes.each_with_index do |route, index|
      puts "#{index + 1})#{route.starting_station.name}-#{route.end_station.name}"
    end
  end

  def station_existing_in_storage?(storage, index)
    !!storage[index]
  end

  def route_existing_in_storage?(storage, index)
    !!storage[index]
  end

  def train_existing_in_storage?(storage, index)
    !!storage[index]
  end

  def add_route_in_storage(storage, *routes)
    routes.each { |route| storage << route }
  end

  def add_train_in_storage(storage, *trains)
    trains.each { |train| storage << train }
  end

  def add_station_in_storage(storage, *stations)
    stations.each { |station| storage << station }
  end

  def create_station_instance(name)
    Station.new name
  end

  def create_cargo_train(name)
    CargoTrain.new name
  end

  def create_passenger_train(name)
    PassengerTrain.new name
  end

  def create_route(starting_station, end_station)
    Route.new starting_station, end_station
  end

  def create_cargo_car(volume)
    CargoCar.new volume
  end

  def create_passenger_car(number_of_seats)
    PassengerCar.new number_of_seats
  end

  def select_train(storage, current_train_index)
    @selected_train = trains[current_train_index] if train_existing_in_storage? storage, current_train_index
  end

  def select_route(storage, current_route_index)
    @selected_route = storage[current_route_index] if route_existing_in_storage? storage, current_route_index
  end

  def choose_station(stations_storage)
    stations_storage[gets.to_i - 1]
  end
end
