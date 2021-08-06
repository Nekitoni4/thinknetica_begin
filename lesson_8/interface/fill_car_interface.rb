# frozen_string_literal: true

class FillCarInterface
  include RailwayHelpers

  def initialize(trains_storage)
    @trains = trains_storage
  end

  def self.run!(trains_storage)
    new(trains_storage).send(:fill_car_view)
  end

  private

  attr_accessor :trains

  def fill_car_view
    if trains.empty?
      puts 'В данный момент созданных поездов нет - перевожу вас в режим создания поездов'
      CreateTrainInterface.run! trains
    else
      puts 'Вы находитесь в режиме заполнения вагонов. Пожалуйста, выберите поезд из нижеперечисленного списка'
      fill_car_repl
    end
  end

  def fill_car_repl
    loop do
      puts 'Введите 0, чтобы выйти из данного режима'
      show_all_trains(trains)
      train_index_number = gets.to_i - 1
      train_index_number == -1 ? break : select_train(trains, train_index_number)

      fill_target_car_interaction(train_index_number)
    end
  end

  def fill_target_car_interaction(train_index_number)
    target_train = trains[train_index_number]
    if target_train.cars.empty?
      puts 'У данного поезда нет прицепленных вагонов, перевожу в режим управления сцепкой/отцепкой'
      CarsActionInterface.run! trains
    else
      puts "Выберите, пожалуйста, порядковый номер того вагона, который хотите заполнить:\n"
      choose_train_number(target_train)
    end
  end

  def choose_train_number(target_train)
    target_train.each_car_index do |*, index|
      puts "#{index + 1})"
    end
    target_index_car = gets.to_i - 1
    fill_target_car_by_index(target_train, target_index_car)
  end

  def fill_target_car_by_index(target_train, target_index_car)
    if target_train.cars[target_index_car]
      target_car = target_train.cars[target_index_car]
      fill_car_by_type = {
        'cargo' => method(:fill_cargo_car),
        'passenger' => method(:fill_passenger_car)
      }
      fill_car_by_type[target_car.type.downcase].call target_car
    else
      puts 'Некорректный порядковый номер вагона'
    end
  end

  def fill_cargo_car(cargo_car)
    puts 'Пожалуйста, введите на какую величину вы хотите заполнить данный поезд?'
    target_volume = gets.to_i
    if (cargo_car.free_volume - target_volume).negative?
      puts 'Ошибка! Вы хотите вместить больше чем сможет принять вагон!'
    else
      cargo_car.fill(target_volume)
      puts 'Готово, вагон заполнен'
    end
  end

  def fill_passenger_car(passenger_car)
    if passenger_car.number_free_seats.zero?
      puts 'Все места в данном вагоне заполнены('
    else
      passenger_car.take_the_seat
      puts 'Готово, место в пассажирском вагоне заполнено'
    end
  end
end
