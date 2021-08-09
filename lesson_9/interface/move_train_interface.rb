# frozen_string_literal: true

class MoveTrainInterface
  include RailwayHelpers

  def initialize(trains_storage, routes_storage)
    @trains = trains_storage
    @routes = routes_storage
  end

  def self.run!(trains_storage, routes_storage)
    new(trains_storage, routes_storage).send(:move_train_view)
  end

  private

  attr_accessor :trains, :routes, :selected_train

  def move_train_view
    if trains.empty?
      puts 'На данный момент в списке поездов - нет, пожалуйста, добавьте хотя бы один и возвращайтесь! ;)'
      CreateTrainInterface.run! trains
    else
      puts 'Вы находитесь в режиме управления вагонами.' \
           'Для корректной работы, пожалуйста, выберите поезд из нижеприведённого списка'
      move_train_repl
    end
  end

  def move_train_repl
    loop do
      puts 'Для выхода из данного режима нажмите 0'
      show_all_trains trains
      current_train_index = gets.to_i - 1
      current_train_index == -1 ? break : select_train(trains, current_train_index)

      manage_move_selected_train
    end
  end

  def manage_move_selected_train
    if selected_train.route.nil?
      puts 'Для данного поезда не задан маршрут, перевожу вас в режим установки маршрута для поезда'
      SetRouteInterface.run! trains, routes
    else
      puts "Пожалуйста, выберите направление движения из нижприведённого списка:\n" \
           "1)Вперёд\n" \
           '2)Назад'
      manage_move_repl
    end
  end

  def manage_move_repl
    loop do
      puts 'Введите 0, чтобы выйти из данного режима'
      action_number = gets.to_i
      action_number.zero? ? break : manage_move(action_number)
    end
  end

  def manage_move(action_number)
    move_actions = {
      1 => method(:move_forward_train),
      2 => method(:move_backward_train)
    }
    move_actions[action_number].call
  end

  def move_backward_train
    if selected_train.start_station?
      puts 'Вы на начальной станции, двигаться можно только вперёд ;) '
    else
      selected_train.move_backward
      puts 'Поезд успешно вернулся назад на 1 станцию!'
    end
  end

  def move_forward_train
    if selected_train.end_station?
      puts 'Вы уже на конечной станции, двигаться можно только назад ;)'
    else
      selected_train.move_forward
      puts 'Поезд успешно продвинулся вперёд на 1 станцию'
    end
  end
end
