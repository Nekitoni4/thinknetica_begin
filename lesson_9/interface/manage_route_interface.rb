# frozen_string_literal: true

class ManageRouteInterface
  include RailwayHelpers

  def initialize(routes_storage, stations_storage)
    @routes = routes_storage
    @stations = stations_storage
  end

  def self.run!(routes_storage, stations_storage)
    new(routes_storage, stations_storage).send(:manage_routes_view)
  end

  protected

  attr_accessor :routes, :stations, :selected_route

  def manage_routes_view
    if routes.empty?
      puts 'К сожалению в списке нет не одного маршрута, перевожу вас в режим создания маршрута'
      CreateRouteInterface.run! routes, stations
    else
      puts "Вы находитесь в режиме управления станциями в текущем маршруте.\n" \
           'Для работы в нём, пожалуйста, выберите из приведённого списка маршрут, которым вы хотите управлять'
      manage_routes_repl
    end
  end

  def manage_routes_repl
    loop do
      puts 'Введите 0, чтобы выйти из данного режима'
      show_all_routes(routes)
      current_route_number = gets.to_i - 1
      current_route_number == -1 ? break : manage_routes_action(current_route_number)
    end
  end

  def manage_routes_action(current_route_number)
    if route_existing_in_storage? routes, current_route_number
      select_route routes, current_route_number
      action_with_route_repl
    else
      puts 'Некорректный индекс, пожалуйста, повторите ещё раз!'
    end
  end

  def action_with_route_repl
    loop do
      puts "Выберите, пожалуйста, действие, которое вы хотите выполнить над выбранным маршрутом:\n" \
           "1)Добавить в него станцию\n 2)Удалить из него станцию\n 3)Выйти"
      actions_with_stations = {
        1 => method(:add_station_in_route),
        2 => method(:delete_station_in_route)
      }
      action_number = gets.to_i
      action_number == 3 ? break : actions_with_stations[action_number].call
    end
  end

  def add_station_in_route
    if stations.length > 1
      puts 'Пожалуйста, выберите станцию, которую вы хотите добавить из текущего списка'
      show_all_stations stations
      target_station_number = gets.to_i - 1
      add_station_with_number target_station_number
    else
      puts 'К сожалению на данный момент в списке нет доступных станций, перевожу вас в режим создания станций'
      CreateStationInterface.run! stations
    end
  end

  def add_station_with_number(station_number)
    if station_existing_in_storage? stations, station_number
      selected_route.add_intermediate_station(stations[station_number])
      puts 'Станция успешно добавлена!'
    else
      puts 'Введён некорректный порядковый номер'
    end
  end

  def delete_station_in_route
    if selected_route.intermediate_stations.empty?
      puts 'Выберите из списка ту станцию, которую хотите убрать и введите её номер: '
      show_all_stations(selected_route.intermediate_stations)
      target_station_number = gets.to_i
      delete_station_with_number target_station_number
    else
      puts 'В текущем маршруте нет станций, которые можно было бы убрать'
    end
  end

  def delete_station_with_number(station_number)
    if route_existing_in_storage? routes, station_number
      selected_route.intermediate_stations.delete_at(station_number)
      puts 'Станция успешно удалена!'
    else
      puts 'Введён некорректный номер станции!'
    end
  end
end
