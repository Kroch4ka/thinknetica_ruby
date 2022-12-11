require_relative 'boot'

$stations = []
$trains = []
$routes = []

def create_station
  puts 'Введите название станции: '
  name = gets.chomp
  puts 'Успешно!' if $stations << Station.new(name)
rescue ValidationError => e
  puts e.message
  puts 'Пробуй ещё!'
  retry
end

def create_train
  puts 'Введите номер поезда'
  number = gets.chomp
  print 'Номер: '
  
  puts 'Введите порядковый номер типа создаваемого поезда:'
  puts '1) Грузовой'
  puts '2) Пассажирский'

  print 'Порядковый номер: '
  type = gets.chomp
  $trains << if type == '1'
              puts 'Успешно!'
              CargoTrain.new number
            elsif type == '2'
              puts 'Успешно!'
              PassengerTrain.new number
            else
              puts 'Некорректный вариант!'
              return
            end
rescue ValidationError => e
  puts e.message
  puts 'Пробуй ещё!'
  retry
end

def create_route
  if $stations.size < 2
    puts 'Недостаточно станций для создания маршрута.'
    return
  end

  puts 'Выберите начальную и конечную станции для создания маршрута'
  show_items($stations) { |station| station.name }
  first_station = $stations[gets.chomp.to_i - 1]
  print 'Начальная станция: '

  unless first_station
    puts 'Некорректный вариант начальной станции'
    return
  end

  second_station = $stations[gets.chomp.to_i - 1]
  print 'Конечная станция: '
  unless second_station
    puts 'Некорректный вариант конечной станции'
    return
  end
  $routes << Route.new(first_station, second_station)
end

def manage_route
  if $routes.empty?
    puts 'Нет созданных маршрутов!'
    return
  end

  route = nil

  puts 'Выберите маршрут для управления'
  show_items($routes) { |route| route.name }
  route = $routes[gets.chomp.to_i - 1]

  unless route
    puts 'Некорректный вариант!'
    return
  end

  puts 'Выберите необходимое действие для выбранного маршрута'
  puts '1) Добавить станцию'
  puts '2) Удалить станцию'

  action = gets.chomp.to_i
  case action
  when 1 then add_station_to_route route
  when 2 then destroy_station_to_route route
  else
    puts 'Некорректное действие!'
    return
  end
end

def add_station_to_route(route)
  if $stations.empty?
    puts 'Нет созданных станций!'
    return
  end

  puts 'Выберите необходимую станцию'
  show_items($stations) { |station| station.name }
  print 'Станция:'
  station = $stations[gets.chomp.to_i - 1]

  unless station
    puts 'Некорректно выбранный вариант!'
    return
  end

  puts 'Успешно!' if route.add_intermediate_station station
end

def destroy_station_to_route(route)
  intermediate_stations = route.intermediate_stations

  if intermediate_stations.empty?
    puts 'Не заданы промежуточные станции!'
    return
  end

  puts 'Выберите станцию для удаления'
  show_items(intermediate_stations) { |station| station.name }
  print 'Станция:'
  station = intermediate_stations[gets.chomp.to_i - 1]

  unless station
    puts 'Некорректный вариант!'
    return
  end

  puts 'Успешно!' if route.destroy_intermediate_station station
end

def manage_train
  if $trains.empty?
    puts 'На данный момент созданных поездов нет!'
    return
  end

  puts 'Выберите поезд'

  show_items($trains) { |train| train.number }
  train = $trains[gets.chomp.to_i - 1]

  unless train
    puts 'Некорректный вариант!'
    return
  end

  puts 'Выберите порядковый номер действия с выбранным поездом'
  
  puts '1) Установить маршрут поезду'
  puts '2) Добавить вагон'
  puts '3) Отцепить вагон'
  puts '4) Перемесить поезд вперёд'
  puts '5) Переместить поезд назад'
  puts '6) Посмотреть информацию по поезду'
  puts '7) Управлять вагоном'

  print 'Номер действия: '

  action = gets.chomp
  
  case action
  when '1' then set_route_to_train train
  when '2' then add_wagon_to_train train
  when '3' then unhook_wagon train
  when '4' then move_up_train train
  when '5' then move_down_train train
  when '6' then show_train_detail train
  when '7' then manage_wagon train
  else 
    puts 'Некорректный вариант!'
    return
  end
end

def set_route_to_train(train)
  if $routes.empty?
    puts 'У Вас нет созданных маршрутов!'
    return
  end

  puts 'Выберите маршрут для выбранного поезда'
  show_items($routes) { |route| route.name }
  route = $routes[gets.chomp.to_i - 1]

  unless route
    puts 'Некорректный вариант!'
    return
  end

  puts 'Успешно!' if train.set_route route
end

def add_wagon_to_train(train)
  case train.type
  when :cargo then add_cargo_wagon_to_train train
  when :passenger then add_passenger_wagon_to_train train
  else puts 'Некорректный тип поезда!'
  end
end

def add_passenger_wagon_to_train(train)
  puts 'Введите, пожалуйста, общее количество мест в создаваемом вагоне!'
  total_seats = gets.chomp.to_i

  puts 'Успешно!' if train.attach_wagon(PassengerWagon.new total_seats)
end

def add_cargo_wagon_to_train(train)
  puts 'Введите, пожалуйста, общий объём грузового вагона!'
  volume = gets.chomp.to_i

  puts 'Успешно' if train.attach_wagon(CargoWagon.new volume)
end

def unhook_wagon(train)
  puts 'Успешно' if train.unhook_wagon
end

def move_up_train(train)
  unless train.has_route?
    puts 'Маршрут поезду не установлен!'
    return
  end

  puts 'Успешно' if train.move_up
end

def move_down_train(train)
  unless train.has_route?
    puts 'Маршрут поезду не установлен!'
    return
  end

  puts 'Успешно' if train.move_down
end

def show_train_detail(train)
  case train.type
  when :passenger then show_passenger_train_detail train
  when :cargo then show_cargo_train_detail train
  end
end

def show_passenger_train_detail(train)
  puts 'Информация по выбранному пассажирскому поезду: '
  show_items(train.each) { |wagon| "Общее количество мест: #{wagon.total_seats}; Количество занятых: #{wagon.total_occupied};" }
end

def show_cargo_train_detail(train)
  puts 'Информация по выбранному грузовому поезду: '
  show_items(train.each) { |wagon| "Общий объём: #{wagon.volume}; Занятый объём: #{wagon.occupied_volume};" }
end

def manage_wagon(train)
  puts 'Выберите номер вагона для управления'
  show_items(train.each)
  target_wagon = train.each[gets.chomp.to_i]
  
  unless target_wagon
    puts 'Некорректный номер вагона!!'
    return
  end

  puts 'Выберите, пожалуйста, порядковый номер предложенного действия!'
  action = gets.chomp.to_i

  case train.type
  when :passenger then puts '1) Занять место'
  when :cargo then puts '1) Занять объём'
  end

  action = gets.chomp.to_i

  if action == 1 && train_type == :passenger
    take_place_in_passenger_wagon
  elsif action == 2 && train_type == :cargo
    take_volume_in_cargo_wagon
  else
    puts 'Некорректная команда!'
    return
  end
end

def take_volume_in_cargo_wagon(wagon)
  puts "Введите объём, который необходимо занять! Можно только: #{wagon.get_free_volume}"
  volume = gets.chomp
  print 'Объём: '

  if volume > wagon.get_free_volume
    puts 'Вы указали больше чем нужно!'
  else
    puts 'Успешно' if wagon.take_volume volume
  end
end

def take_place_in_passenger_wagon(wagon)
  if wagon.has_empty_seats?
    puts 'Успешно' if wagon.take_the_place
  else
    puts 'Свободных мест, к сожалению, нет'
  end
end

def show_station_detail
  if $stations.empty?
    puts 'У Вас нет созданных станций'
    return
  end

  puts 'Выберите станцию для просмотра более детальной информации'
  show_items($stations) { |station| station.name }
  station = $stations[gets.chomp.to_i - 1]

  unless station
    puts 'Некорректно выбранный вариант!'
    return
  end

  train_type_message = 
    case train.type
    when :passenger then 'Пассажирский'
    when :cargo then 'Грузовой'
    end                

  if station.trains.empty?
    puts 'На данной станции поездов нет('
  else
    show_items(station.each) { |train| "Номер поезда: #{train.number}. Тип: #{train_type_message}. Количество вагонов: #{train.each.size}"}
  end
end

def main_loop
  stop_command = 'stop'
  puts 'Вас приветствует программулька!'
  loop do
    puts "Выберите пункт, который Вас интересует или введите: #{stop_command}"
    puts '1) Создавать станции'
    puts '2) Создавать поезда'
    puts '3) Создавать маршруты'
    puts '4) Управление маршрутом'
    puts '5) Управление поездом'
    puts '6) Просмотр станций'

    action = gets.chomp
    case action
    when '1' then create_station
    when '2' then create_train
    when '3' then create_route
    when '4' then manage_route
    when '5' then manage_train
    when '6' then show_station_detail
    when stop_command then return
    else puts 'Некорректная команда!'
    end
  end
end

def show_items(items, &block)
  items.each_with_index do |item, index|
    message = block_given? ? block.call(item) : ''
    puts "#{index + 1}) #{message}"
  end
end

main_loop