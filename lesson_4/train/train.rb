class Train
  attr_reader :number_name, :type
  attr_accessor :count_cars, :speed, :current_station, :route, :cars

  def initialize(number_name, type)
    @number_name = number_name
    @type = type
    @cars = []
    @speed = 0
  end

  def set_train_on_the_way(route)
    set_route(route)
    set_current_station(route.starting_station)
    set_train_on_the_current_station
  end
  
  def acceleration(speed)
    self.speed = speed if speed > self.speed
  end

  def braking
    self.speed = 0
  end

  def add_car(car)
    self.cars.push(car)
  end

  def uncoupling_car
    self.cars.pop
  end

  def previous_station
    self.all_stations_in_this_route[current_station_position - 1] unless start_station?
  end

  def next_station
    self.all_stations_in_this_route[current_station_position + 1] unless end_station?
  end

  def move_backward
    if previous_station
    self.current_station = previous_station
    self.current_station.add_train(self)
    end
  end

  def move_forward
    if next_station
    self.current_station = next_station
    self.current_station.add_train(self)
    end
  end

  def start_station?
    current_station_position == 0
  end

  def end_station?
    current_station_position == all_stations_in_this_route.length - 1
  end
  
  private

=begin
  Добавил вспомогательные + инициализирующие методы
=end

    def all_stations_in_this_route
      self.route.all_stations
    end

    def current_station_position
      all_stations_in_this_route.index(self.current_station)
    end

    def set_route(route)
        @route = route
    end

    def set_current_station(station)
      @current_station = station
    end

    def set_train_on_the_current_station
      self.current_station.add_train(self)
    end
end

