class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def trains_by_type(type)
    self.trains.find_all { |train| train.type == type }
  end

  def count_trains_by_type(type)
    trains_by_type(type).length
  end

  def train_existing?(train)
    self.trains.include?(train)
  end

  def train_departure(train)
    self.trains.delete(train) if train_existing?(train)
  end

  def add_train(train)
    self.trains.push(train) unless train_existing?(train)
  end
end


class Route
  attr_reader :starting_station, :end_station, :intermidate_stations

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermidate_stations = []
  end

  def station_existing?(station)
    all_stations.include?(station)
  end

  def add_intermidate_station(station)
    self.intermidate_stations.push(station) unless station_existing?(station)
  end

  def delete_intermidate_station(station)
    self.intermidate_stations.delete(station) if station_existing?(station)
  end

  def all_stations
    [self.starting_station, *self.intermidate_stations, self.end_station]
  end
end


class Train
  attr_reader :number_name, :type
  attr_accessor :count_cars, :speed, :current_station, :route

  def initialize(number_name, type, count_cars)
    @number_name = number_name
    @type = type
    @count_cars = count_cars
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

  def add_car
    self.count_cars += 1 if self.speed == 0
  end

  def uncoupling_car
    self.count_cars -= 1 if self.speed == 0
  end

  def all_stations_in_this_route
    self.route.all_stations
  end

  def current_station_position
    all_stations_in_this_route.index(self.current_station)
  end

  def previous_station
    self.all_stations_in_this_route[current_station_position - 1] unless current_station_position == 0
  end

  def next_station
    self.all_stations_in_this_route[current_station_position + 1] if current_station_position != all_stations_in_this_route.length - 1
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

  private 

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
