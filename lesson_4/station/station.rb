class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def count_trains_by_type(type)
    trains_by_type(type).length
  end

  def train_existing?(train)
    self.trains.include?(train) && train.kind_of(Train)
  end

  def train_departure(train)
    self.trains.delete(train) if train_existing?(train) && train.kind_of?(Train)
  end

  def add_train(train)
    self.trains.push(train) unless train_existing?(train) && train.kind_of?(Train)
  end

  def show_all_trains
    self.trains.each_with_index { |train, index| puts "#{index + 1}) #{train.number_name}" }
  end

=begin

Думаю тут тоже не нужно добавлять методы/данные в блоки модификаторов, так как нет нужды пока скрывать определённые данные +

они защищены методами чтения и добавлять/удалять что-то из них мы можем только через соответствующие методы

=end
  
end