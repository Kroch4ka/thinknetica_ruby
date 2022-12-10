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
  
  puts 'Введите порядковый номер типа создаваемого поезда - 1) Грузовой; 2) Пассажирский;'
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

  print 'Номер действия: '

  action = gets.chomp
  
  case action
  when '1' then set_route_to_train train
  when '2' then add_wagon_to_train train
  when '3' then unhook_wagon train
  when '4' then move_up_train train
  when '5' then move_down_train train
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
  puts 'Успешно!' if train.attach_wagon
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

  if station.trains.empty?
    puts 'На данной станции поездов нет('
  else
    show_items(station.trains) { |train| train.number } 
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
    puts "#{index + 1}) #{block.call(item)}"
  end
end

main_loop