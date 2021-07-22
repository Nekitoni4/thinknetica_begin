class Station
  attr_reader :name, :trains_at_the_moment

  def initialize(name)
    @name = name
    @trains_at_the_moment = []
  end

  def trains_by_type(type)
    self.trains.find_all { |train| train.type == type}
  end

  def count_trains_by_type(type)
    trains_by_type(type).length
  end

  def train_existing?(train)
    self.trains_at_the_moment.find { |existing_train| existing_train.object_id == train.object_id }.nil? ? false : true
  end

  def train_departure(train)
    self.trains_at_the_moment.delete(train) if train_existing?(train)
  end

  def add_train(train)
    self.trains_at_the_moment.push(train) unless train_existing?(train)
  end

  # We have a trains_at_the_moment getter so we don't need a separate method for showing trains at the moment.
end


class Route
  attr_reader :starting_station, :end_station, :intermidate_stations

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermidate_stations = []
  end

  def station_existing?(station)
    get_all_stations.find { |existing_station| existing_station.object_id == station.object_id }.nil? ? false : true
  end

  def add_intermidate_station(station)
    self.intermidate_stations.push(station) unless station_existing?(station)
  end

  def delete_intermidate_station(station)
    self.intermidate_stations.delete(station) if station_existing?(station)
  end

  def get_all_stations
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

  def set_route(route)
    @route = route
  end

  def set_current_station(station)
    @current_station = station
  end

  def set_train_on_the_current_station
    self.current_station.add_train(self)
  end
  
  def acceleration(speed)
    self.speed = speed if speed > self.speed
  end

  def braking
    self.speed = 0
  end

  def add_car
    if self.speed == 0
      self.count_cars += 1
    end
  end

  def uncoupling_car
    if self.speed == 0
      self.count_cars -= 1
    end
  end

  def get_current_station_position
    get_all_stations.index(self.current_station)
  end

  def get_all_stations_in_this_route
    self.route.get_all_stations
  end

  def get_closest_stations
    { prev_station: self.get_all_stations_in_this_route[get_current_station_position - 1], 
    next_station: self.get_all_stations_in_this_route[get_current_station_position + 1] }
  end

  def move_backward
    if get_current_station_position != 0
      self.current_station = get_closest_stations[:prev_station]
      self.current_station.add_train(self)
    end
  end

  def move_forward
    if get_current_station_position != get_all_stations_in_this_route.length - 1
      self.current_station = get_closest_stations[:next_station]
      self.current_station.add_train(self)
    end
  end

  def get_previous_station
    if get_current_station_position != 0
      get_closest_stations[:prev_station]
    end
  end

  def get_next_station
    if get_current_station_position != get_all_stations_in_this_route.length - 1
      get_closest_stations[:next_station]
    end
  end

  private :set_route, :set_current_station, :set_train_on_the_current_station
end
