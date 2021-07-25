class Route
  attr_reader :starting_station, :end_station, :intermidate_stations

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermidate_stations = []
  end

  def add_intermidate_station(station)
    self.intermidate_stations.push(station) unless station_existing?(station) && station.kind_of(Station)
  end

  def delete_intermidate_station(station)
    self.intermidate_stations.delete(station) if station_existing?(station) && station.kind_of(Station)
  end

  def all_stations
    [self.starting_station, *self.intermidate_stations, self.end_station]
  end

  def station_existing?(station)
    all_stations.include?(station)
  end

=begin
  Думаю, что в данном случае вышеуказанные методы не нужно помещать в protected/private блок,
  так как пока у нас нет какой-то супер пупер логики, которую нужно скрывать,
  а изменчивость данных из клиентского кода контролирует attr_reader и соответствующе методы
=end
end