# frozen_string_literal: true

class CreateTrainInterface
  include RailwayHelpers

  def initialize(trains_storage)
    @trains = trains_storage
  end

  def self.run!(trains_storage)
    new(trains_storage).send(:create_train_view)
  end

  protected

  attr_accessor :trains

  def create_train_view
    puts "Вы в режиме создания поездов! Пожалуйста, придумайте и введите идентификатор поезда.\n" \
         'Также, пожалуйста, выберите тип поезда и нажмите на цифру, которая соответствует порядковому номеру:'
    loop do
      puts 'Введите, пожалуйста, имя создаваемого поезда или введите return, чтобы выйти'
      train_name = gets.chomp
      break if train_name.eql? 'return'

      create_train train_name
    end
  end

  def create_train(train_name)
    puts "Введите, пожалуйста, порядковый номер, который приведён ниже:\n" \
      "1)Пассажирский\n" \
      "2)Грузовой\n"
    begin
      action_with_train = { 1 => method(:add_passenger_train), 2 => method(:add_cargo_train) }
      train_type = gets.to_i
      action_with_train[train_type].call(train_name)
    rescue StandardError => e
      puts "Произошла ошибка: #{e.message} - попробуйте ещё раз"
    end
  end

  def add_passenger_train(train_name)
    add_train_in_storage(trains, create_passenger_train(train_name))
    puts 'Пассажирский поезд успешно добавлен!'
  rescue StandardError => e
    puts "#{e.message}, пожалуйста, попробуйте, ещё раз"
  end

  def add_cargo_train(train_name)
    add_train_in_storage(trains, create_cargo_train(train_name))
    puts 'Грузовой поезд успешно добавлен!'
    puts trains
  rescue StandardError => e
    puts "#{e.message}, пожалуйста, попробуйте, ещё раз"
  end
end
