# frozen_string_literal: true

class TextInterface
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def self.run!
    new.send(:main_user_view)
  end

  private

  attr_accessor :stations, :trains, :routes

  def main_user_view
    puts 'Добро пожаловать в приложению по управлению поездами, вагонами, станциями, а также маршрутами!'
    loop do
      puts "Нажмите на цифры, соответствующие следующим действиям:\n0)Выйти\n1)Перейти в режим создания станций\n"\
           "2) Перейти в режим создания поездов\n3)Перейти в режим создания маршрутов\n" \
           "4)Перейти в режим управления маршрутами\n5)Перейти в режим назначения марщрута для поезда\n"\
           "6)Перейти в режим сцепки/отцепки вагона для поезда\n7)Перейти в режим управления движением поезда\n"\
            "8)Перейти в режим просмотра станций/поездов на станции\n9)Перейти в режим заполнения вагона"
      user_action = gets.to_i
      user_action.zero? ? break : main_action(user_action)
    end
  end

  def main_action(user_action)
    actions = {
      1 => -> { CreateStationInterface.run!(stations) }, 2 => -> { CreateTrainInterface.run!(trains) },
      3 => -> { CreateRouteInterface.run!(routes, stations) },
      4 => -> { ManageRouteInterface.run!(routes, stations) },
      5 => -> { SetRouteInterface.run!(trains, routes) },
      6 => -> { CarsActionInterface.run!(trains) }, 7 => -> { ManageRouteInterface.run!(routes, stations) },
      8 => -> { ShowStationsInterface.run!(stations) }, 9 => -> { FillCarInterface.run!(trains) }

    }
    actions[user_action] ? actions[user_action].call : puts('Некорректный индекс')
  end
end
