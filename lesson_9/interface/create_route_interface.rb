# frozen_string_literal: true

class CreateRouteInterface
  include RailwayHelpers

  def initialize(route_storage, stations_storage)
    @routes = route_storage
    @stations = stations_storage
  end

  def self.run!(route_storage, stations_storage)
    new(route_storage, stations_storage).send(:create_route_view)
  end

  private

  attr_accessor :routes, :stations

  def create_route_view
    puts 'Вы находитесь в режиме создания маршрутов! Для того, чтобы создать маршрут - необходимо задать' \
         'начальную и конечную станции. '
    loop do
      puts "Выбрите порядковый номер, предложенного действия: \n" \
           "1) Выбрать станции из существующих\n" \
           "2) Создать новые станции\n" \
           '3) Выйти'
      action_number = gets.to_i
      action_number == 3 ? break : use_action_with_route(action_number)
    end
  end

  def use_action_with_route(action_number)
    actions_with_route = {
      1 => method(:create_route_selected_stations),
      2 => method(:create_route_created_stations)
    }
    actions_with_route[action_number].call
  end

  def create_route_selected_stations
    if stations.length > 1
      puts 'Выберите из предложенного списка станций - необходимую и выберите порядковый номер: '
      show_all_stations(stations)
      create_route_action(choose_start_station, choose_end_station)
    else
      puts 'На данный момент мало станций, чтобы выбрать из них начальную и конечную станции, ' \
            'перевожу вас в режим создания станций'
      CreateStationInterface.run! stations
    end
  end

  def choose_start_station
    puts 'Пожалуйста, выберите начальную станцию'
    choose_station(stations)
  end

  def choose_end_station
    puts 'Пожалуйста, выберите конечную станцию'
    choose_station(stations)
  end

  def create_route_action(start_station, end_station)
    if start_station.nil? || end_station.nil?
      puts 'Некорректно переданные станции[я]!'
    else
      add_route_in_storage(routes, create_route(start_station, end_station))
      puts 'Маршрут успешно создан!'
    end
  end

  def create_route_created_stations
    puts 'Пожалуйста, придумайте название для начальной станции, а затем на следующей строке - конечной'
    begin
      start_station = create_start_station
      end_station = create_end_station
      add_station_in_storage(stations, start_station, end_station)
      create_route_action(start_station, end_station)
    rescue StandardError => e
      puts "Возникла ошибка!!!\n-<<<<<<<\n#{e.message}, попробуйте, пожалуйста, ещё раз\n-<<<<<<<\n"
    end
  end

  def create_start_station
    puts 'Введите название начальной станции'
    create_station_from_user_input
  end

  def create_end_station
    puts 'Введите название конечной станции'
    create_station_from_user_input
  end
end
