# frozen_string_literal: true

class ShowStationsInterface
  include RailwayHelpers

  def initialize(stations_storage)
    @stations = stations_storage
  end

  def self.run!(stations_storage)
    new(stations_storage).send(:show_info_railway_view)
  end

  private

  attr_accessor :stations

  def show_info_railway_view
    if !stations.empty?
      puts "Вы в режиме просмотра списка станций. Пожалуйста, выберите, что вы хотите сделать?\n" \
           "1) Посмотреть список станций\n" \
           "2) Посмотреть список поездов на конкретной станции\n" \
           "3) Посмотреть всю информацию обо всех поездах на станциях\n"
    else
      puts 'В данный момент станций нет. Создайте новую, пожалуйста ;) '
      CreateStationInterface.run! stations
    end
  end

  def show_info_railway_repl
    loop do
      puts 'Чтобы выйти из этого режима, нажмите 0'
      action_number = gets.to_i
      action_number.zero? ? break : manage_show_actions(action_number)
    end
  end

  def manage_show_actions(action_number)
    show_actions = {
      1 => method(:show_all_stations),
      2 => method(:show_all_trains_in_station),
      3 => method(:show_info_trains_in_stations)
    }
    show_actions[action_number].call
  end

  def show_info_trains_in_stations
    stations.each { |station| show_info_trains_in_station(station) }
  end

  def show_info_trains_in_station(station)
    if station.trains.empty?
      puts "Пока на станции #{station.name} нет поездов"
    else
      station.each_train do |train|
        puts "Номер поезда: #{train.number_name}\n Тип: #{train.type}\n Кол-во вагонов: #{train.number_cars}.\n"
        show_all_cars_in_train(train)
      end
    end
  end

  def show_all_cars_in_train(train)
    if train.cars.empty?
      puts 'Данный поезд не имеет вагонов'
    else
      show_info_by_each_car(train)
    end
  end

  def show_info_by_each_car(train)
    train.each_car_index do |car, index|
      puts "Номер вагона: #{index + 1}\n"
      show_by_type_car_info_actions = {
        'passenger' => method(:show_info_for_passenger_car),
        'cargo' => method(:show_info_for_cargo_car)
      }
      show_by_type_car_info_actions[car.type].call(car)
    end
  end

  def show_info_for_passenger_car(passenger_car)
    puts "Тип вагона: пассажирский\nКол-во свободных мест: #{passenger_car.number_free_seats}\n" \
         "Кол-во занятых мест: #{passenger_car.number_of_occupied_seats}\n____________"
  end

  def show_info_for_cargo_car(cargo_car)
    puts "Тип вагона: грузовой\nКол-во свободного объёма: #{cargo_car.free_volume}\n" \
          "Кол-во занятого объёма: #{cargo_car.filled_volume}\n______________"
  end

  def show_all_trains_in_station
    puts 'Пожалуйста, выберите конкретную станцию для дальнейшего просмотра на ней всех поездов'
    show_all_trains_in_station_repl
  end

  def show_all_trains_in_station_repl
    loop do
      puts 'Введите 0, чтобы выйти из данного режима'
      show_all_stations stations
      station_index_number = gets.to_i - 1
      break if station_index_number == -1

      show_all_trains_by_station_index station_index_number
    end
  end

  def show_all_trains_by_station_index(station_index_number)
    if station_existing_in_storage? stations, station_index_number
      stations[station_index_number].show_all_trains
    else
      puts 'Некорректный номер'
    end
  end
end
