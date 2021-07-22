class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def get_trains_by_type
    passengers_trains = 0
    freight_trains = 0
    self.trains.each do |train|
      case train.type.downcase
      when "passengers" then passengers_trains += 1
      when "freight" then freight_trains += 1
      end
    puts "Currently at the station there are:\n" +
      "\"Passengers trains\": #{passengers_trains}\n" +
      "\"Freight trains\": #{freight_trains}"
    end
  end

  def train_existing?(train)
    self.trains.find { |existing_train| existing_train.number_name.eql?(train.number_name) }.nil? ? false : true
  end

  def train_departure(train)
    self.trains.delete(train) if train_existing?(train)
  end

  def add_train(train)
    self.trains.push(train) unless train_existing?(train)
  end

  def render_all_trains_at_the_moment
    puts "There are trains at the #{self.name} station:"
    self.trains.each_with_index { |train, index| puts "#{index + 1}.#{train.number_name}\n" } 
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
    get_all_stations.find { |existing_station| existing_station.name.eql?(station.name) }.nil? ? false : true
  end

  def add_intermidate_station(station)
    self.intermidate_stations.push(station) unless station_existing?(station)
  end

  def delete_intermidate_station(station)
    self.intermidate_stations.delete(station) if station_existing?(station)
  end

  def get_all_stations
    self.intermidate_stations[0..-1].unshift(self.starting_station).push(self.end_station)
  end

  def render_all_stations
    puts "All stations along the way: "
    self.get_all_stations.each_with_index { |station, index| puts "#{index + 1}.#{station.name}\n" } 
  end
end


class Train
  attr_reader :route, :number_name, :type
  attr_accessor :current_station, :count_cars, :speed

  def initialize(number_name, type, count_cars, route = nil)
    @number_name = number_name
    @type = type
    @count_cars = count_cars
    @route = route
    @speed = 0
    @current_station = route.starting_station unless route.nil?
    self.current_station.add_train(self) unless self.current_station.nil?
  end

  def acceleration(speed)
    self.speed = speed if speed > self.speed
  end

  def action_with_cars(action = 'add')
    if self.speed == 0
      case action
      when "add" then self.add_car
      when "uncoumpling" then self.uncoupling_car
      else "With cars you can only do add and uncoumpling, not #{action}"
      end
    end
  end

  def add_car
    self.count_cars += 1
  end

  def uncoupling_car
    self.count_cars -= 1
  end

=begin 
  Is it the right solution with controller functions?
  Too lazy to write a check for the existence of a route + the layout of the functions themselves
=end

  def move_controller(move_direction = "backward")
    unless self.current_station.nil?
      case move_direction
      when "backward" then move_backward
      when "forward" then move_forward
      else "Move direction should be backward or forward - not #{move_direction}"
      end
      self.current_station.add_train(self)
    else
      puts "Route is not set"
    end
  end

  def move_backward(action = 'set')
    unless self.current_station == self.route.starting_station
      prev_station = self.route.get_all_stations[self.route.get_all_stations.index(self.current_station) - 1]
      case action
      when 'set' then self.current_station = prev_station
      when 'get' then prev_station
      end
    else
      puts "You are at the starting station"
    end
  end

  def move_forward(action = 'set')
    unless self.current_station == self.route.end_station
      next_station = self.route.get_all_stations[self.route.get_all_stations.index(self.current_station) + 1]
      case action
      when 'set' then self.current_station = next_station
      when 'get' then next_station
      end
    else
      puts "You are at the end station"
    end
  end

  def show_station_controller(state = "previous")
    unless self.current_station.nil?
      case state
      when "previous" then get_previous_station
      when "next" then get_next_station
      else "Passed value should be previous or next - not #{move_direction}"
      end
    else
      "Route is not set"
    end
  end

  def get_previous_station
    move_backward("get")
  end

  def get_next_station
    move_forward("get")
  end

  private :move_backward, :move_forward, :get_previous_station, :get_next_station, :add_car, :uncoupling_car
end
