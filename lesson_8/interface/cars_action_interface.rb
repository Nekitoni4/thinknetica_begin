# frozen_string_literal: true

class CarsActionInterface
  include RailwayHelpers

  def initialize(train_storage)
    @trains = train_storage
  end

  def self.run!(train_storage)
    new(train_storage).send(:manage_cars_view)
  end

  protected

  attr_accessor :trains, :selected_train

  def manage_cars_view
    if trains.empty?
      puts 'На данный момент в списке поездов - нет, перевожу вас в режим создания поездов!'
      CreateTrainInterface.run!(trains)
      return
    end
    puts 'Вы находитесь в режиме управления вагонами.' \
      'Для корректной работы, пожалуйста, выберите поезд из нижеприведённого списка'
    puts 'Для выхода из данного режима нажмите 0'
    repl_cars
  end

  def repl_cars
    loop do
      show_all_trains(trains)
      current_train_index = gets.to_i - 1
      current_train_index == -1 ? break : select_train(trains, current_train_index)

      manage_action_with_cars
    rescue StandardError => e
      puts "#{e.message}, попробуйте, пожалуйста, ещё раз"
    end
  end

  def manage_action_with_cars
    puts "Выберите действия, которые вы хотите сделать над поездами в контексте вагонов:\n" \
         "1)Прицепить\n" \
         '2)Отцепить'
    repl_manage_cars
  end

  def repl_manage_cars
    loop do
      puts 'Нажмите 0, чтобы выйти из данного контекста:'
      actions_with_cars = {
        1 => method(:add_car_to_selected_train),
        2 => method(:uncoupling_car_to_train)
      }
      action_number = gets.to_i
      action_number.zero? ? break : actions_with_cars[action_number].call
    end
  end

  def add_car_to_selected_train
    add_car_actions_with_train = {
      'passenger' => method(:add_passenger_car_to_train),
      'cargo' => method(:add_cargo_car_to_train)
    }
    add_car_actions_with_train[selected_train.type].call
  end

  def add_cargo_car_to_train
    puts 'Введите, пожалуйста, вместимость вагона, который будет добавлен'
    volume = gets.to_i
    selected_train.add_car(create_cargo_car(volume))
    puts 'Грузовой вагон успешно добавлен!'
  end

  def add_passenger_car_to_train
    puts 'Введите, пожалуйста, количество мест у вагона, который будет добавлен'
    number_of_seats = gets.to_i
    selected_train.add_car(create_passenger_car(number_of_seats))
    puts 'Пассажирский вагон успешно добавлен!'
  end

  def uncoupling_car_to_train
    if !selected_train.cars.empty?
      selected_train.uncoupling_car
      puts 'Вагон успешно отцеплен!'
    else
      puts 'В данный момент этот поезд не имеет вагонов'
    end
  end
end
