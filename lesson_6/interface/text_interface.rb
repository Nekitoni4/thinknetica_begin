class TextInterface

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @selected_train = nil
    @selected_route = nil
  end

  def run
    main_user_interaction
  end


  private

  attr_accessor :stations, :trains, :routes, :selected_route, :selected_train

  def main_user_interaction
    puts "Добро пожаловать в приложению по управлению поездами, вагонами, станциями, а также маршрутами!"
    loop do
      puts "Нажмите на цифры, соответствующие следующим действиям:\n" +
      "0)Выйти\n" +
      "1)Перейти в режим создания станций\n" +
      "2)Перейти в режим создания поездов\n" +
      "3)Перейти в режим создания маршрутов\n" +
      "4)Перейти в режим управления маршрутами\n" +
      "5)Перейти в режим назначения марщрута для поезда\n" +
      "6)Перейти в режим сцепки/отцепки вагона для поезда\n" +
      "7)Перейти в режим управления движением поезда\n" +
      "8)Перейти в режим просмотра станций/поездов на станции"
      user_action = gets.to_i
        case user_action
        when 0 then break
        when 1 then create_station_interaction
        when 2 then create_train_interaction
        when 3 then create_route_interaction
        when 4 then manage_routes_interaction
        when 5 then set_route_to_train_interaction
        when 6 then manage_cars_in_train_interaction
        when 7 then move_train_interaction
        when 8 then show_stations_and_trains_interaction
        end
    end
  end

  def create_station_interaction
    puts "Вы в режиме создания станций!"
    loop do
      puts "Пожалуйста, введите имя создаваемой станции или введите слово return, чтобы вернутся назад"
      station = create_station_from_user_input
      break if station.name == "return"
      add_station_in_storage(station)
      puts "Станция, успешно создана!"
    end
  end

  def create_train_interaction
    puts "Вы в режиме создания поездов! Пожалуйста, придумайте и введите идентификатор поезда.\n" +
      "Также, пожалуйста, выберите тип поезда и нажмите на цифру, которая соответствует порядковому номеру:"
    loop do
      puts "Введите, пожалуйста, имя создаваемого поезда или введите return, чтобы выйти"
      train_name = gets.chomp
      break if train_name == "return"
      puts "Введите, пожалуйста, порядковый номер, который приведён ниже:\n" +
      "1)Пассажирский\n" + 
      "2)Грузовой"
      train_type = gets.to_i
      case train_type
        when 1 then create_passenger_train(train_name)
        when 2 then create_cargo_train(train_name)
      end
    end
  end

  def create_passenger_train(train_name)
    add_train_in_storage(create_passenger_train_instance(train_name))
    puts "Пассажирский поезд успешно добавлен!"
    rescue => e
    puts "#{e.message}, пожалуйста, попробуйте, ещё раз"
  end

  def create_cargo_train(train_name)
    add_train_in_storage(create_cargo_train_instance(train_name))
    puts "Грузовой поезд успешно добавлен!"
    rescue => e
    puts "#{e.message}, пожалуйста, попробуйте, ещё раз"
  end

  def create_route_interaction
    puts "Вы находитесь в режиме создания маршрутов! Для того, чтобы создать маршрут необходимо задать начальную и конечную станции. "
    loop do
      puts "Выбрите порядковый номер, предложенного действия: \n" +
      "1) Выбрать станции из существующих\n" +
      "2) Создать новые станции\n" +
      "3) Выйти"
      action_number = gets.to_i
      break if action_number == 3
      case action_number
      when 1 then choose_start_and_end_station_from_storage_interaction
      when 2 then create_start_and_end_station_interaction
      end
    end
  end

  def choose_start_and_end_station_from_storage_interaction
    if self.stations.length > 1
      puts "Выберите из предложенного списка станций - необходимую и выберите порядковый номер: "
      show_all_stations
      puts "Выберите начальную станцию"
      start_station = self.stations[gets.to_i - 1]
      puts "Выберите конечную станцию"
      end_station = self.stations[gets.to_i - 1]
      if start_station.nil? || end_station.nil?
        puts "Вы ввели некорректный номер, введите заново!"
      else 
        add_route_in_storage(create_route_instance(start_station, end_station))
        puts "Маршрут успешно создан!"
      end
    else 
      puts "На данный момент мало станций, чтобы выбрать из них начальную и конечную станции, перевожу вас в режим создания станций"
      create_station_interaction
    end
  end

  def create_start_and_end_station_interaction
    puts "Пожалуйста, выберите название для начальной станции"
    start_station = create_station_from_user_input
    puts "Пожалуйста, выберите название для конечной станции"
    end_station = create_station_from_user_input
    add_station_in_storage(start_station)
    add_station_in_storage(end_station)
    add_route_in_storage(create_route_instance(start_station, end_station))
    puts "Маршрут успешно создан!"
  end

  def manage_routes_interaction
    unless self.routes.empty?
      puts "Вы находитесь в режиме управления станциями в текущем маршруте.\n" + 
      "Для работы в нём, пожалуйста, выберите из приведённого списка маршрут, которым вы хотите управлять"
      loop do
        puts "Введите 0, чтобы выйти из данного режима"
        show_all_routes
        current_route_number = gets.to_i - 1
        break if current_route_number == -1
        if route_existing_in_storage?(current_route_number)
          self.selected_route = self.routes[current_route_number]
          action_with_station_in_route_interaction
        else
          puts "Некорректный индекс, пожалуйста, повторите ещё раз!"
        end
      end
    else 
      puts "К сожалению в списке нет не одного маршрута, перевожу вас в режим создания маршрута"
      create_route_interaction
    end
  end


  def action_with_station_in_route_interaction
    loop do
      puts "Выберите, пожалуйста, действие, которое вы хотите выполнить над выбранным маршрутом:\n" +
      "1)Добавить в него станцию\n" +
      "2)Удалить из него станцию\n" +
      "3)Выйти"
      action_number = gets.to_i
      break if action_number == 3
      case action_number
      when 1 then add_station_in_current_route_interaction
      when 2 then delete_station_in_current_route_interaction
      end
    end
  end

  def add_station_in_current_route_interaction
    if self.stations.length > 1
      puts "Пожалуйста, выберите станцию, которую вы хотите добавить из текущего списка"
      show_all_stations
      current_station_number = gets.to_i - 1
      if station_existing_in_storage?(current_station_number)
        self.selected_route.add_intermidate_station(self.stations[current_station_number])
        puts "Станция успешно добавлена!"
      else
        puts "Введён некорректный порядковый номер"
      end
    else
      puts "К сожалению на данный момент в списке нет доступных станций, перевожу вас в режим создания станций"
      create_station_interaction
    end
  end

  def delete_station_in_current_route_interaction
    if self.selected_route.intermidate_stations.empty?
      puts "Выберите из списка ту станцию, которую хотите убрать и введите её номер: "
      show_all_stations(self.selected_route.intermidate_stations)
      delete_station_number = gets.to_i
      if deleting_station_in_current_route_existing?(delete_station_number)
        self.selected_route.intermidate_stations.delete_at(delete_station_number)
        puts "Станция успешно удалена!"
      else
        puts "Введён некорректный номер станции!"
      end
    else
      puts "В текущем маршруте нет станций, которые можно было бы убрать"
    end
  end

  def set_route_to_train_interaction
    unless self.trains.empty?
      puts "Вы находитесь в режиме установки маршрута поезду." +
      "Для корректной работы, пожалуйста, выберите поезд из нижеприведённого списка"
      loop do
        puts "Для выхода из данного режима нажмите 0"
        show_all_trains
        current_train_index = gets.to_i - 1
        break if current_train_index == -1
        if train_existing_in_storage?(current_train_index)
          self.selected_train = self.trains[current_train_index]
          puts "Поезд успешно выбран!"
          set_route_to_selected_train_interaction
        else
          puts "Некорректный индекс, попробуйте, пожалуйста, ещё раз"
        end
      end
    else
      puts "На данный момент в списке поездов - нет, перевожу вас в режим создания поездов!"
      create_train_interaction
    end
  end

  def set_route_to_selected_train_interaction
    if self.routes.length > 1
      puts "Выберите, пожалуйста, нужный маршрут из списка предложенных"
      show_all_routes
      selected_route_index = gets.to_i - 1
      if route_existing_in_storage?(selected_route_index)
        self.selected_train.train_on_the_way(self.routes[selected_route_index])
        puts "Маршрут установлен!"
      else
        puts "Некорректный номер"
      end
    else
      puts "В данный момент доступных маршрутов нет, пожалуйста, создайте новый"
      create_route_interaction
    end
  end

  def manage_cars_in_train_interaction
    unless self.trains.empty?
      puts "Вы находитесь в режиме управления вагонами." +
      "Для корректной работы, пожалуйста, выберите поезд из нижеприведённого списка"
      loop do
        puts "Для выхода из данного режима нажмите 0"
        show_all_trains
        current_train_index = gets.to_i - 1
        break if current_train_index == -1
        if train_existing_in_storage?(current_train_index)
          self.selected_train = self.trains[current_train_index]
          puts "Поезд успешно выбран!"
          manage_action_with_cars_to_selected_train_interaction
        else
          puts "Некорректный индекс, попробуйте, пожалуйста, ещё раз"
        end
      end
    else
      puts "На данный момент в списке поездов - нет, пожалуйста, добавьте хотя бы один и возвращайтесь! ;)"
      create_train_interaction
    end
  end

  def manage_action_with_cars_to_selected_train_interaction
    puts "Выберите действия, которые вы хотите сделать над поездов в контексте вагонов:\n" + 
    "1)Прицепить\n" +
    "2)Отцепить"
    loop do
      puts "Нажмите 0, чтобы выйти из данного контекста:"
      action_number = gets.to_i
      break if action_number == 0
      case action_number
      when 1 then add_car_to_selected_train_interaction
      when 2 then uncopuling_car_to_selected_train_interaction
      end 
    end
  end

  def add_car_to_selected_train_interaction
    case self.selected_train.type
    when "passenger" then add_passenger_car_to_passenger_train
    when "cargo" then add_cargo_car_to_cargo_train
    end
  end

  def add_cargo_car_to_cargo_train
    self.selected_train.add_car(create_cargo_car_instance)
    puts "Грузовой вагон успешно добавлен!"
  end

  def add_passenger_car_to_passenger_train
    self.selected_train.add_car(passenger_car_instance)
    puts "Пассажирский вагон успешно добавлен!"
  end

  def uncopuling_car_to_selected_train_interaction
    if self.selected_train.cars.length >= 1
      self.selected_train.uncoupling_car
      puts "Вагон успешно отцеплен!"
    else
      puts "В данный момент этот поезд не имеет вагонов"
    end
  end

  def move_train_interaction
    unless self.trains.empty?
      puts "Вы находитесь в режиме управления вагонами." +
      "Для корректной работы, пожалуйста, выберите поезд из нижеприведённого списка"
      loop do
        puts "Для выхода из данного режима нажмите 0"
        show_all_trains
        current_train_index = gets.to_i - 1
        break if current_train_index == -1
        if train_existing_in_storage?(current_train_index)
          self.selected_train = self.trains[current_train_index]
          puts "Поезд успешно выбран!"
          manage_move_selected_train_interaction
        else
          puts "Некорректный индекс, попробуйте, пожалуйста, ещё раз"
        end
      end
    else
      puts "На данный момент в списке поездов - нет, пожалуйста, добавьте хотя бы один и возвращайтесь! ;)"
      create_train_interaction
    end
  end

  def manage_move_selected_train_interaction
    unless self.selected_train.route.nil?
      puts "Пожалуйста, выберите направление движения из нижприведённого списка:\n" +
      "1)Вперёд\n" +
      "2)Назад"
      loop do
        puts "Введите 0, чтобы выйти из данного режима"
        action_number = gets.to_i
        break if action_number == 0
        case action_number
        when 1 then move_forward_selected_train
        when 2 then move_backward_selected_train
        end
      end 
    else
      puts "Для данного поезда не задан маршрут, перевожу вас в режим установки маршрута для поезда"
      set_route_to_train_interaction
    end
  end

  def move_backward_selected_train
    unless self.selected_train.start_station?
      self.selected_train.move_backward
      puts "Поезд успешно вернулся назад на 1 станцию!"
    else
      puts "Вы на начальной станции, двигаться можно только вперёд ;) "
    end
  end

  def move_forward_selected_train
    unless self.selected_train.end_station?
      self.selected_train.move_forward
      puts "Поезд успешно продвинулся вперёд на 1 станцию"
    else 
      puts "Вы уже на конечной станции, двигаться можно только назад ;)"
    end
  end

  def show_stations_and_trains_interaction
    if self.stations.length > 1
      puts "Вы в режиме просмотра списка станций. Пожалуйста, выберите, что вы хотите сделать?\n" +
      "1) Посмотреть список станций\n" +
      "2) Посмотреть список поездов на конкретной станции"
      loop do
        puts "Чтобы выйти из этого режима, нажмите 0"
        action_number = gets.to_i
        break if action_number == 0
        case action_number
        when 1 then show_all_stations 
        when 2 then show_all_trains_in_selected_station
        end
      end
    else
      puts "В данный момент станций нет. Создайте новую, пожалуйста ;) "
      create_station_interaction
    end
  end

  def show_all_trains_in_selected_station
    puts "Пожалуйста, выберите конкретную станцию для дальнейшего просмотра на ней всех поездов"
    loop do
      puts "Введите 0, чтобы выйти из данного режима"
      show_all_stations
      station_index_number = gets.to_i - 1
      break if station_index_number == -1
      if station_existing_in_storage?(station_index_number)
        self.stations[station_index_number].show_all_trains
      else 
        puts "Некорректный номер"
      end
    end
  end

  def create_station_from_user_input
    name_station = gets.chomp
    create_station_instance(name_station)
  end

  def show_all_stations(stations = self.stations)
    stations.each_with_index { |station, index| puts "#{index + 1})#{station.name}" }
  end

  def show_all_trains
    self.trains.each_with_index { |train, index| puts "#{index + 1})#{train.number_name}" }
  end

  def show_all_routes
    self.routes.each_with_index { |route, index| puts "#{index + 1})#{route.starting_station.name}-#{route.end_station.name}" }
  end

  def station_existing_in_storage?(index)
    !self.stations[index].nil?
  end

  def route_existing_in_storage?(index)
    !self.routes[index].nil?
  end

  def deleting_station_in_current_route_existing?(index)
    !self.routes[index].nil?
  end

  def train_existing_in_storage?(index)
    !self.trains[index].nil?
  end

  def add_route_in_storage(route)
    self.routes.push(route)
  end

  def add_train_in_storage(train)
    self.trains.push(train)
  end

  def add_station_in_storage(station)
    self.stations.push(station)
  end

  def create_station_instance(name)
    Station.new(name)
  end

  def create_cargo_train_instance(name)
    CargoTrain.new(name)
  end

  def create_passenger_train_instance(name)
    PassengerTrain.new(name)
  end

  def create_route_instance(starting_station, end_station)
    Route.new(starting_station, end_station)
  end

  def create_cargo_car_instance
    CargoCar.new
  end

  def passenger_car_instance
    PassengerCar.new
  end
end