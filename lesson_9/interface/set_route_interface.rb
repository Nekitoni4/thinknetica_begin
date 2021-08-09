# frozen_string_literal: true

class SetRouteInterface
  include RailwayHelpers

  def initialize(trains_storage, routes_storage)
    @trains = trains_storage
    @routes = routes_storage
  end

  def self.run!(trains_storage, routes_storage)
    new(trains_storage, routes_storage).send(:set_route_to_train_view)
  end

  private

  attr_accessor :trains, :routes, :selected_train

  def set_route_to_train_view
    if trains.empty?
      puts 'На данный момент в хранилище поездов - пусто, перевожу вас в режим создания поездов!'
      CreateTrainInterface.run! trains
    else
      puts 'Вы находитесь в режиме установки маршрута поезду.' \
           'Для корректной работы, пожалуйста, выберите поезд из нижеприведённого списка'
      set_route_to_train_repl
    end
  end

  def set_route_to_train_repl
    loop do
      puts 'Для выхода из данного режима нажмите 0'
      show_all_trains trains
      current_train_index = gets.to_i - 1
      current_train_index == -1 ? break : select_train(trains, current_train_index)

      set_route_to_selected_train
    end
  end

  def set_route_to_selected_train
    if !routes.empty?
      puts 'Выберите, пожалуйста, нужный маршрут из списка предложенных'
      show_all_routes routes
      selected_route_index = gets.to_i - 1
      select_route_to_train selected_route_index
    else
      puts 'В данный момент доступных маршрутов нет, пожалуйста, создайте новый'
    end
  end

  def select_route_to_train(selected_route_index)
    if route_existing_in_storage? routes, selected_route_index
      selected_train.train_on_the_way(routes[selected_route_index])
      puts 'Маршрут установлен!'
    else
      puts 'Некорректный номер'
    end
  end
end
