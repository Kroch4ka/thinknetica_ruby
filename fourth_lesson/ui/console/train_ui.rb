require_relative '../../controller/train_controller'
require_relative '../../controller/route_controller'
require_relative '../../controller/wagon_controller'
require_relative 'base_console_ui'
require_relative 'route_ui'

class TrainConsoleUI < BaseConsoleUI
  class << self
    def goto_create_train_mode
      puts 'Вы в режиме создания поезда!'
      return if stop_command_request

      loop do
        puts 'Введите, пожалуйста, номер поезда'
        print 'Номер: '
  
        train_number = gets.chomp

        unless validate_train_number train_number
          break if stop_command_request
          redo
        end

        puts 'Выберите его тип: '
        train_types = TrainController.get_train_types

        show_train_types train_types
        print 'Тип: '

        train_type_serial = gets.chomp.to_i

        unless validate_train_type(train_types, train_type_serial)
          break if stop_command_request
          redo
        end
        
        if TrainController.create_train(train_number, train_types[train_type_serial - 1])
          puts 'Успешно!'
        else
          puts 'Что-то пошло не так! Попробуйте, пожалуйста, ещё раз!'
        end
  
        break if stop_command_request
      end
    end
    
    def goto_choose_train_for_manage_mode
      puts 'Вы в режиме управления поездом!'
      return if stop_command_request

      loop do
        puts 'Выберите, пожалуйста, интересующий поезд из представленных ниже:'
        trains = TrainController.get_trains

        show_trains trains

        train_serial = gets.chomp.to_i

        if validate_serial_number(trains, train_serial)
          puts 'Успешно!'
          train = trains[train_serial - 1]
          goto_manage_train_mode train
        else
          puts 'Некорректный выбор( Пожалуйста, попробуйте ещё раз!'
        end
      end
    end

    private

    def goto_manage_train_mode(chosen_train)
      puts "Вы выбрали поезд: #{chosen_train.number}"
      puts "Что планируете сделать?"

      command = gets.chomp

      manage_train_dispatcher(chosen_train, command)
    end

    def manage_train_dispatcher(chosen_train, command)
      case command
      when '1' then set_route_to_chosen_train_mode chosen_train
      when '2' then add_wagon_to_chosen_train chosen_train
      when '3' then unhook_wagon_to_chosen_train chosen_train
      when '4' then move_chosen_train_along_route_mode chosen_train
      end
    end

    def set_route_to_chosen_train_mode(chosen_train)
      loop do
        puts 'Вы выбрали установку маршрута на выбранный поезд'
        puts 'Вам доступны следующие маршруты для установки'
        routes = RouteController.get_routes
        RouteConsoleUI.show_routes routes

        route_serial_number = gets.chomp.to_i

        if validate_serial_number(routes, route_serial) && TrainController.set_route_to_train(chosen_route, routes[route_serial_number - 1])
          puts 'Успешно!'
        else
          puts 'Что-то пошло не так( Попробуйте ещё!'
        end

        break if stop_command_request
      end
    end

    def add_wagon_to_chosen_train(chosen_train)
      if WagonController.add_wagon_to_train chosen_train
        puts "Отлично, вагон был добавлен! Теперь у поезда: #{chosen_train.wagons.size} вагонов"
      else
        puts 'Что-то пошло не так с добавлением вагона( Попробуйте, пожалуйста, заново!'
      end
    end

    def unhook_wagon_to_chosen_train(chosen_train)
      if WagonController.unhook_wagon_from_train(chosen_train)
        puts "Отлично! Вагон был отцеплен! Теперь у поезда: #{chosen_train.wagons.size} вагонов"
      else
        puts 'Что-то пошло не так с отцепкой вагона!( Попробуйте, пожалуйста, заново!'
      end
    end

    def move_chosen_train_along_route_mode(chosen_train)
      puts 'Вы выбрали режим перемещения поезда!'

      unless chosen_train.route
        puts 'Поезду ещё не задан маршрут! Установите сначала маршрут!'
        return
      end

      loop do
        next_station = chosen_train.get_next_station
        prev_station = chosen_train.get_prev_station
        current_station = chosen_train

        puts "Куда хотите поехать? Текущая станция: #{current_station.name}"

        puts "1) Вперёд, к станции: #{next_station.name}"
        puts "2) Назад, к станции: #{prev_station.name}"

        command = gets.chomp

        move_chosen_train_actions_dispatcher(chosen_train, command)

        break if stop_command_request
      end
    end

    def move_chosen_train_actions_dispatcher(chosen_train, command)
      case command
      when '1' then move_up_chosen_train chosen_train
      when '2' then move_down_chosen_train chosen_train
      else puts 'Неизвестная команда('
      end
    end

    def move_up_chosen_train(chosen_train)
      if TrainController.move_up chosen_train
        puts "Отлично! Теперь поезд находится на станции: #{chosen_train.get_current_station.name}"
      else
        puts 'Что-то пошло не так с движением поезда вперёд! Попробуй ещё раз!'
      end
    end

    def move_down_chosen_train(chosen_train)
      if TrainController.move_down chosen_train
        puts "Отлично! Теперь поезд находится на станции: #{chosen_train.get_current_station.name}"
      else
        puts 'Что-то пошло не так с движением поезда вперёд! Попробуй ещё раз!'
      end
    end

    def validate_train_type(train_types, chosen_type_serial)
      unless validate_serial_number(train_types, chosen_type_serial)
        puts 'Некорректный тип поезда( Попробуйте, пожалуйста, ещё!'
        return false
      end

      true
    end

    def validate_train_number(number)
      if number.size == 0
        puts 'Номер не должен быть пустым'
        return false
      end

      true
    end

    def show_train_types(types)
      types.each_with_index do |type, index|
        puts "#{index + 1}) #{type.to_s}"
      end
    end

    def show_trains(trains)
      trains.each_with_index do |train, index|
        puts "#{index + 1}) #{train.number}"
      end
    end
  end
end