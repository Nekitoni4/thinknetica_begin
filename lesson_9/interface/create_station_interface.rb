# frozen_string_literal: true

class CreateStationInterface
  include RailwayHelpers

  def initialize(stations_storage)
    @stations = stations_storage
  end

  def self.run!(stations_storage)
    new(stations_storage).send(:create_station_view)
  end

  protected

  attr_accessor :stations

  def create_station_view
    puts 'Вы в режиме создания станций!'
    loop do
      puts 'Хотите ли выйти из данного режима?'
      exit_action = gets.chomp
      break if exit_action.downcase == 'да'

      add_station(create_station)
    rescue StandardError => e
      puts "Произошла ошибка: #{e.message}!!!\n__________"
    end
  end

  def create_station
    puts "Пожалуйста, введите имя (больше 10 символов) создаваемой станции\n"
    station = create_station_from_user_input
    puts 'Станция, успешно создана!'
    station
  end

  def add_station(station)
    stations << station
  end

  def create_station_from_user_input
    name_station = gets.chomp
    create_station_instance name_station
  end
end
