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
      "8)Перейти в режим просмотра станций/поездов на станции\n" +
      "9)Перейти в режим заполнения вагона"
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
        when 9 then fill_car_interaction
        end
    end
  end

  def create_station_interaction
    puts "Вы в режиме создания станций!"
    loop do
      begin
        puts "Хотите ли выйти из данного режима?"
        exit_action = gets.chomp
        break if exit_action.downcase == 'да'
        puts "Пожалуйста, введите имя (больше 10 символов) создаваемой станции\n"
        station = create_station_from_user_input
        add_station_in_storage(station)
        puts "Станция, успешно создана!"
      rescue => e
        puts "Произошла ошибка: #{e.message}!!!\n__________"
      end
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
    puts "Введите, пожалуйста, вместимость вагона, который будет добавлен"
    volume = gets.to_i
    self.selected_train.add_car(create_cargo_car_instance(volume))
    puts "Грузовой вагон успешно добавлен!"
  end

  def add_passenger_car_to_passenger_train
    puts "Введите, пожалуйста, количество мест у вагона, который будет добавлен"
    number_of_seats = gets.to_i
    self.selected_train.add_car(passenger_car_instance(number_of_seats))
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
    if self.stations.length >= 1
      puts "Вы в режиме просмотра списка станций. Пожалуйста, выберите, что вы хотите сделать?\n" +
      "1) Посмотреть список станций\n" +
      "2) Посмотреть список поездов на конкретной станции\n" +
      "3) Посмотреть всю информацию обо всех поездах на станциях\n"
      loop do
        puts "Чтобы выйти из этого режима, нажмите 0"
        action_number = gets.to_i
        break if action_number == 0
        case action_number
        when 1 then show_all_stations 
        when 2 then show_all_trains_in_selected_station
        when 3 then show_all_train_and_cargo_in_all_stations
        end
      end
    else
      puts "В данный момент станций нет. Создайте новую, пожалуйста ;) "
      create_station_interaction
    end
  end

  def show_all_train_and_cargo_in_all_stations
    self.stations.each { |station| show_all_info_about_train_in_station(station) }
  end

  def show_all_info_about_train_in_station(station)
    unless station.trains.empty?
      station.each_train do |train|
        puts "Номер поезда: #{train.number_name}\n Тип: #{train.type}\n Кол-во вагонов: #{train.number_cars}.\n"
        show_all_cars_in_train(train)
      end
    else
      puts "Пока на станции #{station.name} нет поездов"
    end
  end

  def show_all_cars_in_train(train)
    unless train.cars.empty?
      train.each_car_index do |car, index|
        puts "Номер вагона: #{index + 1}\n"
        case car.type
        when 'passenger' then show_info_for_passenger_car(car)
        when 'cargo' then show_info_for_cargo_car(car)
        end
      end
    else
      puts "Данный поезд не имеет вагонов"
    end
  end

  def show_info_for_passenger_car(passenger_car)
    puts "Тип вагона: пассажирский\nКол-во свободных мест: #{passenger_car.number_free_seats}\nКол-во занятых мест: #{passenger_car.number_of_occupied_seats}\n____________"
  end

  def show_info_for_cargo_car(cargo_car)
    puts "Тип вагона: грузовой\nКол-во свободного объёма: #{cargo_car.free_volume}\nКол-во занятого объёма: #{cargo_car.filled_volume}\n______________"
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

  def fill_car_interaction
    unless self.trains.empty?
      puts "Вы находитесь в режиме заполнения вагонов. Пожалуйста, выберите поезд из нижеперечисленного списка"
      loop do
        puts "Введите 0, чтобы выйти из данного режима"
        show_all_trains
        train_index_number = gets.to_i - 1
        break if train_index_number == -1
        if train_existing_in_storage?(train_index_number)
          fill_target_car_interaction(train_index_number)
        else
          puts "Некорректный номер"
        end
      end
    else
      puts "В данный момент созданных поездов нет - перевожу вас в режим создания поездов"
      create_train_interaction
    end
  end

  def fill_target_car_interaction(train_index_number)
    target_train = self.trains[train_index_number]
    unless target_train.cars.empty?
      puts "Выберите, пожалуйста, порядковый номер и тип того вагона, который хотите заполнить:\n"
      target_train.each_car_index do |car, index|
        puts "#{index + 1})"
      end
      target_index_car = gets.to_i - 1
      if target_train.cars[target_index_car]
        target_car = target_train.cars[target_index_car]
        case target_car.type.downcase
        when 'cargo' then fill_cargo_car(target_car)
        when 'passenger' then fill_passenger_car(target_car)
        end
      else
        puts "Некорректный порядковый номер вагона"
      end
    else
      puts "У данного поезда нет прицепленных вагонов, перевожу в режим управления сцепкой/отцепкой"
      manage_cars_in_train_interaction
    end
  end

  def fill_cargo_car(cargo_car)
    puts "Пожалуйста, введите на какую величину вы хотите заполнить данный поезд?"
    target_volume = gets.to_i
    unless cargo_car.free_volume - target_volume < 0
      cargo_car.fill(target_volume)
      puts "Готово, вагон заполнен"
    else
      puts "Ошибка! Вы хотите вместить больше чем сможет принять вагон!"
    end
  end

  def fill_passenger_car(passenger_car)
    unless passenger_car.number_free_seats == 0
      passenger_car.take_the_seat
      puts "Готово, место в пассажирском вагоне заполнено"
    else
      puts "Все места в данном вагоне заполнены("
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

  def create_cargo_car_instance(volume)
    CargoCar.new(volume)
  end

  def passenger_car_instance(number_of_seats)
    PassengerCar.new(number_of_seats)
  end
end